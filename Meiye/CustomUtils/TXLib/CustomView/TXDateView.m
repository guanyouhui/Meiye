//
//  TXDateView.m
//  TinySeller
//
//  Created by tingxie on 15/5/7.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "TXDateView.h"

@implementation TXDateView

//确认选择到期时间
- (IBAction)confirmDateAction:(id)sender {
    [self animateShowDatePickerView:NO];
    
    if ([self.o_delegate respondsToSelector:@selector(dateView:didSeletedDate:)]) {
        [self.o_delegate dateView:self didSeletedDate:self.o_datePicker.date];
    }
    [self hidden];
}


#pragma mark - 实例方法
- (void)show{
    [self animateShowDatePickerView:YES];
}

- (void)hidden{
    
    [self animateShowDatePickerView:NO];
}


#pragma mark - PickerViewAnimation
- (void)animateShowDatePickerView:(BOOL)show {
    
    [UIView animateWithDuration:0.3f animations:^{
        self.y=show?(self.superview.height-self.height) : self.superview.height;
    }];
    
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
