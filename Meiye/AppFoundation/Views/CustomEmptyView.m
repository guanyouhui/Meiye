//
//  CustomEmptyView.m
//  PaixieMall
//
//  Created by guoliang chen on 13-3-28.
//  Copyright (c) 2013年 拍鞋网. All rights reserved.
//

#import "CustomEmptyView.h"

@interface CustomEmptyView()
{
 
}
@end

@implementation CustomEmptyView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self createViewWithStyle:EmptyStyle_imageAndtext];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame withStyle:(EmptyStyle)style
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor  = [UIColor clearColor];
        [self createViewWithStyle:style];
    }
    
    return self;
}

- (void)createViewWithStyle:(EmptyStyle)style
{
    self.userInteractionEnabled = NO;
    _o_massageLabel = [[UILabel alloc]initWithFrame:CGRectMake(10, TOP_MARGIN, self.width - 20, 25)];
    _o_massageLabel.backgroundColor = [UIColor clearColor];
    _o_massageLabel.textAlignment = NSTextAlignmentCenter;
    _o_massageLabel.font = [UIFont systemFontOfSize:14];
    _o_massageLabel.textColor = RGBS(153);
    _o_massageLabel.backgroundColor = [UIColor clearColor];
    
    [self addSubview:_o_massageLabel];
    if (style == EmptyStyle_imageAndtext) {
        
        _o_emptyIcon = [[UIImageView alloc]initWithFrame:CGRectMake(0, TOP_MARGIN, 80, 80)];
        _o_emptyIcon.userInteractionEnabled = NO;
        [ZUtilsView centralizeXYInSuperView:self subView:_o_emptyIcon];
        _o_emptyIcon.image = [UIImage imageNamed:@"all_empty_icon.png"];
    
        [self addSubview:_o_emptyIcon];
        
        _o_massageLabel.top = _o_emptyIcon.bottom + 10;
    }
}

- (void)setO_isCenter:(BOOL)o_isCenter
{
    _o_isCenter = o_isCenter;
    
    [self setEmptyViewCenter];
}

- (void)setEmptyViewCenter
{
    if (_o_style == EmptyStyle_imageAndtext) {
        CGFloat height = _o_massageLabel.height + _o_emptyIcon.height;
        CGFloat top = (self.height - height)/2;
        _o_emptyIcon.y = top;
        _o_massageLabel.y = _o_emptyIcon.bottom;
    }else if (_o_style == EmptyStyle_noImage){
        CGFloat top = (self.height - _o_massageLabel.height)/2;
        _o_massageLabel.y = top;
    }
}


- (void)setPromotion:(NSString *)promotion {
    _promotion = promotion;
    _o_massageLabel.text = promotion;
}



@end
