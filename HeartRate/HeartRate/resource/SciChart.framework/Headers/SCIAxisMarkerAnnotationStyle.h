//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCIAxisMarkerAnnotationStyle.h is part of SCICHART®, High Performance Scientific Charts
// For full terms and conditions of the license, see http://www.scichart.com/scichart-eula/
//
// This source code is protected by international copyright law. Unauthorized
// reproduction, reverse-engineering, or distribution of all or any portion of
// this source code is strictly prohibited.
//
// This source code contains confidential and proprietary trade secrets of
// SciChart Ltd., and should at no time be copied, transferred, sold,
// distributed or made available without express written permission.
//******************************************************************************

/** \addtogroup Themes
 *  @{
 */

#import <Foundation/Foundation.h>
#import "SCICallbackBlock.h"
#import <QuartzCore/QuartzCore.h>
#import "SCIStyleProtocol.h"
#import "SCIAnnotationStyleEnums.h"

@class UITextField;
@class SCITextFormattingStyle;
@class UIColor;
@class SCIPenStyle;
@protocol SCIPointMarkerProtocol;

typedef void (^SCIAxisMarkerAnnotationViewSetupBlock) (UITextField * view);

/**
 * @abstract SCIAxisMarkerAnnotationStyle class
 * @discussion Contains properties for axis marker annotation theming and customization
 * @see SCIAxisMarkerAnnotation
 */
@interface SCIAxisMarkerAnnotationStyle : NSObject <SCIStyleProtocol, NSCopying>

/**
 * @abstract Defines text formatting style.
 * @discussion Contains properties for customization of labels font, color etc.
 * @see SCITextFormattingStyle
 */
@property (nonatomic, strong) SCITextFormattingStyle * textStyle;

/**
 * @abstract Defines text color
 */
@property (nonatomic, strong) UIColor * textColor;

/**
 * @abstract viewSetup block used for additional customization of text field
 * @discussion Type: void (^SCITextAnnotationViewSetupBlock) (UITextField * view)
 * @see SCIAxisMarkerAnnotationViewSetupBlock
 */
@property (nonatomic, copy) SCIAxisMarkerAnnotationViewSetupBlock viewSetup;

/**
 * @abstract Pen that defines marker line width and color
 * @see SCIPenStyle
 */
@property (nonatomic, strong) SCIPenStyle *markerLinePen;

/**
 * @abstract Defines margin between text field and fill area edge
 */
@property (nonatomic) float margin;

/**
 * @abstract Defines annotation's background color
 */
@property (nonatomic, strong) UIColor * backgroundColor;

/**
 * @abstract Defines annotation's border color
 */
@property (nonatomic, strong) UIColor * borderColor;

/**
 * @abstract Defines annotation's border width
 */
@property (nonatomic) float borderWidth;

/**
 * @abstract Defines annotation 'arrow' size in pixels
 * @discussion if set to 0 annotation will be rectangular
 */
@property (nonatomic) float arrowSize;

/**
 * @abstract Defines annotation's background opacity
 */
@property (nonatomic) float opacity;

/**
 * @abstract Point marker that will be displayed when interaction with annotation started
 * @see SCIPointMarkerProtocol
 */
@property (nonatomic, strong) id<SCIPointMarkerProtocol> interactionMarker;

/**
 * @abstract Defines size of annotations "hit body"
 * @discussion It is distance at which user should tap to interact with annotation
 * @discussion The greater value the easier to select annotation by tapping on it or drag it
 */
@property (nonatomic) double interactionRadius;

/**
 * @abstract Defines layer (X axis or Y axis) on which annotation is displayed
 * @see SCIAnnotationSurfaceEnum
 */
@property (nonatomic) SCIAnnotationSurfaceEnum annotationSurface;

@end


/** @}*/
