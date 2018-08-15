//
//  Filter.h
//  HeartRate
//
//  Created by Chris Greening on 31/10/2010.
//  Copyright 2010 CMG Research. All rights reserved.
//

#import <Foundation/Foundation.h>

#define NZEROS 10
#define NPOLES 10
//梁思阳给的过滤器,用于30fps
//第一个传h,第二个,第一次传1,以后都是0,main里有例子
//前5s值不能用
float PPG_Filter(float Datapoint, int Initialization);

//github上SampleHeartRateApp里的过滤器,用于10fps
@interface Filter : NSObject {
	float xv[NZEROS+1], yv[NPOLES+1];
}

-(float) processValue:(float) value;

@end
