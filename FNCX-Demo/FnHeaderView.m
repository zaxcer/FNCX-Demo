//
//  FnHeaderView.m
//  FNCX-Demo
//
//  Created by Zark on 6/29/16.
//  Copyright © 2016 imzark. All rights reserved.
//

#import "FnHeaderView.h"

#define SCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define SCREEN_BOUNDS [UIScreen mainScreen].bounds
#define STATUS_BAR_HEIGHT [UIApplication sharedApplication].statusBarFrame.size.height
#define NAVIGATION_BAR_HEIGHT 44
#define TAB_BAR_HEIGHT 49

static CGFloat inset = 10;
static CGFloat labelHeight = 20;

@implementation FnHeaderView

-(instancetype) initWithFrame:(CGRect)frame {
    if(self = [super initWithFrame:frame]) {
        self.label = [[UILabel alloc]
                      initWithFrame:CGRectMake(inset, 0, SCREEN_WIDTH - inset*2, labelHeight)];
        self.label.textAlignment = NSTextAlignmentRight;
        self.label.text = @"10分钟前发布";
        self.label.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.label];
        
        
    }
    return self;
}

@end
