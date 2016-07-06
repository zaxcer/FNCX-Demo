//
//  FnContentViewController.h
//  FNCX-Demo
//
//  Created by Zark on 6/30/16.
//  Copyright © 2016 imzark. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FnContentViewController : UIViewController

-(id)initWithPageNumber:(NSUInteger)page;

//初始数值皆为0，由MainController控制数值和动画启动
-(void)setChartData:(NSArray*)array;
-(void)animateChart;

@end