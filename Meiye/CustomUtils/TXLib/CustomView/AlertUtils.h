//
//  AlertUtils.h
//  HeiBoss
//
//  Created by tingxie on 14-10-13.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AlertUtils : NSObject

+ (void)alertWithTitle:(NSString *)title;

+ (void)alert:(NSString *)message;

+ (void)alert:(NSString *)message buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;

+ (void)alert:(NSString *)message withTag:(NSInteger)tag buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;

+ (void)confirm:(NSString *)message buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;

+ (void)confirm:(NSString *)message withTag:(NSInteger)tag buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;

+ (void)confirm:(NSString *)message withButtonTitles:(NSArray *)buttonTitles buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;

+ (void)confirm:(NSString *)message withButtonTitles:(NSArray *)buttonTitles withTag:(NSInteger)tag buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;
+ (void)confirmTitle:(NSString *)title buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate;
@end
