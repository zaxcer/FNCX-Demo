//
//  FnContentViewController.m
//  FNCX-Demo
//
//  Created by Zark on 6/30/16.
//  Copyright © 2016 imzark. All rights reserved.
//

#import "FnContentViewController.h"
#import "FnHeaderView.h"
#import "PNChart.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATION_BAR_HEIGHT 44
#define TAB_BAR_HEIGHT 49

#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

static CGFloat labelHeight = 20;
static CGFloat lineChartInsetX = 10;
static CGFloat lineChartInsetY = 10;

@interface FnContentViewController ()
@property (assign) NSInteger pageNumber;
@property (nonatomic, strong) FnHeaderView *headerView;
@property (nonatomic, strong) UITableView *tableView;
//@property (nonatomic, strong) NSArray *dataArray;
//@property (nonatomic, strong) NSArray *dataArray_up;
//@property (nonatomic, strong) NSArray *dataArray_down;
//@property (nonatomic, strong) NSArray *dataArray_wobble;
@property (nonatomic, strong) PNLineChart *lineChart;
@property (nonatomic, strong) PNLineChartData *lineChartData;
@property (nonatomic, strong) PNCircleChart *circleChart;
@end

@implementation FnContentViewController

- (id)initWithPageNumber:(NSUInteger)page
{
    if (self = [super init])
    {
        _pageNumber = page;
    }
    return self;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    //---------
    //TODO: ARRAY = DIC[PAGE]
    //---------
//    self.dataArray_up = [NSArray array];//临时方案
//    self.dataArray_down = [NSArray array];
//    self.dataArray_wobble = [NSArray array];
    
//    self.dataArray = [NSArray array];

/*
 *
 *
    //SETUP HEADERVIEW
    self.headerView = [[FnHeaderView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), (SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT)/2)];
    self.headerView.label.text = [NSString stringWithFormat:@"Number %ld", (long)_pageNumber+1];
    [self.view addSubview:_headerView];
 *
 *
 */
    //创建标签
    FnHeaderView *testView = [[FnHeaderView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:testView];
    
    //CREATE CIRCLEC CHART
    [self createCircleChart];
    
    //SETUP LINE CHATR DATA
    [self setupLineChartData];
    //CREATE LINE CHART
    [self createLineChart];
}

//--------------------------------------------------------------------------------------------
//   CircleChart
//--------------------------------------------------------------------------------------------

-(void)createCircleChart {

    
    self.circleChart = [[PNCircleChart alloc]
                        initWithFrame:CGRectMake(lineChartInsetX, labelHeight+lineChartInsetY, SCREEN_WIDTH-lineChartInsetX*2, (SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)/2-labelHeight-lineChartInsetY*2)
                        total:[NSNumber numberWithInt:1]
                        current:[NSNumber numberWithFloat:0]
                        clockwise:YES
                        shadow:YES shadowColor:PNGrey
                        displayCountingLabel:YES overrideLineWidth:[NSNumber numberWithInt:10]];
    
    self.circleChart.backgroundColor = [UIColor clearColor];
    self.circleChart.countingLabel.font = [UIFont italicSystemFontOfSize:50];
    
    //SETUP CIRCLE COLOR
    switch (_pageNumber) {
        case 0:
            [self.circleChart setStrokeColor:PNFreshGreen];
            break;
        case 1:
            [self.circleChart setStrokeColor:PNMauve];
            break;
        case 2:
            [self.circleChart setStrokeColor:PNYellow];
            
        default:
            break;
    }
    
    [self.view addSubview:self.circleChart];
}


//--------------------------------------------------------------------------------------------
//   LineChart
//   TODO: LIFE CIRCLE OF BOTH SELF AND SCROLLVIEW
//--------------------------------------------------------------------------------------------

- (void)createLineChart {
    self.lineChart = [[PNLineChart alloc]
                              initWithFrame:CGRectMake(lineChartInsetX, (SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)/2+labelHeight+lineChartInsetY, SCREEN_WIDTH-lineChartInsetX*2, (SCREEN_HEIGHT-STATUS_BAR_HEIGHT-NAVIGATION_BAR_HEIGHT-TAB_BAR_HEIGHT)/2-lineChartInsetY*2-labelHeight)];
    
    [self.lineChart setXLabels:@[@"9:00",@"10:00",@"11:00",@"12:00",@"13:00",@"14:00",@"15:00"]];
    [self.lineChart setYLabels:@[@"0", @"0.2", @"0.4", @"0.6", @"0.8", @"1.0"]];
    
    self.lineChart.yFixedValueMax = 1.0;
    self.lineChart.yFixedValueMin = 0.0;
    
    //SETUP LINE CONFIG
    
    _lineChart.backgroundColor = [UIColor clearColor];
    _lineChart.axisColor = [UIColor blackColor];
    _lineChart.showCoordinateAxis = YES;
    _lineChart.showYGridLines = YES;
    _lineChart.showGenYLabels = NO;
    _lineChart.legendStyle = PNLegendItemStyleSerial;
    
    self.lineChart.chartData = @[self.lineChartData];

    [self.view addSubview:self.lineChart];
    

    /*---------
     *  TODO
     *---------
     *若有用户与折线交互可选delegate方法
     *比如点击某点显示该点数值
     
     lineChart.delegate = self;
     
     */
}

-(void)setupLineChartData {
    self.lineChartData = [PNLineChartData new];

    self.lineChartData.dataTitle = @"index";
    self.lineChartData.alpha = 0.7f;
    self.lineChartData.inflexionPointStyle = PNLineChartPointStyleCircle;
    
    //SETUP LINE COLOR
    switch (_pageNumber) {
        case 0:
            self.lineChartData.color = PNFreshGreen;
            self.lineChartData.inflexionPointColor = PNFreshGreen;
            break;
        case 1:
            self.lineChartData.color = PNMauve;
            self.lineChartData.inflexionPointColor = PNMauve;
            break;
        case 2:
            self.lineChartData.color = PNYellow;
            self.lineChartData.inflexionPointColor = PNYellow;
            
        default:
            break;
    }
    NSArray *tempArray = [NSArray array];
    
    self.lineChartData.getData = ^(NSUInteger index) {
        CGFloat yValue = [tempArray[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
}

//-(void)updateData {
//    self.dataArray_up = @[@"0.55",@"0.45",@"0.5",@"0.65",@"0.6"];
//    self.dataArray_down = @[@"0.35",@"0.35",@"0.4",@"0.3",@"0.25"];
//    self.dataArray_wobble = @[@"0.1",@"0.2",@"0.1",@"0.05",@"0.15"];
//    
//    switch (_pageNumber) {
//        case 0:
//            _dataArray = _dataArray_up;
//            break;
//        case 1:
//            _dataArray = _dataArray_down;
//            break;
//        case 2:
//            _dataArray = _dataArray_wobble;
//            break;
//        default:
//            break;
//    }
//    
//    /*---------
//     *  TODO
//     *---------
//    fresh random dataArray
//     *
//     *
//     */
//}


-(void)setChartData:(NSArray *)array {
    self.circleChart.current = [NSNumber numberWithFloat:[array.lastObject floatValue]];
    
    self.lineChartData.getData = ^(NSUInteger index) {
        CGFloat yValue = [array[index] floatValue];
        return [PNLineChartDataItem dataItemWithY:yValue];
    };
    self.lineChartData.itemCount = array.count;
    self.lineChart.chartData = @[self.lineChartData];
    
    //LineChat 保持
    [self.lineChart strokeChart];

}

-(void)animateChart {
    [self.circleChart strokeChart];
//    [self.lineChart strokeChart];
}


@end
