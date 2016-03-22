//
//  TXLimitTextView.m
//  TinySeller
//
//  Created by tingxie on 15/5/28.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "TXLimitTextView.h"

@interface TXLimitTextView ()

@end

@implementation TXLimitTextView

- (void)setO_maxLimit:(NSInteger)o_maxLimit{
    _o_maxLimit = o_maxLimit;
    
    if (![self.o_textView.text isNotEmpty]) {
        self.o_limitCountLabel.text = FORMAT(@"%ld",(long)o_maxLimit);
    }else{
        [self textEditChangeWithText:[self.o_textView text]];
    }
}

- (void)fitLimitCount{
    [self textEditChangeWithText:[self.o_textView text]];
}

#pragma mark-描述字符改变
- (void)textEditChangeWithText:(NSString *)text
{
    NSInteger textLength = text.length;
    NSInteger textRemain = self.o_maxLimit - textLength;
    
    self.o_limitCountLabel.text = [NSString stringWithFormat:@"%ld",(long)textRemain];
    
    if (textLength > self.o_maxLimit) {
        self.o_limitCountLabel.textColor = SUBJECT_COLOR;
    }else{
        self.o_limitCountLabel.textColor = self.o_textView.textColor;
    }
}
#pragma mark -- textViewDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    
    if ([text isEqualToString:@"\n"]){
        
        return YES;
    }
    
    NSString * aString = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    //超过限制100字
    [self textEditChangeWithText:aString];
    
    if ([self.o_textViewDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [self.o_textViewDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView
{
    if ([self.o_textViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [self.o_textViewDelegate textViewDidChange:textView];
    }
    [self textEditChangeWithText:textView.text];
}

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    if ([self.o_textViewDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [self.o_textViewDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([self.o_textViewDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [self.o_textViewDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    if ([self.o_textViewDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [self.o_textViewDelegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([self.o_textViewDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [self.o_textViewDelegate textViewDidEndEditing:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([self.o_textViewDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [self.o_textViewDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if ([self.o_textViewDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
        return [self.o_textViewDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
    }
    return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if ([self.o_textViewDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [self.o_textViewDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
