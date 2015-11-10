//
//  HBCustomerTextField.h
//  HebeiTV
//
//  Created by Pro on 5/19/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXTextField : UITextField

@property (copy,nonatomic) NSString * textTitle;
@property (strong,nonatomic) UIImage * textImage;
@property (nonatomic, assign) UIEdgeInsets contentEdgeInsets; //default is UIEdgeInsetsMake(0, 10, 0, 10)

//是否需要按钮保护开关，默认：NO
@property (assign,nonatomic) BOOL needSecure;

/*
 * 左边的标题 或 图标
 * 方便外部修改
 */
@property (strong,nonatomic) UILabel * leftLabel;
@property (strong,nonatomic) UIButton * leftButton;

@end

