//
//  ZUtilsView.m
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "ZUtilsView.h"

@implementation ZUtilsView
/**
 * 从与类名对应的XIB文件中加载View对象，View的owner为nil
 */
+ (id)loadViewWithViewClass:(Class)viewClass
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(viewClass) owner:nil options:nil];
    id xibView = xibs.count>0?xibs[0]:nil;
    return xibView;
}

/**
 * 从与类名对应的XIB文件中加载指定索引的View对象，View的owner为nil
 */
+ (id)loadViewWithViewClass:(Class)viewClass atIndex:(NSUInteger)index
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(viewClass) owner:nil options:nil];
    
    id xibView = nil;
    @try {
        xibView = xibs[index];
    }
    @catch (NSException *exception) {
        xibView = nil;
        NSLog(@"Fun:%s ---- \n%@",__FUNCTION__,exception);
    }
    return xibView;
}

/**
 * 从与类名对应的XIB文件中加载View对象，允许指定View的owner
 */
+ (id)loadViewWithViewClass:(Class)viewClass owner:(id)owner
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(viewClass) owner:owner options:nil];
    id xibView = xibs.count>0?xibs[0]:nil;
    return xibView;
}

/**
 * 从与类名对应的XIB文件中加载指定索引的View对象，允许指定View的owner
 */
+ (id)loadViewWithViewClass:(Class)viewClass owner:(id)owner atIndex:(NSUInteger)index
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:NSStringFromClass(viewClass) owner:owner options:nil];
    id xibView = nil;
    @try {
        xibView = xibs[index];
    }
    @catch (NSException *exception) {
        xibView = nil;
        NSLog(@"Fun:%s ---- \n%@",__FUNCTION__,exception);
    }
    return xibView;
}

/**
 * 从XIB文件中加载View对象，View的owner为nil
 */
+ (id)loadViewFromNib:(NSString *)nibName
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    id xibView = xibs.count>0?xibs[0]:nil;
    return xibView;
}

/**
 * 从XIB文件中加载View对象，允许指定View的owner
 */
+ (id)loadViewFromNib:(NSString *)nibName owner:(id)owner
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:nibName owner:owner options:nil];
    id xibView = xibs.count>0?xibs[0]:nil;
    return xibView;
}

/**
 *  从与类名对应的XIB文件中加载指定索引的View对象，允许指定View的owner
 */
+ (id)loadViewFromNib:(NSString *)nibName owner:(id)owner atIndex:(NSUInteger)index
{
    NSArray *xibs = [[NSBundle mainBundle]loadNibNamed:nibName owner:nil options:nil];
    id xibView = nil;
    @try {
        xibView = xibs[index];
    }
    @catch (NSException *exception) {
        xibView = nil;
        NSLog(@"Fun:%s ---- \n%@",__FUNCTION__,exception);
    }
    return xibView;
}

/**
 *  删除View的所有sub view
 */
+ (void)removeAllSubViews:(UIView *)view
{
    // one
    NSArray* views = [view subviews];
    for (UIView* tview in views) {
        [tview removeFromSuperview];
    }
    
    //    //two
    //    while (view.subviews.count) {
    //        UIView* child = view.subviews.lastObject;
    //        [child removeFromSuperview];
    //    }
    
}

/**
 * 删除View从指定索引开始的sub view
 */
+ (void)removeSubViews:(UIView *)view fromIndex:(NSUInteger)index
{
    NSArray* views = [view subviews];
    for (NSUInteger i = 0 ; i<views.count; i++) {
        if (i>=index) {
            UIView *subView = views[i];
            [subView removeFromSuperview];
        }
    }
}

/**
 * 删除View中指定索引的sub view
 */
+ (void)removeSubView:(UIView *)view atIndex:(NSUInteger)index
{
    NSArray* views = [view subviews];
    for (NSUInteger i = 0 ; i<views.count; i++) {
        if (i==index) {
            UIView *subView = views[i];
            [subView removeFromSuperview];
        }
    }
}

#pragma mark-

/**
 * 以 X 坐标 居中
 */
+ (void)centralizeXInSuperView:(UIView *)superView subView:(UIView *)subView
{
    CGRect frame = subView.frame;
    frame.origin.x = (superView.frame.size.width - frame.size.width)/2;
    subView.frame = frame;
}

/**
 * 以 Y 坐标 居中
 */
+ (void)centralizeYInSuperView:(UIView *)superView subView:(UIView *)subView
{
    CGRect frame = subView.frame;
    frame.origin.y = (superView.frame.size.height - frame.size.height)/2;
    subView.frame = frame;
}

/**
 * 以 XY（中心点） 坐标 居中
 */
+ (void)centralizeXYInSuperView:(UIView *)superView subView:(UIView *)subView
{
    CGRect frame = subView.frame;
    frame.origin.x = (superView.frame.size.width - frame.size.width)/2;
    frame.origin.y = (superView.frame.size.height - frame.size.height)/2;
    subView.frame = frame;
}
@end
