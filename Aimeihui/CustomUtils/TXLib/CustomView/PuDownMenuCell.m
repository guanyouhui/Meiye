//
//  PuDownMenuCell.m
//  TinySeller
//
//  Created by tingxie on 15/4/16.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "PuDownMenuCell.h"

@implementation PuDownMenuCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setO_text:(NSString *)o_text{
    _o_text = o_text;
    
    _o_titleLabel.text = o_text;
    CGFloat width = [ZUtilsString estimateTextWidthByContent:o_text textFont:_o_titleLabel.font];
    _o_titleLabel.width = MIN(width, 260.0);
    _o_titleLabel.centerX = self.centerX;
    _o_checkmark.x = _o_titleLabel.right + 10.0f;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
/**
 *  设置数据源
 */
//- (void)loadDataWith:(SellerLogisicsComany *)log isCheck:(BOOL)isCheck
//{
//    o_checkImageView.hidden = isCheck?NO:YES;
//    _o_titleLabel.textColor = isCheck?RGB(227, 73, 73):RGB(102, 102, 102);
//    
//    _o_titleLabel.text = log.o_name;
//    
//    CGSize textSize = [ZUtilsString getTextSizeWithStyle:@{ NSFontAttributeName :[UIFont systemFontOfSize:14.0]} withFont:[UIFont systemFontOfSize:14.0] wihtText:_o_titleLabel.text withMaxWidth:300 withLineBrak:NSLineBreakByCharWrapping];
//    _o_titleLabel.width = textSize.width;
//    
//    [ZUtilsView centralizeXInSuperView:self.contentView subView:_o_titleLabel];
//    o_checkImageView.left = _o_titleLabel.right + 5;
//}
@end
