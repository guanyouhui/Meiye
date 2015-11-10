//
//  QueryParam.m
//  PaixieMall
//
//  Created by zhwx on 14/12/8.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "QueryParam.h"

@implementation QueryParam

-(id) init
{
    if (self = [super init]) {
        self.paging = [[Paging alloc] init];
    }
    return self;
}


@end
