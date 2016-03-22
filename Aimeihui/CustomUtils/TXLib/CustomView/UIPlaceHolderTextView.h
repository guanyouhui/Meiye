//
//  UIPlaceHolderTextView.h
//  ceshi
//
//  Created by tingxie on 14-10-22.
//  Copyright (c) 2014年 wangtingxie. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIPlaceHolderTextView : UITextView
{
    
    NSString *placeholder;
    
    
    
@private
    
    UILabel *placeHolderLabel;
    
}



@property(nonatomic, retain) UILabel *placeHolderLabel;

@property(nonatomic, retain) NSString *placeholder;


@end
