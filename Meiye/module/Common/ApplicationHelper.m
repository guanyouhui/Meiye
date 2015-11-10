//
//  ApplicationHelper.m
//  PaixieMall
//
//  Created by allen on 12-12-11.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "ApplicationHelper.h"
#import "OpenUDID.h"
#import "AppDelegate.h"


@implementation ApplicationHelper 

-(id) init
{
    if (self = [super init]) {
        _isOnlineMode = YES;
//        _o_apnsToAppStatus = APNSToAppStatus_Active;
        
        NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
        NSData * cityData = [userDefaults objectForKey:UD_SELECT_CITY];
        City * city = [NSKeyedUnarchiver unarchiveObjectWithData:cityData];
        _selectCity = city;
        
    }
    return self;
}

- (void)setCurrendPlacemark:(CLPlacemark *)currendPlacemark{
    _currendPlacemark = currendPlacemark;
    if (currendPlacemark) {
        _locationCity = currendPlacemark.locality;
        _locationCity = [_locationCity stringByReplacingOccurrencesOfString:@"市辖区" withString:@""];
        _locationAddress = currendPlacemark.name;
//        NSString * allAddress = currendPlacemark.name;
//        NSRange cityRange = [allAddress rangeOfString:_locationCity];
//        _locationAddress = [allAddress substringFromIndex:cityRange.location+cityRange.length];
    }

}

/*
 City = "厦门市";
 Country = "中国";
 CountryCode = CN;
 FormattedAddressLines =     (
 "中国福建省厦门市思明区莲前街道会展路"
 );
 Name = "中国福建省厦门市思明区莲前街道会展路";
 State = "福建省";
 Street = "会展路";
 SubLocality = "思明区";
 Thoroughfare = "会展路";*/
@end
