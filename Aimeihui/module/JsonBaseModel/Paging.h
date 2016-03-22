//
//  Paging.h
//  EnwaysFoundation
//
//  Created by Jackson Fu on 5/12/11.
//  Copyright (c) 2012 厦门英睿信息科技有限公司. All rights reserved.
//

#define FIRST_START_INDEX 0
#define FIRST_PAGE 1
#define DEFAULT_PAGE_SIZE 10

#import <Foundation/Foundation.h>

@interface Paging : NSObject

@property (nonatomic,assign) NSUInteger page;//页码
@property (nonatomic,assign) NSUInteger pages;//总页数
@property (nonatomic,assign) NSUInteger records;//总条数
@property (nonatomic,assign) NSUInteger pageSize;//每页条数

@end
