//
//  YundxViewController.h
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "KaKaViewController.h"
#import "MBProgressHUD.h"
#import "UMSocial.h"

@interface YundxViewController : KaKaViewController


@property (strong, nonatomic) PaiXieBaseService * baseService;

/**
 * 请求超时，下滑重新 获取数据按钮
 */
- (void)showNetworkErrorView;
- (void)hideNetworkErrorView;
- (void)refreshData;


/**
 * 获取MBProgressHUD用于显示加载提示
 */
- (MBProgressHUD *)createMBProgressHUD;


/**
 * 交给子类 处理【重新登录】的结果
 */
- (void)subViewControllerHandleLoginAagin:(NSInteger)what isSuccess:(BOOL)isSuccess;

//显示网络不可用提示
-(BOOL) showNetworkMessage;


- (BOOL)checkLogin;


- (void)shareWithUrl:(NSString*)url content:(NSString*)content image:(UIImage*)image delegate:(id<UMSocialUIDelegate>)delegate;



@end
