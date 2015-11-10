//
//  HBCustomerTextField.m
//  HebeiTV
//
//  Created by Pro on 5/19/14.
//  Copyright (c) 2014 MyOrganization. All rights reserved.
//

#import "TXTextField.h"

#define TITLE_SPACE 10
#define CLEAR_BUTTON_WIDTH ((IOS7_OR_LATER)?20:25)
@interface TXTextField()
{
    UIButton * _o_secureButton;
}
@end;

@implementation TXTextField
- (id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initMode];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initMode];
    }
    return self;
}

#pragma mark - init

- (void)setClearButtonMode:(UITextFieldViewMode)clearButtonMode{
    [super setClearButtonMode:clearButtonMode];
    if (clearButtonMode != UITextFieldViewModeNever) {
        _contentEdgeInsets = UIEdgeInsetsMake(_contentEdgeInsets.top, _contentEdgeInsets.left, _contentEdgeInsets.bottom, CLEAR_BUTTON_WIDTH);
    }
}
- (void)setContentEdgeInsets:(UIEdgeInsets)contentEdgeInsets{
    if (self.clearButtonMode != UITextFieldViewModeNever) {
        contentEdgeInsets.right = contentEdgeInsets.right + CLEAR_BUTTON_WIDTH;
    }
    _contentEdgeInsets = contentEdgeInsets;
}
-(void)initMode{
    _contentEdgeInsets = UIEdgeInsetsMake(0, 10, 0, 10);
    self.clearButtonMode=UITextFieldViewModeWhileEditing;
}

#pragma mark - set methods
-(void)setTextTitle:(NSString *)textTitle{
    _textTitle=textTitle;
    if (textTitle) {
        self.leftLabel=[[UILabel alloc]init];
        self.leftLabel.font=self.font;
        self.leftLabel.backgroundColor=[UIColor clearColor];
        self.leftLabel.textAlignment=NSTextAlignmentCenter;
        self.leftLabel.text=[NSString stringWithFormat:@"%@",textTitle];
        
        CGSize titleSize = [textTitle sizeWithFont:self.leftLabel.font constrainedToSize:CGSizeMake(MAXFLOAT, CGRectGetHeight(self.frame))];
        titleSize.width = titleSize.width + TITLE_SPACE*2;
        CGRect nFrame = CGRectZero;
        nFrame.size = titleSize;
        self.leftLabel.frame=nFrame;
        
        self.leftView=self.leftLabel;
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    
    
}
-(void)setTextImage:(UIImage *)textImage{
    _textImage=textImage;
    if (textImage) {
        
        self.leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        self.leftButton.frame = CGRectMake(0, 0, textImage.size.width, textImage.size.height);
        [self.leftButton setImage:textImage forState:UIControlStateNormal];
        self.leftButton.enabled = NO;
        self.leftButton.width = self.leftButton.width + TITLE_SPACE;
        
        self.leftView=self.leftButton;
        self.leftViewMode=UITextFieldViewModeAlways;
    }
    
    
}

- (void)setNeedSecure:(BOOL)needSecure{
    if (needSecure) {
        self.secureTextEntry = YES;
        CGFloat width = 40.0f;
        _o_secureButton = ({
            UIButton * sButton = [UIButton buttonWithType:UIButtonTypeCustom];
            sButton.frame = CGRectMake(self.width - width, 0, width, self.height);
            [sButton setImage:[UIImage imageNamed:@"icon_display1.png"] forState:UIControlStateNormal];
            [sButton setImage:[UIImage imageNamed:@"icon_display2.png"] forState:UIControlStateSelected];
            [sButton addTarget:self action:@selector(changePasswordSecureAction:) forControlEvents:UIControlEventTouchUpInside];
            sButton;
        });
        [self addSubview:_o_secureButton];
//        self.rightView = _o_secureButton;
//        self.rightViewMode = UITextFieldViewModeAlways;
    }else{
        [_o_secureButton removeFromSuperview];
        _o_secureButton = nil;
    }
}

#pragma mark - 方法重写
- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return [self textFrame:bounds];
}
- (CGRect)textRectForBounds:(CGRect)bounds
{
    return [self textFrame:bounds];
}
- (CGRect)placeholderRectForBounds:(CGRect)bounds
{
    return [self textFrame:bounds];
}
- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGFloat clearWidth = 30.0f;
    CGRect clearFrame = CGRectMake(bounds.size.width - clearWidth - _o_secureButton.width , 0, clearWidth, bounds.size.height);
    return clearFrame;
}

-(CGRect)textFrame:(CGRect)bounds{
    CGRect textFrame=CGRectMake(_contentEdgeInsets.left, _contentEdgeInsets.top, bounds.size.width-(_contentEdgeInsets.left+_contentEdgeInsets.right), bounds.size.height-(_contentEdgeInsets.top+_contentEdgeInsets.bottom));
    if (_textTitle) {
        textFrame.origin.x=self.leftLabel.frame.size.width;
        if (self.leftLabel.textAlignment == NSTextAlignmentRight) {
            textFrame.origin.x=self.leftLabel.frame.size.width + 10;
        }
        textFrame.size.width= bounds.size.width-self.leftLabel.frame.size.width;
    }
    else if(_textImage){
        textFrame.origin.x=self.leftButton.frame.size.width;
        textFrame.size.width= bounds.size.width-self.leftButton.frame.size.width;
    }
    
    if (_o_secureButton) {
        textFrame.size.width -= _o_secureButton.width;
    }
    
    if (self.clearButtonMode != UITextFieldViewModeNever) {
        textFrame.size.width=textFrame.size.width-CLEAR_BUTTON_WIDTH;
    }
    return textFrame;
}


#pragma mark - Action
- (void )changePasswordSecureAction:(UIButton *)sender {

    sender.selected = !sender.selected;
    self.secureTextEntry = !sender.selected;
    
    //对密码输入框清空重新赋值，防止切换密码显示存在有“空格”的问题。
    NSString * text = [NSString stringWithString:self.text];
    self.text = @"";
    self.text = text;
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
