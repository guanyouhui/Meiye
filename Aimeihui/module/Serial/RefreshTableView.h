//
//  RefreshTableView.h
//  RefreshTableView
//
//  Created by Jackson Fu on 1/8/13.
//  Copyright (c) 2013 厦门英睿信息科技有限公司. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Paging.h"

@class RefreshTableFooterView;

@protocol RefreshTableViewDelegate <NSObject>

@required
- (void)beginRefreshing;

@optional
- (void)pullingMoreData;

@end

/**
 * 带下拉 和 上拉的 tableview
 */
@interface RefreshTableView : UITableView

@property (nonatomic,weak) id<RefreshTableViewDelegate> refreshDelegate;
@property (strong, nonatomic) Paging *paging;
@property (strong, nonatomic) RefreshTableFooterView *footerView;

/**
 * 是否 有底部的 没有更多 提示View， default 为显示。
 */
@property (nonatomic,assign)BOOL o_isHaveFooterView;

/**
 * 返回到列表顶部
 */
- (void)scrollToTableTop;

/**
 * 结束刷新
 */
- (void)endRefreshing;

@end


typedef enum{
    RefreshTableFooterViewPulling = 0,
    RefreshTableFooterViewNormal,
    RefreshTableFooterViewLoading,
} RefreshTableFooterViewState;


/**
 * 上拉加载的 底部的 view
 */
@interface RefreshTableFooterView : UIView

/*!
 @method     updateState:
 @abstract   更新RefreshTableFooter的状态
 */
- (void)updateState:(RefreshTableFooterViewState)state;

- (void)resetState;

@end