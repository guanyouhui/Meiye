//
//  NSArray+ZUtils.m
//  PaixieMall
//
//  Created by zhwx on 15/1/7.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "NSArray+ZUtils.h"

@implementation NSArray (ZUtils)

/**
 * 快速排序，Array内数据元素为NSNumber
 */
+ (NSArray*)quickSortWithSource:(NSArray*)source Type:(NSComparisonResult)type
{
    NSArray *sortedArray = [source sortedArrayUsingComparator :^( id obj1, id obj2) {
        float val1 = [obj1  floatValue];
        float val2 = [obj2  floatValue];
        
        BOOL condition;
        
        if (type == NSOrderedAscending) {
            condition = (val1 > val2);
        }
        else if (type == NSOrderedDescending){
            condition = (val1 < val2);
        }
        else{
            condition = (val1 == val2);
        }
        
        if (condition) {
            return NSOrderedDescending;
        } else {
            return NSOrderedAscending;
        }
    }];
    return sortedArray;
}

/**
 * 二分查找，Array内数据元素为NSNumber，source 必须为有序 的数组
 */
+ (NSUInteger)binarySearchWithSource:(NSArray*)source key:(NSNumber *)key
{
    NSArray *sortedArray = source;
    NSRange searchRange = NSMakeRange(0, [sortedArray count]);
    NSUInteger findIndex = [sortedArray indexOfObject:key
                                        inSortedRange:searchRange
                                              options:NSBinarySearchingFirstEqual
                                      usingComparator:^(id obj1, id obj2)
                            {
                                NSString *o1 = [NSString stringWithFormat:@"%@",obj1];
                                NSString *o2 = [NSString stringWithFormat:@"%@",obj2];
                                NSLog(@"o1 = %@,o2=%@",o1,o2);
                                return [o1 compare:o2];
                            }];
    return findIndex;
}
@end


@implementation NSMutableArray (ZUtils)


- (void)addObjectNoNull:(id)object{
    
    [self addObject:object?object:@""];
    
}
@end
