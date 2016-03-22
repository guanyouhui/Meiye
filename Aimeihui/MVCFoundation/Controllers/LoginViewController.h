//
//  LoginViewController.h
//  Yundx
//
//  Created by Pro on 15/7/31.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "TXViewController.h"

@interface LoginViewController : TXViewController

@property (nonatomic , assign ) Login_After_Todo todo;
- (void)setPhoneText;

- (void)requesLogin:(NSString *)phone passward:(NSString *)passward;
@end
