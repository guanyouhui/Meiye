//
//  City.m
//  Yundx
//
//  Created by Pro on 15/8/16.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "City.h"

@implementation City

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.CityId forKey:@"CityId"];
    [encoder encodeObject:self.Name forKey:@"Name"];
    [encoder encodeObject:self.ShortName forKey:@"ShortName"];
    [encoder encodeBool:self.IsHot forKey:@"IsHot"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.CityId = [decoder decodeObjectForKey:@"CityId"];
        self.Name = [decoder decodeObjectForKey:@"Name"];
        self.ShortName = [decoder decodeObjectForKey:@"ShortName"];
        self.IsHot = [decoder decodeBoolForKey:@"IsHot"];
    }
    return self;
}

@end
