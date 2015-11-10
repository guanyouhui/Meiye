//
//  UIButton+ZUtils.h
//  PaixieMall
//
//  Created by zhwx on 14-7-9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIButton (ZUtils)


/**
 * 设置圆角
 */
-(void) setCornerRadius:(CGFloat)radius;

/**
 * 设置边框 宽度 和 颜色
 */
-(void) setBorderWidth:(CGFloat)width color:(UIColor*)color;

/**
 * 用颜色来设置 背景色状态。
 */
-(void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state;

@end
