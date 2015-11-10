//
//  RegionbService.m
//  sport361
//
//  Created by Jackson Fu on 5/13/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RegionService.h"

@implementation CityJsonResponseHandler

- (id)parseEntityFromJson:(NSDictionary *)jsonObject{
    City * result = [[City alloc] init];
    
    result.CityId = [self parseStringWithJsonDic:jsonObject key:@"Id"];
    result.Name = [self parseStringWithJsonDic:jsonObject key:@"Name"];
    result.ShortName = [self parseStringWithJsonDic:jsonObject key:@"ShortName"];
    result.IsHot = [self parseNumberWithJsonDic:jsonObject key:@"IsHot"];
    
    return result;
}
@end

@implementation RegionService


- (NSArray *)queryCitiesWithKeywords:(NSString *)keywords{
    
    NSMutableDictionary * paramDict = [NSMutableDictionary dictionary];
    CityJsonResponseHandler * handler = [[CityJsonResponseHandler alloc] init];
    [paramDict setObjectNotNull:keywords forKey:@"KeyWords"];
    NSArray * result = [self query:URI_FindCity requestParam:paramDict reponseHandler:handler];
    return result;
}

@end
