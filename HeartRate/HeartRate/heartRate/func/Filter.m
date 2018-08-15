//
//  Filter.m
//  HeartRate
//
//  Created by Chris Greening on 31/10/2010.
//  Copyright 2010 CMG Research. All rights reserved.
//

#import "Filter.h"

#define GAIN    1.894427025e+01
#define MAFORDER 15
float PPG_Filter(float Datapoint,int Initialization)
{
    int i;
    const float b[3] = { 0.325881, 0.000000, -0.325881 }, a[2] = { -1.319761, 0.348236 }; //butterworth filter coefficients
    static float MAFBuffer[MAFORDER] = {0}; //moving average filter
    static float bx[3] = { 0 }, ax[2] = { 0 }; //butterworth buffers
    float Sum,MAFValue,FilteredData;
    
    //moving average filter (MAF)
    if (Initialization) //buffer initialization, set to true when first use
    {
        for (i = 0; i < MAFORDER; i++)
        {
            MAFBuffer[i] = Datapoint;
        }
        Sum = Datapoint * MAFORDER;
    }
    else
    {
        Sum = 0;
        for (i = 0; i < MAFORDER - 1; i++)
        {
            MAFBuffer[i] = MAFBuffer[i + 1];
            Sum += MAFBuffer[i + 1];
        }
        MAFBuffer[MAFORDER-1] = Datapoint;
        Sum += Datapoint;
    }
    MAFValue = Sum / MAFORDER; // output result of MAF filter
    
    //butterworth filter
    bx[2] = bx[1]; bx[1] = bx[0];
    bx[0] = MAFValue;
    FilteredData = bx[0] * b[0] + bx[1] * b[1] + bx[2] * b[2] - (ax[0] * a[0] + ax[1] * a[1]); // filtered datapoint at last
    ax[1] = ax[0];
    ax[0] = FilteredData;
    
    return FilteredData;
    
    
}
// see http://www-users.cs.york.ac.uk/~fisher/mkfilter/
@implementation Filter

-(float) processValue:(float) value {
	xv[0] = xv[1]; xv[1] = xv[2]; xv[2] = xv[3]; xv[3] = xv[4]; xv[4] = xv[5]; xv[5] = xv[6]; xv[6] = xv[7]; xv[7] = xv[8]; xv[8] = xv[9]; xv[9] = xv[10]; 
	xv[10] = value / GAIN;
	yv[0] = yv[1]; yv[1] = yv[2]; yv[2] = yv[3]; yv[3] = yv[4]; yv[4] = yv[5]; yv[5] = yv[6]; yv[6] = yv[7]; yv[7] = yv[8]; yv[8] = yv[9]; yv[9] = yv[10]; 
	yv[10] =   (xv[10] - xv[0]) + 5 * (xv[2] - xv[8]) + 10 * (xv[6] - xv[4])
	+ ( -0.0000000000 * yv[0]) + (  0.0357796363 * yv[1])
	+ ( -0.1476158522 * yv[2]) + (  0.3992561394 * yv[3])
	+ ( -1.1743136181 * yv[4]) + (  2.4692165842 * yv[5])
	+ ( -3.3820859632 * yv[6]) + (  3.9628972812 * yv[7])
	+ ( -4.3832594900 * yv[8]) + (  3.2101976096 * yv[9]);
	return yv[10];
}

@end
