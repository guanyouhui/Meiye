//
//  TXSecurityCodeButton.m
//  MyButtonProduct
//
//  Created by Pro on 8/26/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import "TXVerifyCodeButton.h"
#import "MSWeakTimer.h"


#define xDefaultsText @"获取验证码"
#define xCanAgainText @"重新获取验证码"
#define xCountdownText @"%d秒后重新获取"
#define xTimerCount 120
@implementation TXVerifyCodeButton
{
    MSWeakTimer * _mytTime;
    int _secondsCountDown;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.verifyStatus=TXVerifyStatusDefults;
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        self.verifyStatus=TXVerifyStatusDefults;
    }
    return self;
}
-(void)setVerifyStatus:(TXVerifyStatus )verifyStatus
{
//    CGFloat right = CGRectGetMaxX(self.frame);
    
    if (verifyStatus==TXVerifyStatusDefults) {
        [self initVerifyStatus:xDefaultsText];
    }
    else if (verifyStatus==TXVerifyStatusCanAgain) {
         [self initVerifyStatus:xCanAgainText];
    }
    else if (verifyStatus==TXVerifyStatusStartCountdown) {
        [self addTimerCount];
    }
    //固定宽度
//    CGSize titleSize = [self.titleLabel.text sizeWithFont:self.titleLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame))];
//    titleSize.width = titleSize.width + 10*2;
//    CGRect nFrame = CGRectMake(right - titleSize.width, CGRectGetMinY(self.frame), titleSize.width , CGRectGetHeight(self.frame));
//    
//    [self setFrame:nFrame];
}
// 重新获取验证码
-(void)addTimerCount{
    self.userInteractionEnabled=NO;
    [self setTitle:[NSString stringWithFormat:xCountdownText,xTimerCount] forState:UIControlStateNormal];
    _secondsCountDown = xTimerCount;
    if (_mytTime) {
        [_mytTime invalidate];
        _mytTime=nil;
    }
    _mytTime = [MSWeakTimer scheduledTimerWithTimeInterval:1.0 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES dispatchQueue:kMainQueue];
//    _mytTime = [MSWeakTimer scheduledTimerWithTimeInterval:1 target:self selector:@selector(timeFireMethod) userInfo:nil repeats:YES];
}
//定时器的方法
-(void)timeFireMethod{
    _secondsCountDown--;
    if(_secondsCountDown<=0){
        [self initVerifyStatus:xCanAgainText];
    }
    else
    {
        [self setTitle:[NSString stringWithFormat:xCountdownText,_secondsCountDown] forState:UIControlStateNormal];
    }
}
-(void)initVerifyStatus:(NSString *)promptText{
    [self setTitle:promptText forState:UIControlStateNormal];
    
    [_mytTime invalidate];
    self.userInteractionEnabled=YES;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
