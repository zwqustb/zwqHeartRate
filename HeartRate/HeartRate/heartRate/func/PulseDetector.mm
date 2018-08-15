//
//  PulseDetector.m
//  ARDemo
//
//  Created by Chris Greening on 30/10/2010.
//  Copyright 2010 CMG Research. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>
#import "PulseDetector.h"
//#import <vector>
//#import <algorithm>

#define MAX_PERIOD 2.0
#define MIN_PERIOD 0.3
#define MAX_HRV_PERIOD 1.2
#define MIN_HRV_PERIOD 0.6
#define INVALID_ENTRY -100

@implementation PulseDetector

@synthesize periodStart;


- (id) init
{
	self = [super init];
	if (self != nil) {
        tempHeartRate = 60;
        // set everything to invalid
        [self reset];
        aryAllTimeDiffers = [[NSMutableArray alloc]initWithCapacity:10];
	}
	return self;
}

-(void) reset {
	for(int i=0; i<MAX_PERIODS_TO_STORE; i++) {
		periods[i]=INVALID_ENTRY;
	}
	for(int i=0; i<AVERAGE_SIZE; i++) {
		upVals[i]=INVALID_ENTRY;
		downVals[i]=INVALID_ENTRY;
	}	
  freq=0.5;
  periodIndex=0;
  downValIndex=0;
  upValIndex=0;
}

-(float) addNewValue:(float) newVal atTime:(double) time {	
  // we keep track of the number of values above and below zero
    NSLog(@"newVal:%f",newVal);
	if(newVal>0) {
		upVals[upValIndex]=newVal;
		upValIndex++;
		if(upValIndex>=AVERAGE_SIZE) {
			upValIndex=0;
		}
	}
	if(newVal<0) {
		downVals[downValIndex]=-newVal;
		downValIndex++;
		if(downValIndex>=AVERAGE_SIZE) {
			downValIndex=0;
		}		
	}
  // work out the average value above zero
	float count=0;
	float total=0;
	for(int i=0; i<AVERAGE_SIZE; i++) {
		if(upVals[i]!=INVALID_ENTRY) {
			count++;
			total+=upVals[i];
		}
	}
	float averageUp=total/count;
  // and the average value below zero
	count=0;
	total=0;
	for(int i=0; i<AVERAGE_SIZE; i++) {
		if(downVals[i]!=INVALID_ENTRY) {
			count++;
			total+=downVals[i];
		}
	}
	float averageDown=total/count;

  // is the new value a down value?
	if(newVal<-0.5*averageDown) {
		wasDown=true;
	}
	
  // is the new value an up value and were we previously in the down state?
	if(newVal>=0.5*averageUp && wasDown) {
		wasDown=false;
    // work out the difference between now and the last time this happenned
        float heratRateInterval = time-periodStart;
		if(heratRateInterval<MAX_PERIOD && heratRateInterval>MIN_PERIOD) {
			periods[periodIndex]=heratRateInterval;
			periodTimes[periodIndex]=time;
			periodIndex++;
			if(periodIndex>=MAX_PERIODS_TO_STORE) {
				periodIndex=0;
			}
            if (heratRateInterval>MIN_HRV_PERIOD &&
                heratRateInterval<MAX_HRV_PERIOD) {
                NSNumber* num = [NSNumber numberWithFloat:time-periodStart ];
                [aryAllTimeDiffers addObject:num];
            }
		}
       
    // track when the transition happened
		periodStart=time;
	} 
	// return up or down
	if(newVal<-0.5*averageDown) {
		return -1;
	} else if(newVal>0.5*averageUp) {
		return 1;
	}
	return 0;
}

-(float) getAverage {
	double time=CACurrentMediaTime();
	double total=0;
	double count=0;
	for(int i=0; i<MAX_PERIODS_TO_STORE; i++) {
    // only use upto 10 seconds worth of data
		if(periods[i]!=INVALID_ENTRY  && time-periodTimes[i]<10) {
			count++;
			total+=periods[i];
            double d = periods[i];
            if (d>0) {
                tempHeartRate = d;
            }
		}
	}
  // do we have enough values?
	if(count>2) {
		return total/count;
	}
	//return INVALID_PULSE_PERIOD;
    return tempHeartRate;
}
/**
 返回一组数的平均数
 
 HRV 的MEAN
 
 @param num 数组
 @param n 数组元素个数
 @return float类型
 */

-(float)avgWithArray:(NSArray *)num withCount:(int)n{
    int i = 0;
    float sum = 0.0f;//和
    for(i=0;i<n;i++){
        float value = [num[i] floatValue];
        sum += value;
    }
    return sum/n;
}

/**
 返回一组数的标准差
 
 HRV的SDNN
 
 @param num 一组数
 @param n 数组个数
 @return 标准差
 */
-(double)stdevWithArray:(NSArray *)num withCount:(int)n{
    int i = 0;
    float avg1 = [self avgWithArray:num withCount:n];
    //avg(num,n);
    float sum = 0.0f;
    for (i=0; i<n; i++) {
        float value = [num[i] floatValue];
        sum += (value-avg1)*(value-avg1);
    }
    
    return sqrt(sum/n);//开方
}
-(int) getHRV{
    float fHRV = [self stdevWithArray:aryAllTimeDiffers withCount:(int)aryAllTimeDiffers.count];
    int nHRV = int(fHRV*1000);
    return nHRV;
}
@end
