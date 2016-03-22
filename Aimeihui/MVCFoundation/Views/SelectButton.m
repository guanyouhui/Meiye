//
//  SelectButton.m
//  HeiBoss
//
//  Created by tingxie on 14-10-17.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "SelectButton.h"

@implementation SelectButton

-(void)setO_isDescending:(BOOL)o_isDescending{
    _o_isDescending=o_isDescending;
    UIImage * btnImage=nil;
    if (o_isDescending==YES) {
        btnImage=[UIImage imageNamed:@"search_filter_down.png"];
    }
    else{
        btnImage=[UIImage imageNamed:@"search_filter_up.png"];
    }
    [self setImage:btnImage forState:UIControlStateNormal];
    CGFloat edgeTitleWidth= btnImage.size.width/2;
    
    
    NSString * title=[self titleForState:UIControlStateNormal];
    CGFloat edgeImgaeWidth= title.length * 15 + 9;
    [self setTitleEdgeInsets:UIEdgeInsetsMake(0, -edgeTitleWidth, 0, edgeTitleWidth)];
    [self setImageEdgeInsets:UIEdgeInsetsMake(0, edgeImgaeWidth, 0, -edgeImgaeWidth)];
}
-(void)setO_selected:(BOOL)o_selected{
    _o_selected=o_selected;
    if (o_selected) {
//        [self setBackgroundImage:[UIImage imageNamed:@"date1_press.png"] forState:UIControlStateNormal];
        [self setTitleColor:RGB(227, 72, 73) forState:UIControlStateNormal];
    }
    else{
        [self setImage:nil forState:UIControlStateNormal];
        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
        [self setBackgroundImage:nil forState:UIControlStateNormal];
        [self setTitleColor:RGBS(102) forState:UIControlStateNormal];
        
    }
}
//-(void)setSelected:(BOOL)selected{
//    if (!selected) {
//        [self setImage:nil forState:UIControlStateSelected];
//        [self setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//        [self setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 0)];
//    }
//    [super setSelected:selected];
//}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
