//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// LineChartView.m is part of the SCICHART® Examples. Permission is hereby granted
// to modify, create derivative works, distribute and publish any part of this source
// code whether for commercial, private or personal use.
//
// The SCICHART® examples are distributed in the hope that they will be useful, but
// without any warranty. It is provided "AS IS" without warranty of any kind, either
// expressed or implied.
//******************************************************************************

#import "HeartRateModule.h"
#import <SciChart/SciChart.h>


#import "PulseDetector.h"
#import "Filter.h"
#import "HeartRateConfig.h"
typedef NS_ENUM(NSUInteger, CURRENT_STATE) {
    STATE_PAUSED,
    STATE_SAMPLING
};
int minFrameCount = 10;
@interface HeartRateModule ()
{
    AVCaptureSession *session;
    CALayer* imageLayer;
  //  NSMutableArray *points;
    NSTimer * timer;
    int nTimerSecond;

    int initialFliter;
    int fps;
}
@property(nonatomic, strong) UILabel* m_pLabel;
@property(nonatomic, strong) PulseDetector *pulseDetector;
@property(nonatomic, strong) Filter *filter;
@property(nonatomic, strong) AVCaptureDevice *device;
@property(nonatomic, assign) CURRENT_STATE currentState;
@property(nonatomic, assign) int validFrameCounter;


@end
@implementation HeartRateModule
@synthesize device = _device;
@synthesize points = _points;
- (void)startMeasure {
    fps = kHeartRateCameraFps;
    nTimerSecond = 0;


    [self initHeartRate];
    
    
    timer = [NSTimer scheduledTimerWithTimeInterval:1 target:self selector: @selector(onTimer) userInfo:nil repeats:YES];
    [timer fire];
}
-(void)stopMeasure{
    [self stopAVCapture];
    [timer invalidate];
    timer = nil;
}
- (void)dealloc
{
    [self stopMeasure];
}
-(void)onTimer{
    nTimerSecond += 1;
}
#pragma mark heart rate
//zwqbgn
-(void)initHeartRate{
    imageLayer = [CALayer layer];
    initialFliter = 1;
//  CGSize sz = self.layer.bounds.size;
//  CGSize sz = [[UIScreen mainScreen]bounds].size;
//  imageLayer.frame = CGRectMake(0, 0, sz.width, sz.height/2);
//  imageLayer.contentsGravity = kCAGravityResizeAspectFill;
//  [self.layer addSublayer:imageLayer];
    
    self.filter=[[Filter alloc] init];
    self.pulseDetector=[[PulseDetector alloc] init];
    
    self.currentState=STATE_SAMPLING;
    [self setupAVCapture];

}

