//
//  TXAutoScrollView.m
//  WeiXiaoDian
//
//  Created by Pro on 8/26/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//
#define OffSet_Hig 30
#define KOYBORAD_HIG 253
#import "TXAutoScrollView.h"

@implementation TXAutoScrollView
{
    CGSize originalSize;
    CGPoint originalPoint;
    
    CGFloat keyboradHeight;
    
    UITapGestureRecognizer * backgroundTap;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        
    }
    return self;
}

- (void)setMaxContentOffsetY:(CGFloat)maxContentOffsetY{
    _maxContentOffsetY = maxContentOffsetY;
    self.contentSize = CGSizeMake(self.width, maxContentOffsetY);
    originalSize = self.contentSize;
}

-(void)awakeFromNib{
    keyboradHeight = KOYBORAD_HIG;
    //键盘将要显示时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeShow:)name:UIKeyboardWillShowNotification object:nil];
    //键盘将要消失时的触发事件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(keyboardWillBeHidden)name:UIKeyboardWillHideNotification object:nil];
//
//    UITapGestureRecognizer * tap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
//    [self addGestureRecognizer:tap];
}
#pragma mark --  textFieldDelegate
-(void)textFieldDidBeginEditing:(UITextField *)textField{
    [self setContentInsetWithFrame:textField];
    
    if ([_txtDelegate respondsToSelector:@selector(textFieldDidBeginEditing:)]) {
        [_txtDelegate textFieldDidBeginEditing:textField];
    }
}
- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    [self assignmentContent];
    
    if ([_txtDelegate respondsToSelector:@selector(textFieldShouldBeginEditing:)]) {
       return [_txtDelegate textFieldShouldBeginEditing:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldEndEditing:(UITextField *)textField{
    if ([_txtDelegate respondsToSelector:@selector(textFieldShouldEndEditing:)]) {
       return  [_txtDelegate textFieldShouldEndEditing:textField];
    }
    return YES;
}
- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([_txtDelegate respondsToSelector:@selector(textFieldDidEndEditing:)]) {
        [_txtDelegate textFieldDidEndEditing:textField];
    }
}
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if ([_txtDelegate respondsToSelector:@selector(textField:shouldChangeCharactersInRange:replacementString:)]) {
        return [_txtDelegate textField:textField shouldChangeCharactersInRange:range replacementString:string];
    }
    return YES;
}
- (BOOL)textFieldShouldClear:(UITextField *)textField{
    if ([_txtDelegate respondsToSelector:@selector(textFieldShouldClear:)]) {
        return [_txtDelegate textFieldShouldClear:textField];
    }
    return YES;
}
- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    if ([_txtDelegate respondsToSelector:@selector(textFieldShouldReturn:)]) {
       return [_txtDelegate textFieldShouldReturn:textField];
    }
    return YES;
}

#pragma mark -- textViewDelegate
- (BOOL)textViewShouldBeginEditing:(UITextView *)textView{
    [self assignmentContent];
    if ([_txtViewDelegate respondsToSelector:@selector(textViewShouldBeginEditing:)]) {
        return [_txtViewDelegate textViewShouldBeginEditing:textView];
    }
    return YES;
}
- (BOOL)textViewShouldEndEditing:(UITextView *)textView{
    if ([_txtViewDelegate respondsToSelector:@selector(textViewShouldEndEditing:)]) {
        return [_txtViewDelegate textViewShouldEndEditing:textView];
    }
    return YES;
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    [self setContentInsetWithFrame:textView];
    
    if ([_txtViewDelegate respondsToSelector:@selector(textViewDidBeginEditing:)]) {
        [_txtViewDelegate textViewDidBeginEditing:textView];
    }
}
- (void)textViewDidEndEditing:(UITextView *)textView{
    if ([_txtViewDelegate respondsToSelector:@selector(textViewDidEndEditing:)]) {
        [_txtViewDelegate textViewDidEndEditing:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([_txtViewDelegate respondsToSelector:@selector(textView:shouldChangeTextInRange:replacementText:)]) {
        return [_txtViewDelegate textView:textView shouldChangeTextInRange:range replacementText:text];
    }
    return YES;
}
- (void)textViewDidChange:(UITextView *)textView{
    if ([_txtViewDelegate respondsToSelector:@selector(textViewDidChange:)]) {
        [_txtViewDelegate textViewDidChange:textView];
    }
}

- (void)textViewDidChangeSelection:(UITextView *)textView{
    if ([_txtViewDelegate respondsToSelector:@selector(textViewDidChangeSelection:)]) {
        [_txtViewDelegate textViewDidChangeSelection:textView];
    }
}

- (BOOL)textView:(UITextView *)textView shouldInteractWithURL:(NSURL *)URL inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
        if ([_txtViewDelegate respondsToSelector:@selector(textView:shouldInteractWithURL:inRange:)]) {
            return [_txtViewDelegate textView:textView shouldInteractWithURL:URL inRange:characterRange];
        }
        return YES;
}
- (BOOL)textView:(UITextView *)textView shouldInteractWithTextAttachment:(NSTextAttachment *)textAttachment inRange:(NSRange)characterRange NS_AVAILABLE_IOS(7_0){
    if ([_txtViewDelegate respondsToSelector:@selector(textView:shouldInteractWithTextAttachment:inRange:)]) {
        return [_txtViewDelegate textView:textView shouldInteractWithTextAttachment:textAttachment inRange:characterRange];
    }
    return YES;
}
#pragma end mark
-(void)setContentInsetWithFrame:(UIView *)aView{
    
    //获取aView在scrollview上的位置
    CGRect parentRect = [aView convertRect:aView.bounds toView:self];
    
    CGFloat flag1=CGRectGetMaxY(parentRect)+64;
    CGFloat flag2=[[UIScreen mainScreen ] bounds ].size.height-keyboradHeight;
    CGFloat flag3=flag1-flag2+OffSet_Hig;
    
    self.contentSize=CGSizeMake(originalSize.width, (_maxContentOffsetY>0?_maxContentOffsetY:self.bounds.size.height) + keyboradHeight);
    if (flag1>=flag2) {
        
        [self setContentOffset:CGPointMake(0, flag3) animated:YES];
    }
}

-(UIView*) getSubViewIsFirstResponderWithView:(UIView*)parent
{
    for (UIView* subView in parent.subviews) {
        if ([subView isKindOfClass:[UITextField class]] || [subView isKindOfClass:[UITextView class]]) {
            if ([subView isFirstResponder]) {
                return subView;
            }
        }else{
            UIView* frView = [self getSubViewIsFirstResponderWithView:subView];
            if (frView) {
                return frView;
            }
        }
    }
    
    return nil;
}


-(BOOL) assignmentContent{
    if ([self getSubViewIsFirstResponderWithView:self]) {
        return YES;
    }
    
    originalSize=self.contentSize;
    originalPoint=self.contentOffset;
    return NO;
}



-(void)keyboardWillBeShow:(NSNotification *)aNotification{
    
    backgroundTap=[[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(dismissKeyBoard)];
    [self addGestureRecognizer:backgroundTap];
}

-(void)keyboardWillBeHidden{
    self.contentSize=originalSize;
//    [self setContentOffset:originalPoint animated:YES];
    
    [self removeGestureRecognizer:backgroundTap];
}
-(void)dismissKeyBoard{
    UIView* frView = [self getSubViewIsFirstResponderWithView:self];
    [frView resignFirstResponder];
    
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/
-(void)dealloc{
    
    //移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}
@end
