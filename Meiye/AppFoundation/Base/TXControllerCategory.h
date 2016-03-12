//
//  YundxViewController+TXController.h
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "KaKaViewController.h"

@interface KaKaViewController (TXController)
/**
 * 设置TabBarItem图片
 */
- (void)setTabBarItemTitle:(NSString *)title andImageName:(NSString *)imageName andSelectedImageName:(NSString *)selectedImageName;

/**
 * 添加NavigationBar右侧按钮
 */
- (UIButton *)addRightNavBarItemsWithText:(NSString *)text andImage:(UIImage *)image;

/**
 * 添加NavigationBar左侧按钮
 */
- (UIButton *)addLeftNavBarItemsWithText:(NSString *)text andImage:(UIImage *)image;

/**
 * 获取友盟日志页面名称
 */
- (NSString *)getUMengLogPageName;

/**
 * 设置导航栏文字
 */
- (void)customTitleLabel;

/**
 * 创建返回按钮
 */
- (void)customBackButton;

/**
 * 返回
 */
- (void)back;

/**
 * 返回到指定界面
 */
- (UIViewController *)popToViewControllerClass:(Class)controllerClass;

/**
 * 设置TabBarItem图片
 */
- (void)setTabBarItemImageName:(NSString *)imageName withSelectedImageName:(NSString *)selectedImageName;

@end
