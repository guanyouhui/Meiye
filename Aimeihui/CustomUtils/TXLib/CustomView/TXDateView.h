//
//  TXDateView.h
//  TinySeller
//
//  Created by tingxie on 15/5/7.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TXDateView;

@protocol TXDateViewDelegate <NSObject>

- (void)dateView:(TXDateView*)dateView didSeletedDate:(NSDate *)date;

@end

@interface TXDateView : UIView
@property (strong, nonatomic) IBOutlet UIDatePicker *o_datePicker;
@property (strong, nonatomic) IBOutlet UILabel *o_titleLabel;

@property (nonatomic,weak) id<TXDateViewDelegate>o_delegate;


- (void)show;

- (void)hidden;

@end
