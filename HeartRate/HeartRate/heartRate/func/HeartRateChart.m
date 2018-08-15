//
//  HeartRateChart.m
//  HeartRate
//
//  Created by zhangwenqiang on 2018/8/3.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//

#import "HeartRateChart.h"
#import "DoubleSeries.h"

@implementation HeartRateChart
+(void)initChartView:(SCIChartSurface *) surface{

    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    //     xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-3.0) Max:SCIGeneric(2.7)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(100)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-.5) Max:SCIGeneric(.5)];
        [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
            [surface.xAxes add:xAxis];
            [surface.yAxes add:yAxis];
    //        [self.surface.renderableSeries add:rSeries];
            surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
    
    //        [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
        }];
}
#pragma draw point
+(void)drawPoints:(NSArray*)points onView:(SCIChartSurface *) surface{
    if (points == nil) {
        return;
    }
    DoubleSeries * dSeries = [[DoubleSeries alloc]init];
    float x = 0;
    for (int i = 0;i<points.count;i++) {

        NSNumber* numY = points[i];
           [dSeries addX:x Y:numY.floatValue];
        float xStep = 1;//floorf(50/fps);
        x+=xStep;
    }
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] initWithXType:SCIDataType_Float YType:SCIDataType_Float];
    dataSeries.acceptUnsortedData = true;
        [dataSeries appendRangeX:dSeries.xValues Y:dSeries.yValues Count:dSeries.size];
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.strokeStyle = [[SCISolidPenStyle alloc] initWithColorCode:0xFF279B27 withThickness:1.0];
    rSeries.dataSeries = dataSeries;
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
    [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.renderableSeries clear];
        [surface.renderableSeries add:rSeries];
        surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
        //  [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    }];
}
@end
