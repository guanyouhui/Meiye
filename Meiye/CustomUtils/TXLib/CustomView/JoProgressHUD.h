//
//  JoProgressHUD.h
//  TinyShop
//
//  Created by tingxie on 14/12/15.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JoProgressHUD : NSObject
+ (void)makeToast:(NSString *)message;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position title:(NSString *)title image:(UIImage *)image;
+ (void)makeToast:(NSString *)message duration:(CGFloat)interval position:(id)position image:(UIImage *)image;

// displays toast with an activity spinner
+ (void)makeToastActivity;
+ (void)makeToastActivity:(id)position;
+ (void)hideToastActivity;

// the showToast methods display any view as toast
+ (void)showToast:(UIView *)toast;
+ (void)showToast:(UIView *)toast duration:(CGFloat)interval position:(id)point;

@end
