//
//  AddressSelectView.h
//  TinySeller
//
//  Created by tingxie on 15/5/6.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

/**
 省市区控件 选择类型
 */
typedef enum : NSUInteger {
    TXAddressType_Default = 0,//省市区
    TXAddressType_Province,
    TXAddressType_ProvinceCity,
    TXAddressType_ProvinceCityArea
} TXAddressType;


@class TXAddressView;

@protocol TXAddressViewDelegate <NSObject>

//返回的地址 address 用 、分隔。
- (void)addressView:(TXAddressView*)addressView didSeletedAddress:(NSString *)address;

@end

@interface TXAddressView : UIView

@property (nonatomic,assign) id<TXAddressViewDelegate>o_delegate;

/*
 * 选项栏根据当前地址，显示指定位置。
 */
- (void)showAddress:(NSString *)currentAddress type:(TXAddressType)type;

- (void)hidden;

@end
