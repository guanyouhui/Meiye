//
//  RoundButton.m
//  TinyShop
//
//  Created by tingxie on 15/1/14.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "RoundButton.h"

@implementation RoundButton

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/



-(id)initWithCoder:(NSCoder *)aDecoder
{
    if (self = [super initWithCoder:aDecoder]) {
        self.cornerRadius = 2.0;
    }
    return self;
}

-(id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.cornerRadius = 2.0;
    }
    return self;
}

@end
