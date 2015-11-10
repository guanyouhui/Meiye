//
//  AlertUtils.m
//  HeiBoss
//
//  Created by tingxie on 14-10-13.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "AlertUtils.h"

@implementation AlertUtils


+ (void)alertWithTitle:(NSString *)title
{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:title message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}


+ (void)alert:(NSString *)message{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)alert:(NSString *)message buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alertView show];
}

+ (void)alert:(NSString *)message withTag:(NSInteger)tag buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    alertView.tag=tag;
    [alertView show];
}

+ (void)confirm:(NSString *)message buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

+ (void)confirmTitle:(NSString *)title buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:title delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    [alertView show];
}

+ (void)confirm:(NSString *)message withTag:(NSInteger)tag buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:@"确定" otherButtonTitles:@"取消", nil];
    alertView.tag=tag;
    [alertView show];
}

+ (void)confirm:(NSString *)message withButtonTitles:(NSArray *)buttonTitles buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil, nil];
    for (NSString * str in buttonTitles) {
        [alertView addButtonWithTitle:str];
    }
    [alertView show];
}

+ (void)confirm:(NSString *)message withButtonTitles:(NSArray *)buttonTitles withTag:(NSInteger)tag buttonDelegate:(NSObject<UIAlertViewDelegate> *)delegate{
    UIAlertView * alertView=[[UIAlertView alloc]initWithTitle:@"" message:message delegate:delegate cancelButtonTitle:nil otherButtonTitles:nil, nil];
    alertView.tag=tag;
    for (NSString * str in buttonTitles) {
        [alertView addButtonWithTitle:str];
    }
    [alertView show];
}

@end
