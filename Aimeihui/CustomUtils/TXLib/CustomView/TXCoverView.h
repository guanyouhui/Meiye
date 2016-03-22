//
//  OTCover.h
//  OTMediumCover
//
//  Created by yechunxiao on 14-9-21.
//  Copyright (c) 2014年 yechunxiao. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXCoverView : UIView

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) UIView* scrollContentView;
@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) UIView* tableHeadContentView;

- (TXCoverView*)initWithTableViewWithHeaderImage:(UIImage*)headerImage withOTCoverHeight:(CGFloat)height;
- (TXCoverView*)initWithScrollViewWithHeaderImage:(UIImage*)headerImage withOTCoverHeight:(CGFloat)height withScrollContentViewHeight:(CGFloat)height;
- (void)setHeaderImage:(UIImage *)headerImage;

@end

@interface UIImage (Blur)
-(UIImage *)boxblurImageWithBlur:(CGFloat)blur;
@end