- (void)setupAVCapture
{
    // Get the default camera device
    self.device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    
    // Create the AVCapture Session
    session = [AVCaptureSession new];
    [session beginConfiguration];
    
    // Create a AVCaptureDeviceInput with the camera device
    NSError *error = nil;
    AVCaptureDeviceInput *deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (error) {
//        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:[NSString stringWithFormat:@"Error %d", (int)[error code]]
//                                                            message:[error localizedDescription]
//                                                           delegate:nil
//                                                  cancelButtonTitle:@"OK"
//                                                  otherButtonTitles:nil];
//        [alertView show];
        //[self teardownAVCapture];
        return;
    }
    
    if ([session canAddInput:deviceInput])
        [session addInput:deviceInput];
    
    // AVCaptureVideoDataOutput
    
    AVCaptureVideoDataOutput *videoDataOutput = [AVCaptureVideoDataOutput new];
    NSDictionary *rgbOutputSettings = [NSDictionary dictionaryWithObject:
                                       [NSNumber numberWithInt:kCMPixelFormat_32BGRA] forKey:(id)kCVPixelBufferPixelFormatTypeKey];
    [videoDataOutput setVideoSettings:rgbOutputSettings];
    [videoDataOutput setAlwaysDiscardsLateVideoFrames:YES];
    dispatch_queue_t videoDataOutputQueue = dispatch_queue_create("VideoDataOutputQueue", DISPATCH_QUEUE_SERIAL);
    [videoDataOutput setSampleBufferDelegate:self queue:videoDataOutputQueue];
    
    if ([session canAddOutput:videoDataOutput])
        [session addOutput:videoDataOutput];
    AVCaptureConnection* connection = [videoDataOutput connectionWithMediaType:AVMediaTypeVideo];
    //    [connection setVideoMinFrameDuration:CMTimeMake(1, 10)];

    [self setFps:fps];
    [connection setVideoOrientation:AVCaptureVideoOrientationPortrait];
  

    [session commitConfiguration];
    [session startRunning];

    // update our UI on a timer every 0.1 seconds
//    [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(update) userInfo:nil repeats:YES];
}
-(void)setTorchState:(BOOL)bOpen{
    AVCaptureTorchMode pMode = bOpen ? AVCaptureTorchModeOn : AVCaptureTorchModeOff;
    if([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.device lockForConfiguration:nil];
        _device.torchMode=pMode;
        [self.device unlockForConfiguration];
    }
}
-(void)setTorchLevel:(float)fLevel{
    if (fLevel>0&&fLevel<1) {
        [self.device lockForConfiguration:nil];
        _device.torchMode=AVCaptureTorchModeOn;
        [self.device setTorchModeOnWithLevel:fLevel error:nil];
        [self.device unlockForConfiguration];
    }
    
}
-(void)setFps:(int)nfps{
    nTimerSecond = 0;
    fps = nfps;
    [self.device lockForConfiguration:nil];
    [self.device setActiveVideoMinFrameDuration:CMTimeMake(1, fps)];
    [self.device unlockForConfiguration];
}
-(void) pause {
    if(self.currentState==STATE_PAUSED) return;
    
    // switch off the torch
    if([self.device isTorchModeSupported:AVCaptureTorchModeOn]) {
        [self.device lockForConfiguration:nil];
        self.device.torchMode=AVCaptureTorchModeOff;
        [self.device unlockForConfiguration];
    }
    self.currentState=STATE_PAUSED;
    // let the application go to sleep if the phone is idle
    [UIApplication sharedApplication].idleTimerDisabled = NO;
}
- (void)stopAVCapture
{
    [self pause];
    [session stopRunning];
    session = nil;
    self.points = nil;
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection
{
    if(self.currentState==STATE_PAUSED) {
        // reset our frame counter
        self.validFrameCounter=0;
        return;
    }
    
    CVPixelBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    //    CVPixelBufferUnlockBaseAddress(imageBuffer, kCVPixelBufferLock_ReadOnly);
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    // void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    uint8_t *buf = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    float r = 0, g = 0,b = 0;
    for(int y = 0; y < height; y++) {
        for(int x = 0; x < width * 4; x += 4) {
            b += buf[x];
            g += buf[x+1];
            r += buf[x+2];
        }
        buf += bytesPerRow;
    }
    r /= 255 * (float)(width * height);
    g /= 255 * (float)(width * height);
    b /= 255 * (float)(width * height);
    
    float h,s,v;
    NSLog(@"r:%f,g:%f,b:%f",r,g,b);
    RGBtoHSV(r, g, b, &h, &s, &v);
    static float lastH = 0;
    float highPassValue = h - lastH;
    lastH = h;
    float lastHighPassValue = 0;
    float lowPassValue = (lastHighPassValue + highPassValue) / 2;
    lastHighPassValue = highPassValue;
    NSLog(@"s:%f,v:%f",s,v);
//     NSLog(@"h:%f",h);
    // do a sanity check to see if a finger is placed over the camera
    if(s>0.5 && v>0.2) {
        NSLog(@"h:%f",h);
        // increment the valid frame count
        self.validFrameCounter++;
        // filter the hue value - the filter is a simple band pass filter that removes any DC component and any high frequency noise
        float filtered;
        if (fps == 30) {
            filtered = PPG_Filter(h,initialFliter);
            if (nTimerSecond <= 5) {
                return;
            }
        }else{
            filtered=[self.filter processValue:h];
        }
        
        if (initialFliter) {
            initialFliter = 0;
        }
        NSLog(@"addedLowPassValue:%f",lowPassValue);
        lowPassValue = filtered;
        NSLog(@"filterlowPassValue:%f",lowPassValue);
        // have we collected enough frames for the filter to settle?
        if(self.validFrameCounter > minFrameCount)
        {
            // add the new value to the pulse detector
            [self.pulseDetector addNewValue:lowPassValue atTime:CACurrentMediaTime()];
            [self handleLowValue:lowPassValue ctx:context];
        }
    } else {
        //zwqbgn for 绘制
        //lowPassValue = 0;
        //zwqend
        self.validFrameCounter = 0;
        // clear the pulse detector - we only really need to do this once, just before we start adding valid samples
        [self.pulseDetector reset];
    }
//     [self handleLowValue:lowPassValue ctx:context];
    //    NSLog(@"addedLowPassValue:%f",lowPassValue);
 

    //zwqend
    

}
//MARK: 处理数据 并绘图
-(void)handleLowValue:(float)lowPassValue ctx:(CGContextRef)context{
    //zwqbgn
    float maxUp = 0.4;
    float fNoise = 0.8;
    if (isnan(lowPassValue)) {
        lowPassValue = 0;
        return;
    }
        if(lowPassValue>fNoise ||lowPassValue<-fNoise ){
            lowPassValue = 0;
            return;
        }
    if(lowPassValue>maxUp ){
        lowPassValue = 0;//maxUp;
    }else if (lowPassValue < -maxUp){
        lowPassValue = 0;//-maxUp;
    }
 //   if (fabsf(lowPassValue)<=maxUp) {
        [self render:context value:[NSNumber numberWithFloat:lowPassValue]];
   // }
}
- (void)render:(CGContextRef)context value:(NSNumber *)value
{
    if(!self.points)
        self.points = [NSMutableArray new];
    [self.points insertObject:value atIndex:0];
    CGRect bounds = [UIScreen mainScreen].bounds;
#pragma mark 是否显示更多
    
    while(self.points.count > bounds.size.width / 2)
        [self.points removeLastObject];
//    while(points.count > bounds.size.width * 2)
//    {
//        [self stopAVCapture];
//    }
    if(self.points.count == 0)
        return;

}

void RGBtoHSV( float r, float g, float b, float *h, float *s, float *v ) {
    float min, max, delta;
    min = MIN( r, MIN(g, b ));
    max = MAX( r, MAX(g, b ));
    *v = max;
    delta = max - min;
    if( max != 0 )
        *s = delta / max;
    else {
        *s = 0;
        *h = -1;
        return;
    }
    if( r == max )
        *h = ( g - b ) / delta;
    else if( g == max )
        *h = 2 + (b - r) / delta;
    else
        *h = 4 + (r - g) / delta;
    *h *= 60;
    if( *h < 0 )
        *h += 360;
}

-(float)getPulse{
   // NSString * nframe = [NSString stringWithFormat:@"Valid Frames: %d%%", MIN(100, (100 * self.validFrameCounter)/minFrameCount)];
    float ret = -1;
    float avePeriod=[self.pulseDetector getAverage];
    if(avePeriod==INVALID_PULSE_PERIOD) {
        // no value available
//        self.m_pLabel.text=[NSString stringWithFormat:@"%@,心率:--", nframe];
    } else {
        // got a value so show it
        ret=60.0/avePeriod;
//        self.m_pLabel.text=[NSString stringWithFormat:@"%@,心率%0.0f", nframe,pulse];
    }
    return ret;
}
-(float)getFrame{
    float fFrame = MIN(100, (100 * self.validFrameCounter)/minFrameCount);
    return fFrame;
}
-(int)getHRV{
    int nRet = [self.pulseDetector getHRV];
    return nRet;
}
//zwqend
@end
