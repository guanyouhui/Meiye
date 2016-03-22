//
//  TXLineView.m
//  TinyShop
//
//  Created by tingxie on 15/10/13.
//  Copyright © 2015年 zhenwanxiang. All rights reserved.
//

#import "TXLineView.h"

@implementation TXLineView

- (void)awakeFromNib{
    UIView * lineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    lineView.backgroundColor = self.backgroundColor;
    [self addSubview:lineView];
    self.backgroundColor = [UIColor clearColor];
    
    if (self.width == 1.0f) {
        lineView.width = 0.5f;
    }
    if (self.height == 1.0f) {
        lineView.height = 0.5f;
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
