//
//  PageQueryParam.h
//  WuLiuDS
//
//  Created by zhwx on 14-10-13.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PageQueryParam : NSObject

@property (nonatomic,assign) NSUInteger o_start;//其始Index
@property (nonatomic,assign) NSUInteger o_count;//每页个数

-(NSMutableDictionary*) serialData;

@end
