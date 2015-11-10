//
//  Paging.m
//  EnwaysFoundation
//
//  Created by Jackson Fu on 5/12/11.
//  Copyright (c) 2012 厦门英睿信息科技有限公司. All rights reserved.
//

#import "Paging.h"

@implementation Paging

- (id)init {
    self = [super init];
    
    self.page = FIRST_PAGE;
    self.pageSize = DEFAULT_PAGE_SIZE;
    self.records = 0;
    self.pages = 0;
    
    return self;
}

@end

