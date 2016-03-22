//
//  XHEntiretyView.h
//  XHScrollMenu
//
//  Created by tingxie on 15/1/10.
//  Copyright (c) 2015年 曾宪华 QQ群: (142557668) QQ:543413507  Gmail:xhzengAIB@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XHMenu.h"
#import "XHScrollMenu.h"

@interface DiscoverView : UIView<XHScrollMenuDelegate, UIScrollViewDelegate>
@property (nonatomic, strong) UIScrollView *scrollView;
@property (nonatomic, assign) id <XHScrollMenuDelegate> delegate;
@property (nonatomic, strong) NSArray *menuTitles;
@property (nonatomic, strong) XHScrollMenu *scrollMenu;

@end
