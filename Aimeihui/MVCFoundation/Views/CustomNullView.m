//
//  CustomNullView.m
//  YundxUser
//
//  Created by tingxie on 16/1/21.
//  Copyright © 2016年 王庭协. All rights reserved.
//

#import "CustomNullView.h"

@implementation CustomNullView

@synthesize promotionlabel, promotion=_promotion;

- (id)init {
    return [self initFromNib:@"CustomEmptyView"];
}

- (id)initFromNib:(NSString *)nibName {
    
    NSArray *array = [[NSBundle mainBundle] loadNibNamed:nibName
                                                   owner:self
                                                 options:nil];
    
    self = [array objectAtIndex:0];
    //    [self initComponents];
    
    return self;
}



- (void)setPromotion:(NSString *)promotion {
    _promotion = promotion;
    promotionlabel.text = promotion;
}


@end
