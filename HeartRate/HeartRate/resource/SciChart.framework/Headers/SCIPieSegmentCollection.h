//******************************************************************************
// SCICHART® Copyright SciChart Ltd. 2011-2018. All rights reserved.
//
// Web: http://www.scichart.com
// Support: support@scichart.com
// Sales:   sales@scichart.com
//
// SCIPieSegmentCollection.h is part of SCICHART®, High Performance Scientific Charts
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

#import <Foundation/Foundation.h>
#import "SCIObservableCollection.h"

/** \addtogroup RenderableSeries
 *  @{
 */

@protocol SCIPieRenderableSeriesProtocol;
@class SCIPieSegment;

/**
 * @brief Container for pie segments
 */
@interface SCIPieSegmentCollection : SCIObservableCollection

- (instancetype)initWithParent:(id<SCIPieRenderableSeriesProtocol>)parent;

- (instancetype)initWithParent:(id<SCIPieRenderableSeriesProtocol>)parent segmentCollection:(NSArray<SCIPieSegment *> *)series;

@property(nonatomic, weak) id<SCIPieRenderableSeriesProtocol> parent;

/**
 * Appends segment to the collection
 * @param item Item to insert into collection
 * @see SCIPieSegment
 */
- (void)add:(SCIPieSegment *)item;

/**
 * Removes the segment instance from this collection.
 *
 * @param item SCIPieSegment instance to be deleted from the collection, if present in it.
 * @return Return YES If item is removed, otherwise NO
 */
- (BOOL)remove:(SCIPieSegment *)item;

/**
 * Gets segment by index from the collection
 * @param index Index used when retrieving for segment
 * @see SCIPieSegment
 */
- (SCIPieSegment *)itemAt:(unsigned int)index;

/**
 * Inserts segment into the collection at specified position
 * @param item Item to insert into collection
 * @param index Position where segment will be placed
 * @see SCIPieSegment
 */
- (void)insert:(SCIPieSegment *)item At:(int)index;

/**
 * Return first object from this instance of SCIPieSegmentCollection
 */
- (SCIPieSegment *)firstObject;

/**
 * Checks whether segment collection contains the segment or not
 * @param item Item to check in collection
 * @see SCIPieSegment
 */
- (BOOL)contains:(SCIPieSegment *)item;

/**
 * Returns the index of the first occurrence of the specified segment in this collection.
 *
 * @return Returns the index of the first occurrence, otherwise returns -1.
 */
- (int)indexOf:(SCIPieSegment *)item;

/**
 * Replaces the segment at the specified position in this collection with the specified element.
 *
 * @param segment segment to be stored at the specified position
 * @param index index of the element to replace
 */
- (void)setSegment:(SCIPieSegment *)segment atIndex:(unsigned int)index;

@end

@interface SCIPieSegmentCollection (Indexing)

- (SCIPieSegment *)objectAtIndexedSubscript:(unsigned int)idx;

- (void)setObject:(SCIPieSegment *)obj atIndexedSubscript:(unsigned int)idx;

@end
/** @}*/
