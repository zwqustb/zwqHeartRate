//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LineChartView.h is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import <SciChart/SciChart.h>
#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
@protocol HeartRateDelegate
@end
@interface HeartRateModule : NSObject<AVCaptureVideoDataOutputSampleBufferDelegate>
@property(nonatomic, retain)NSMutableArray* points;
-(void)startMeasure;
-(void)stopMeasure;
-(float)getPulse;
-(float)getFrame;
-(int)getHRV;
-(void)setTorchLevel:(float)fLevel;
-(void)setTorchState:(BOOL)bOpen;
-(void)setFps:(int)nfps;
@end
