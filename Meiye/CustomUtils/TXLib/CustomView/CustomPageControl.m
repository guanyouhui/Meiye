//
//  HotelPageControl.m
//  iPortTravel
//
//  Created by guoliangchen on 13-12-13.
//  Copyright (c) 2013年 厦门翔业集团有限公司. All rights reserved.
//

#import "CustomPageControl.h"

@implementation CustomPageControl {
    UIImage*_activeImage;
    UIImage*_inactiveImage;
}

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        _activeImage= [UIImage imageNamed:@"inactiveGray.png"];
        _inactiveImage=[UIImage imageNamed:@"inactiveRed.png"];
    }
    
    
    for(int i=0; i<self.subviews.count; i++) {
        
        UIView* dotView = [self.subviews objectAtIndex:i];
        [dotView setBackgroundColor:[UIColor clearColor]];
    }
    
    return self;
}

- (void)updateDots {
    for(int i=0; i<self.subviews.count; i++) {
        
        UIView* dotView = [self.subviews objectAtIndex:i];
        UIImageView* dot = nil;
        [dotView setBackgroundColor:[UIColor clearColor]];
        for (UIView* subview in dotView.subviews) {
            
            if ([subview isKindOfClass:[UIImageView class]]) {
                dot = (UIImageView*)subview;
                break;
            }
            
        }
        
        if (dot == nil) {
            dot = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, _activeImage.size.width, _activeImage.size.height)];
            [dotView addSubview:dot];
        }
        
        if (i == self.currentPage) {
            dot.image = _activeImage;
        } else {
            dot.image = _inactiveImage;
        }
        
    }
}

- (void)setCurrentPage:(NSInteger)currentPage {
    [super setCurrentPage:currentPage];
    [self updateDots];
}

@end