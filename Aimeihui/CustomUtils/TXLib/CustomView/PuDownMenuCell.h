//
//  PuDownMenuCell.h
//  TinySeller
//
//  Created by tingxie on 15/4/16.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import <UIKit/UIKit.h>
@interface PuDownMenuCell : UITableViewCell

@property (copy, nonatomic) NSString * o_text;

@property (strong, nonatomic) IBOutlet UIImageView *o_checkmark;
@property (nonatomic, weak) IBOutlet UILabel *o_titleLabel;
@property (strong, nonatomic) IBOutlet UIView *o_lineView;

@end
