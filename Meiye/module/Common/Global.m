
//
//  Global.m
//  WuLiuDS
//
//  Created by zhwx on 14-9-9.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import "Global.h"

@implementation Global

+(instancetype) sharedInstance
{
    static dispatch_once_t onceToken;
    static Global* _global = nil;
    dispatch_once(&onceToken, ^{
        _global = [[Global alloc] init];
        [_global initComponents];
    });
    return _global;
}
- (void)initComponents {
    
    _applicationHelper = [[ApplicationHelper alloc] init];
        
}

+ (Login_Type)loginType{
    Login_Type loginType = [[NSUserDefaults standardUserDefaults] integerForKey:UD_LOGIN_TYPE];
    return loginType;
}


@end
