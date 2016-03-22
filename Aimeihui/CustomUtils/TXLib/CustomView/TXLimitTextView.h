//
//  TXLimitTextView.h
//  TinySeller
//
//  Created by tingxie on 15/5/28.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXLimitTextView : UIView<UITextViewDelegate>

@property (strong, nonatomic) IBOutlet UIPlaceHolderTextView *o_textView;
@property (strong, nonatomic) IBOutlet  UILabel *o_limitCountLabel;

@property (nonatomic, assign) NSInteger o_maxLimit;

@property (weak,nonatomic) id<UITextViewDelegate> o_textViewDelegate;

- (void)fitLimitCount;

@end
