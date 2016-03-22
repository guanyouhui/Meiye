//
//  VerticallyAlignedLabel.h
//  CateOrder
//
//  Created by 黄敏昇 on 14-8-6.
//  Copyright (c) 2014年 JYNT. All rights reserved.

//此自定义类是lable的子类,效果是lable文字从坐上角开始

#import <UIKit/UIKit.h>
typedef enum VerticalAlignment {
    VerticalAlignmentTop,
    VerticalAlignmentMiddle,
    VerticalAlignmentBottom,
} VerticalAlignment;

@interface VerticallyAlignedLabel : UILabel
{
    @private  VerticalAlignment verticalAlignment_;
}

@property (nonatomic, assign) VerticalAlignment verticalAlignment;

@end
