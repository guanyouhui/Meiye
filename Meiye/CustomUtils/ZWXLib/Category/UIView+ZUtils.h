//
//  UIView+ZUtils.h
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (ZUtils)

@property (nonatomic, assign) CGFloat height;
@property (nonatomic, assign) CGFloat width;
@property (nonatomic, assign) CGFloat x;
@property (nonatomic, assign) CGFloat y;

@property (nonatomic, assign) UIColor *borderColor;
@property (nonatomic, assign) CGFloat borderWidth;
@property (nonatomic, assign) CGFloat cornerRadius;

@property (nonatomic, assign) CGSize size;

@property (nonatomic, assign) CGFloat left;
@property (nonatomic, assign) CGFloat right;
@property (nonatomic, assign) CGFloat top;
@property (nonatomic, assign) CGFloat bottom;

@property (nonatomic, assign) CGFloat centerX;
@property (nonatomic, assign) CGFloat centerY;

@property (nonatomic, assign,readonly) CGPoint selfCenter;
@property (nonatomic, assign,readonly) CGFloat selfCenterX;
@property (nonatomic, assign,readonly) CGFloat selfCenterY;

- (void)removeAllSubViews;

/**
 *  自动从xib创建视图
 */
+(instancetype)viewFromXIB;

@end
