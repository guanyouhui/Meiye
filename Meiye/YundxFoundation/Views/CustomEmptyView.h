//
//  CustomEmptyView.h
//  PaixieMall
//
//  Created by guoliang chen on 13-3-28.
//  Copyright (c) 2013年 拍鞋网. All rights reserved.
//

#import <UIKit/UIKit.h>

#define TOP_MARGIN 115

typedef enum : NSUInteger {
    EmptyStyle_imageAndtext = 0,    //图文
    EmptyStyle_noImage              //只有文字
} EmptyStyle;


@interface CustomEmptyView : UIView

- (id)initWithFrame:(CGRect)frame withStyle:(EmptyStyle)style;

@property (assign, nonatomic) EmptyStyle o_style;

@property (assign, nonatomic) BOOL o_isCenter;

@property (strong, nonatomic) UILabel *o_massageLabel;
@property (strong, nonatomic) NSString *promotion;                    //显示的文字
@property (strong, nonatomic) UIImageView *o_emptyIcon;      //图片
@end
