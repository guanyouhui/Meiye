//
//  UIButton+ZUtils.m
//  PaixieMall
//
//  Created by zhwx on 14-7-9.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import "UIButton+ZUtils.h"
#import "ZUtilsImage.h"

@implementation UIButton (ZUtils)


/**
 * 设置圆角
 */
-(void) setCornerRadius:(CGFloat)radius
{
    self.layer.cornerRadius = radius;
    self.clipsToBounds = YES;

}


/**
 * 设置边框 宽度 和 颜色
 */
-(void) setBorderWidth:(CGFloat)width color:(UIColor*)color
{
    self.layer.borderWidth = width;
    self.layer.borderColor = color.CGColor;
}


/**
 * 用颜色来设置 背景色状态。
 */
-(void) setBackgroundColor:(UIColor *)backgroundColor forState:(UIControlState)state
{
    UIImage* sourceImage = [ZUtilsImage getImageWithColor:backgroundColor];
    sourceImage = [sourceImage resizableImageWithCapInsets:UIEdgeInsetsMake(0, 0, 0, 0)];

    [self setBackgroundImage:sourceImage forState:state];
}

@end
