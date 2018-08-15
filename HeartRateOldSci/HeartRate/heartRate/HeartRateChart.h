//
//  HeartRateChart.h
//  HeartRate
//
//  Created by zhangwenqiang on 2018/8/3.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <SciChart/SciChart.h>
@interface HeartRateChart : NSObject
+(void)initChartView:(SCIChartSurface *) surface;
+(void)drawPoints:(NSArray*)points onView:(SCIChartSurface *) surface;
@end
