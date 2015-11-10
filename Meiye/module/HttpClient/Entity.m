//
//  Entity.m
//  EnwaysFoundation
//
//  Created by Jackson Fu on 5/12/11.
//  Copyright (c) 2012 厦门英睿信息科技有限公司. All rights reserved.
//

#import "Entity.h"

@implementation Entity

- (id)initWithId:(NSString *)entityId {
    self = [super init];
    
    if (self) {
        self.entityId = entityId;
    }
    
    return self;
}

- (BOOL)isEqual:(id)object {
    
    if (object == nil) {
        return NO;
    }
    
    if (object == self) {
        return YES;
    }
    
    if ([object isKindOfClass:[Entity class]]) {
        Entity *target = (Entity *)object;
        return [self.entityId isEqualToString:target.entityId];
    }
    
    return NO;
}


@end

