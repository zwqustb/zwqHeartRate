//
//  HeartRateChart.m
//  HeartRate
//
//  Created by zhangwenqiang on 2018/8/3.
//  Copyright © 2018年 zhangwenqiang. All rights reserved.
//
//  old

#import "HeartRateChart.h"
#import "DoubleSeries.h"
#import "MedicalFadeOutPaletteProvider.h"
@implementation HeartRateChart
+(void)initChartView:(SCIChartSurface *) surface{
    // sci chart 背景色
    [[surface style] setBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]]];
    SCIAxisStyle *_axisStyle = [[SCIAxisStyle alloc]init];
    [[surface style] setSeriesBackgroundBrush:[[SCISolidBrushStyle alloc] initWithColor:[UIColor whiteColor]]];
    BOOL bShowText = false;
    _axisStyle.drawLabels = bShowText;
    _axisStyle.drawMajorBands = bShowText;
    _axisStyle.drawMajorGridLines = bShowText;
    _axisStyle.drawMinorGridLines = bShowText;
    _axisStyle.drawMajorTicks = bShowText;
    _axisStyle.drawMinorTicks = bShowText;
    
    id<SCIAxis2DProtocol> xAxis = [SCINumericAxis new];
    xAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    xAxis.style = _axisStyle;
    //     xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-3.0) Max:SCIGeneric(2.7)];
    xAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0) Max:SCIGeneric(100)];
    
    id<SCIAxis2DProtocol> yAxis = [SCINumericAxis new];
    yAxis.style = _axisStyle;
    yAxis.growBy = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(0.1) Max:SCIGeneric(0.1)];
    yAxis.visibleRange = [[SCIDoubleRange alloc] initWithMin:SCIGeneric(-.5) Max:SCIGeneric(.5)];
      //  [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
    [surface.xAxes add:xAxis];
    [surface.yAxes add:yAxis];
    //        [self.surface.renderableSeries add:rSeries];
//            surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
    
    //        [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
       // }];
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
//    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc] init];
//    dataSeries.acceptUnsortedData = true;
    SCIXyDataSeries * dataSeries = [[SCIXyDataSeries alloc]initWithXType:SCIDataType_Double YType:SCIDataType_Double SeriesType:SCITypeOfDataSeries_DefaultType];
        dataSeries.acceptUnsortedData = true;
       // dataSeries.fifoCapacity = 246;
        [dataSeries appendRangeX:dSeries.xValues Y:dSeries.yValues Count:dSeries.size];
    UIColor *_seriesColor = [UIColor greenColor];
    float _stroke = 1.5;
   // int _fifoSize = 246;
    
    SCILineSeriesStyle * style = [SCILineSeriesStyle new];
    style.linePen = [[SCISolidPenStyle alloc] initWithColor:_seriesColor withThickness:_stroke];
    SCIPaletteProvider *_objcFadeOutPalette = [[SCIPaletteProvider alloc]init];
    
    
    SCIFastLineRenderableSeries * rSeries = [SCIFastLineRenderableSeries new];
    rSeries.paletteProvider = _objcFadeOutPalette;
    SCILineSeriesStyle * lineStyle = [SCILineSeriesStyle new];
    lineStyle.linePen = [[SCISolidPenStyle alloc] initWithColor:[UIColor greenColor] withThickness:1];
    rSeries.style = lineStyle;
    rSeries.dataSeries = dataSeries;
    
    SCIXAxisDragModifier * xDragModifier = [SCIXAxisDragModifier new];
    xDragModifier.dragMode = SCIAxisDragMode_Pan;
    xDragModifier.clipModeX = SCIZoomPanClipMode_None;
    
    SCIYAxisDragModifier * yDragModifier = [SCIYAxisDragModifier new];
    yDragModifier.dragMode = SCIAxisDragMode_Pan;
   // [SCIUpdateSuspender usingWithSuspendable:surface withBlock:^{
        [surface.renderableSeries clear];
        [surface.renderableSeries add:rSeries];
      //  surface.chartModifiers = [[SCIChartModifierCollection alloc] initWithChildModifiers:@[[SCIPinchZoomModifier new], [SCIZoomExtentsModifier new], [SCIZoomPanModifier new]]];
        //  [rSeries addAnimation:[[SCISweepRenderableSeriesAnimation alloc] initWithDuration:3 curveAnimation:SCIAnimationCurve_EaseOut]];
    //}];
    [surface invalidateElement];
}
@end
