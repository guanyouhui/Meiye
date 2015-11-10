//
//  ApplicationHelper.h
//  PaixieMall
//
//  Created by allen on 12-12-11.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Member.h"
#import "City.h"
#import <CoreLocation/CoreLocation.h>
/**
 * 推送消息进入到APP 时，APP所处的状态
 */
//typedef enum : NSUInteger {
//    APNSToAppStatus_Active,//APP处于激活状态（正在使用）
//    APNSToAppStatus_NotActive,//APP处于结束进程、Home键、后台 （非正在使用状态）。
//} APNSToAppStatus;



/**
 * app 全局信息
 */
@interface ApplicationHelper : NSObject

@property (strong, nonatomic) Member *loginedMember;
@property (strong, nonatomic) City * selectCity;
@property (strong, nonatomic) CLPlacemark * currendPlacemark;
@property (assign,nonatomic) CLLocationCoordinate2D currendCoordinate;
@property (copy, nonatomic) NSString * locationCity;
@property (copy, nonatomic) NSString * locationAddress;

//服务器的标准时间
@property (atomic,copy) NSDate* o_currentServiceTime;
//本地时间和服务器时间的 偏移值。(以后计算都得用此值 做偏移)
@property (atomic,assign) NSTimeInterval o_dateOffsetValue;


//网络是否在线
@property (nonatomic) BOOL isOnlineMode;
@property (strong, nonatomic, readonly) NSString *uuid;
//@property (strong, nonatomic) Member *loginedMember;


//-----------------------
@property (assign, nonatomic) BOOL o_isInputPassword;//记录是否输入过 查看账户的 密码


//--------记录登录、注册 填写的账号密码（以便再次保存）------------
@property (nonatomic,copy)NSString* o_newUserName;
@property (nonatomic,copy)NSString* o_newPswd;

//@property (nonatomic,assign)APNSToAppStatus o_apnsToAppStatus;


@end
