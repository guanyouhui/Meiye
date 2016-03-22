//
//  AreaService.m
//  YundxUser
//
//  Created by tingxie on 16/2/18.
//  Copyright © 2016年 王庭协. All rights reserved.
//

#import "AreaService.h"
#import "Area.h"
#import "DbService.h"

#define FILENAME @"city.db"

@implementation AreaService {
@private
    NSString *areaString;
    DbService *dbService;
}

- (id)init {
    
    self = [super init];
    
    if (self) {
        dbService = [[DbService alloc] initWithDb:FILENAME];
    }
    
    
    return self;
}

- (void)addToAreaArray:(NSMutableArray *)array item:(Area *)area {
    
    for (Area *tmpArea in array) {
        if ([tmpArea.entityId isEqualToString:area.entityId] == YES) {
            return;
        }
    }
    
    [array addObject:area];
}

- (NSArray *)queryProvince {
    NSString *sql = @"SELECT id, name from city WHERE type == 1";
    return [dbService query:sql resultSet:^id(FMResultSet *rs) {
        Area *province = [[Area alloc] init];
        province.entityId = [rs stringForColumn:@"id"];
        province.o_name = [rs stringForColumn:@"name"];
        
        return province;
    }];
}

- (NSArray *)queryCity:(NSString *)provinceId {
    
    if (provinceId == nil) {
        return nil;
    }
    
    NSString *sql = @"select id,name from city where parent_id = ? AND type == 2";
    return [dbService query:sql withArgumentsInArray:[NSArray arrayWithObject:provinceId]
                  resultSet:^(FMResultSet *rs) {
                      Area *city = [[Area alloc] init];
                      city.entityId = [rs stringForColumn:@"id"];
                      city.o_name = [rs stringForColumn:@"name"];
                      
                      return city;
                  }];
}

- (NSArray *)queryDistrict:(NSString *)cityId {
    
    if (cityId == nil) {
        return nil;
    }
    
    NSString *sql = @"select id,name from city where parent_id = ? AND type == 3";
    return [dbService query:sql withArgumentsInArray:[NSArray arrayWithObject:cityId]
                  resultSet:^(FMResultSet *rs) {
                      Area *district = [[Area alloc] init];
                      district.entityId = [rs stringForColumn:@"id"];
                      district.o_name = [rs stringForColumn:@"name"];
                      
                      return district;
                  }];
}


- (NSString *)queryCityIdWithCityName:(NSString *)cityName
{
    if (cityName == nil) {
        return nil;
    }
    
    //    select id,name from city where name like '%厦门%' and type = '2'
    
    NSString* format = @"select id,name from city where name like '%%%@%%' and type == 2";
    NSString* sql = [NSString stringWithFormat:format,cityName];
    
    NSArray* results = [dbService query:sql withArgumentsInArray:nil
                              resultSet:^(FMResultSet *rs) {
                                  return [rs stringForColumn:@"id"];
                              }];
    return results && results.count>0? [results firstObject]:nil;
}

- (NSString *)queryProvinceIdWithProvinceName:(NSString *)provinceName
{
    if (provinceName == nil) {
        return nil;
    }
    
    //    select id,name from city where name like '%福建省%' and type = '1'
    
    NSString* format = @"select id,name from city where name like '%%%@%%' and type == 1";
    NSString* sql = [NSString stringWithFormat:format,provinceName];
    
    NSArray* results = [dbService query:sql withArgumentsInArray:nil resultSet:^(FMResultSet *rs) {
        return [rs stringForColumn:@"id"];
    }];
    return results && results.count>0? [results firstObject]:nil;
}


- (NSArray *)queryAllCities{
    
    NSString *sql = @"select id,name from city where parent_id != 3467   AND parent_id != 3468 AND type == 2";
    return [dbService query:sql resultSet:^id(FMResultSet *rs) {
        Area *province = [[Area alloc] init];
        province.entityId = [rs stringForColumn:@"id"];
        province.o_name = [rs stringForColumn:@"name"];
        
        return province;
    }];
}

- (NSArray *)queryCityWithText:(NSString *)text
{
    NSString *format = @"select id,name from city where parent_id != 3467   AND parent_id != 3468 AND type == 2 AND name like '%%%@%%'";
    NSString* sql = [NSString stringWithFormat:format,text];
    return [dbService query:sql resultSet:^id(FMResultSet *rs) {
        Area *province = [[Area alloc] init];
        province.entityId = [rs stringForColumn:@"id"];
        province.o_name = [rs stringForColumn:@"name"];
        
        return province;
    }];
}

/**
 * 通过 【市、县】 的名称 获取 邮编
 */
- (NSString *)queryZipCodeWithCityName:(NSString*)cityName CountyName:(NSString *)countyName
{
    
    
    if (cityName.length<=0 && countyName.length<=0) {
        return nil;
    }
    
    if (cityName.length > 0) {
        
        NSString* format = @"select id,zipcode from city where name like '%%%@%%' and type == 2";
        NSString* sql = [NSString stringWithFormat:format,cityName];
        
        NSArray* results = [dbService query:sql withArgumentsInArray:nil
                                  resultSet:^(FMResultSet *rs) {
                                      return [rs stringForColumn:@"zipcode"];
                                  }];
        return results && results.count>0? [results firstObject]:nil;
        
    }else if (countyName.length > 0) {
        
        NSString* format = @"select id,zipcode from city where name like '%%%@%%' and type == 3";
        NSString* sql = [NSString stringWithFormat:format,countyName];
        
        NSArray* results = [dbService query:sql withArgumentsInArray:nil
                                  resultSet:^(FMResultSet *rs) {
                                      return [rs stringForColumn:@"zipcode"];
                                  }];
        return results && results.count>0? [results firstObject]:nil;
        
    }
    return nil;
}

@end
