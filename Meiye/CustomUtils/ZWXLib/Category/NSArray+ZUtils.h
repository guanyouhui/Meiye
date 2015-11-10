//
//  NSArray+ZUtils.h
//  PaixieMall
//
//  Created by zhwx on 15/1/7.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (ZUtils)

/**
 * 快速排序，Array内数据元素为NSNumber
 */
+ (NSArray*)quickSortWithSource:(NSArray*)source Type:(NSComparisonResult)type;

/**
 * 二分查找，Array内数据元素为NSNumber，source 必须为有序 的数组
 */
+ (NSUInteger)binarySearchWithSource:(NSArray*)source key:(NSNumber *)key;

- (void)addObjectNoNull:(id)object;

@end

@interface NSMutableArray (ZUtils)

- (void)addObjectNoNull:(id)object;

@end