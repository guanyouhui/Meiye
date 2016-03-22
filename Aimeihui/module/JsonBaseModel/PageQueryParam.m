//
//  PageQueryParam.m
//  WuLiuDS
//
//  Created by zhwx on 14-10-13.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import "PageQueryParam.h"

@implementation PageQueryParam

-(id) init
{
    if (self = [super init]) {
        self.o_start = FIRST_START_INDEX;
        _o_count = DEFAULT_PAGE_SIZE;
    }
    return self;
}


-(NSMutableDictionary*) serialData
{
    NSMutableDictionary* result = [NSMutableDictionary dictionaryWithDictionary:@{JSON_KEY_PAGE: @(self.o_start),JSON_KEY_PAGE_SIZE:@(self.o_count)}];
    return result;
}


@end
