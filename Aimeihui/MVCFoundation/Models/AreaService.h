//
//  AreaService.h
//  YundxUser
//
//  Created by tingxie on 16/2/18.
//  Copyright © 2016年 王庭协. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AreaService : NSObject

- (NSArray *)queryProvince;

- (NSArray *)queryCity:(NSString *)provinceId;

- (NSArray *)queryDistrict:(NSString *)cityId;

- (NSArray *)queryCityWithText:(NSString *)text;

- (NSString *)queryCityIdWithCityName:(NSString *)cityName;

- (NSString *)queryProvinceIdWithProvinceName:(NSString *)provinceName;


/**
 * 除了 香港和澳门 以为的其他城市
 */
- (NSArray *)queryAllCities;

/**
 * 通过 【市、县】 的名称 获取 邮编
 */
- (NSString *)queryZipCodeWithCityName:(NSString*)cityName CountyName:(NSString *)countyName;
@end
