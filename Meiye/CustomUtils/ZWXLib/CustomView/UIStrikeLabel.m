//
//  UIStrikeLabel.m
//  EnwaysFoundation
//
//  Created by Jackson Fu on 11/15/11.
//  Copyright (c) 2012 厦门英睿信息科技有限公司. All rights reserved.
//

#import "UIStrikeLabel.h"

@implementation UIStrikeLabel

@synthesize strikeColor;

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:rect];
    
    CGSize textSize = [self.text sizeWithFont:[self font]];
    CGFloat strikeWidth = textSize.width;
    
    CGColorRef strikeColorRef = (strikeColor == nil) ? self.textColor.CGColor : strikeColor.CGColor;
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, strikeColorRef);
    CGContextFillRect(context, CGRectMake(0, rect.size.height/2, strikeWidth, 1));
}


@end
