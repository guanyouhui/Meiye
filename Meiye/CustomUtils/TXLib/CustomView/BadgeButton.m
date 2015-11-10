//
//  BadgeButton.m
//  TinyShop
//
//  Created by tingxie on 14-9-1.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "BadgeButton.h"

@implementation BadgeButton
{
    UIButton * badgeControl;
}
- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initView];
    }
    return self;
}
-(void)initView{
    badgeControl=[UIButton buttonWithType:UIButtonTypeCustom];
    badgeControl.frame=CGRectMake(self.frame.size.width-30, -12, 40, 24);
    badgeControl.titleLabel.font=[UIFont systemFontOfSize:15];
    [badgeControl setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    badgeControl.hidden=YES;
    [self addSubview:badgeControl];
    
}
-(void)setO_badgeNumber:(int)o_badgeNumber{
    _o_badgeNumber=o_badgeNumber;
    if (o_badgeNumber>0 ) {
        badgeControl.hidden=NO;
        
        if ([self backgroundImageForState:UIControlStateNormal]) {
            badgeControl.y = -12;
        }else if([self imageForState:UIControlStateNormal]){
            UIImage * image = [self imageForState:UIControlStateNormal];
            badgeControl.y = (self.height - image.size.height)/2-12;
        }
        
        NSString * badgeNumber;
        UIImage * badgeImage;
        if (o_badgeNumber>99 ) {
            badgeNumber=@"99+";
        }else{
            badgeNumber=[NSString stringWithFormat:@"%d",o_badgeNumber];
        }
        if (badgeNumber.length>=2) {
            badgeImage=[UIImage imageNamed:@"bageNumber"];
        }else{
            badgeImage=[UIImage imageNamed:@"smallBadge"];
        }
        [badgeControl setBackgroundImage:badgeImage forState:UIControlStateNormal];
        badgeControl.width = badgeNumber.length * 8 +16;
        badgeControl.x=self.width-badgeControl.width+5;
        [badgeControl setTitle:badgeNumber forState:UIControlStateNormal];
        
    }
    else{
        badgeControl.hidden=YES;
    }
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
