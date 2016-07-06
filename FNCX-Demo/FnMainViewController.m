//
//  FnMainViewController.m
//  FNCX-Demo
//
//  Created by Zark on 6/29/16.
//  Copyright © 2016 imzark. All rights reserved.
//

#import "FnMainViewController.h"
#import "FnContentViewController.h"
#import "FnHeaderView.h"

#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height

#define NAVIGATION_BAR_HEIGHT 44
#define TAB_BAR_HEIGHT 49

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static NSString *index_name_key = @"index_name";
static NSString *index_array_key = @"index_array";


@interface FnMainViewController ()

//@property(nonatomic, strong) UINavigationBar *navigationBar;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UIView *backgroundView;
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, strong) UIPageControl *pageControl;
@property (nonatomic) NSUInteger lastPage;
@property (nonatomic, strong) NSMutableArray *contentViewControllers;

@end

@implementation FnMainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSString *path = [[NSBundle mainBundle] pathForResource:@"index_thing" ofType:@"plist"];
    
    //UPDATE DATA
    self.indexList = [NSArray arrayWithContentsOfFile:path];

    //创建背景视图
    [self createBackgroundView];
    
    //创建标题
    [self createTitleLabel];
    
    //创建ScrollView及PageControll
    [self createScrollView];
    
    //创建下拉刷新控件
    
    //发送请求
}

//------------------------------------------------------------------------------------------
// MARK: - TitleLabel -
//------------------------------------------------------------------------------------------

-(void)createTitleLabel {
    self.titleLabel = [[UILabel alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-80)/2, STATUS_BAR_HEIGHT, 80, NAVIGATION_BAR_HEIGHT)];
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    self.titleLabel.textColor = [UIColor whiteColor];
    self.titleLabel.text = @"default";
    [self.view addSubview:self.titleLabel];
}

-(void)updateTitleLabel {
    NSDictionary *index_dic = self.indexList[self.pageControl.currentPage];
    self.titleLabel.text = index_dic[index_name_key];
}


//------------------------------------------------------------------------------------------
// MARK: - ScrollView & PageControll -
//------------------------------------------------------------------------------------------

-(void)createBackgroundView {
    self.backgroundView = [[UIView alloc] initWithFrame:SCREEN_BOUNDS];
    self.backgroundView.backgroundColor = UIColorFromRGB(0xBFEFFF);//设置背景颜色或图片
    [self.view addSubview:self.backgroundView];
}

-(void)createScrollView {
    NSUInteger numberPages = self.indexList.count;
    
    NSMutableArray *controllers = [[NSMutableArray alloc] init];
    for (NSUInteger i = 0; i < numberPages; i++)
    {
        [controllers addObject:[NSNull null]];
    }
    self.contentViewControllers = controllers;
    
    //创建ScrollView
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, STATUS_BAR_HEIGHT+NAVIGATION_BAR_HEIGHT, SCREEN_WIDTH, SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)];
    self.scrollView.contentSize = CGSizeMake(SCREEN_WIDTH * numberPages, CGRectGetHeight(self.scrollView.frame));
    
    _scrollView.pagingEnabled                   = YES;          //
    _scrollView.scrollEnabled                   = YES;          //
    _scrollView.bounces                         = YES;          //
    _scrollView.alwaysBounceVertical            = NO;           //
    _scrollView.showsVerticalScrollIndicator    = NO;           //
    _scrollView.showsHorizontalScrollIndicator  = NO;           //
    self.scrollView.delegate = self;
    
    //PageControll
    self.pageControl = [[UIPageControl alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-40)/2, NAVIGATION_BAR_HEIGHT+5, 40, 20)];
    self.pageControl.userInteractionEnabled = NO;
    self.pageControl.numberOfPages = numberPages;
    self.pageControl.transform = CGAffineTransformMakeScale(0.7, 0.7);
    self.pageControl.currentPage = 0;
    
    [self updateTitleLabel];
    
    [self.view addSubview:self.scrollView];
    [self.view addSubview:self.pageControl];
    
    [self loadScrollViewWithPage:0];
    [self loadScrollViewWithPage:1];
    
    //SETUP ANIMATE PAGE0
    FnContentViewController *controller0 = [self.contentViewControllers objectAtIndex:0];
    
    [controller0 animateChart];
    
}

-(void)loadScrollViewWithPage:(NSUInteger)page {
    if (page >= self.indexList.count)
        return;
    FnContentViewController *controller = [self.contentViewControllers objectAtIndex:page];
    if ((NSNull *)controller == [NSNull null])
    {
        controller = [[FnContentViewController alloc] initWithPageNumber:page];
        [self.contentViewControllers replaceObjectAtIndex:page withObject:controller];
    }
    
    // add the controller's view to the scroll view
    if (controller.view.superview == nil) {
        CGRect frame = self.scrollView.frame;
        frame.origin.x = CGRectGetWidth(frame) * page;
        frame.origin.y = 0;
        controller.view.frame = frame;
        
        [self addChildViewController:controller];
        [self.scrollView addSubview:controller.view];
    }
    
//******重置动画，再次设置data，等待下次出现时的animate******
    
    NSArray *tempArray = [NSArray array];
    [controller setChartData:tempArray];
    [controller animateChart];
    [controller setChartData:self.indexList[page][index_array_key]];
    
}

//------------------------------------------------------------------------------------------
// MARK: - ScrollView Delegate -
//------------------------------------------------------------------------------------------

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    // switch the indicator when more than 50% of the previous/next page is visible
    
    NSUInteger page = scrollView.contentOffset.x / _scrollView.frame.size.width;
    
    self.pageControl.currentPage = page;
    
    if(page != self.lastPage) {
    
        FnContentViewController *controller = [self.contentViewControllers objectAtIndex:page];
        if (controller) {
            [controller animateChart];
        }
    
        //改变导航栏标题
        [self updateTitleLabel];
    
        // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
        [self loadScrollViewWithPage:page - 1];
        //    [self loadScrollViewWithPage:page];
        [self loadScrollViewWithPage:page + 1];
    
        self.lastPage = page;
    }
}











/*点击白点跳转的方法，不太好用，禁止掉了----------------------------------------------------------
 *
 *
- (void)gotoPage:(BOOL)animated
{
    NSInteger page = self.pageControl.currentPage;
    
    // load the visible page and the page on either side of it (to avoid flashes when the user starts scrolling)
    [self loadScrollViewWithPage:page - 1];
    [self loadScrollViewWithPage:page];
    [self loadScrollViewWithPage:page + 1];
    
    // update the scroll view to the appropriate page
//    CGRect bounds = self.scrollView.bounds;
//    bounds.origin.x = CGRectGetWidth(bounds) * page;
//    bounds.origin.y = 0;
//    [self.scrollView scrollRectToVisible:bounds animated:animated];
    [self.scrollView setContentOffset:CGPointMake(self.scrollView.frame.size.width * page, 0)];

}

- (IBAction)changePage:(id)sender
{
    [self gotoPage:YES];    // YES = animate
}

*
*-------------------------------------------------------------------------------------------
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
