//
//  TXSecurityCodeButton.h
//  MyButtonProduct
//
//  Created by Pro on 8/26/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, TXVerifyStatus) {
    TXVerifyStatusDefults,//默认
    TXVerifyStatusCanAgain,//可重新验证
    TXVerifyStatusStartCountdown//开始倒计时
};
@interface TXVerifyCodeButton : UIButton
@property (nonatomic, assign)TXVerifyStatus verifyStatus;
//@property (nonatomic, strong) UILabel * promptLabel;
@end
