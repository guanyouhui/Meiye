//
//  City.h
//  Yundx
//
//  Created by Pro on 15/8/16.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "Entity.h"

@interface City : Entity

@property (copy, nonatomic) NSString *CityId;
@property (copy, nonatomic) NSString *Name;
@property (copy, nonatomic) NSString *ShortName;
@property (assign, nonatomic) BOOL IsHot;

@end
