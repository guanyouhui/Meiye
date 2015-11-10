//
//  RefreshTableView.m
//  RefreshTableView
//
//  Created by Jackson Fu on 1/8/13.
//  Copyright (c) 2013 厦门英睿信息科技有限公司. All rights reserved.
//

#import "RefreshTableView.h"
#import "ISRefreshControl.h"

@interface RefreshTableView () {
    ISRefreshControl *refreshControl;
    
    int footerHeight;
    BOOL hasMoreData;
    BOOL pullingMoreData;
}

@end

@implementation RefreshTableView

@synthesize refreshDelegate, footerView=_footerView, paging=_paging;

- (id)initWithFrame:(CGRect)frame {
    
    self = [super initWithFrame:frame];
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (void)initComponents {
    [self addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    
    refreshControl = [[ISRefreshControl alloc] init];
    [self addSubview:refreshControl];
    
    [refreshControl addTarget:self
                    action:@selector(refreshing)
                  forControlEvents:UIControlEventValueChanged];
    
    
    self.paging = [[Paging alloc] init];
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        [self monitoringContentOffset];
        
    }
}

- (void)setFooterView:(RefreshTableFooterView *)footerView {
    
    _footerView = footerView;
    _footerView.hidden = YES;
    [self addSubview:footerView];
    
    footerHeight = footerView.frame.size.height;
}

- (void)setPaging:(Paging *)paging {
    if (_paging == nil) {
        _paging = paging;
    } else {
        _paging.page = paging.page;
        _paging.pages = paging.pages;
        _paging.pageSize = paging.pageSize;
        _paging.records = paging.records;
    }
    
    hasMoreData = (_paging.page < _paging.pages);
}

- (void)scrollToTableTop {
    [self scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] atScrollPosition:UITableViewScrollPositionTop animated:NO];
}

#pragma mark - Override super methods

- (void)reloadData {
    [super reloadData];
    
    if (hasMoreData) {
        if (self.footerView == nil) {
            self.footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, 44)];
        } else {
            CGRect frame = self.footerView.frame;
            frame.origin = CGPointMake(0, self.contentSize.height);
            self.footerView.frame = frame;
        }
    }
    
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}


#pragma mark - Pull to refresh data

- (void)refreshing {
    self.paging = [[Paging alloc] init];
    
    if (refreshDelegate != nil) {
        [refreshDelegate beginRefreshing];
    }
}

- (void)endRefreshing {
    
    if (refreshControl.refreshing) {
        [refreshControl endRefreshing];
    }
    
    if (self.footerView != nil && pullingMoreData) {
        pullingMoreData = NO;
        [self updateBottomInset];
        [self.footerView resetState];
    }
}

#pragma mark - Pull more data

- (void)monitoringContentOffset {
    
    if (self.footerView == nil) {
        return;
    }
    
    hasMoreData = (_paging.page < _paging.pages);
    
    if (hasMoreData && self.footerView.hidden) {
        self.footerView.hidden = NO;
    } else if (!hasMoreData) {
        self.footerView.hidden = YES;
    }
    
    if (hasMoreData) {
        float bottomEdge = self.contentOffset.y + self.frame.size.height;
        if (bottomEdge > self.contentSize.height + footerHeight + 20) {
            
            if (self.isTracking) {
                [self.footerView updateState:RefreshTableFooterViewPulling];
            } else {
                [self.footerView updateState:RefreshTableFooterViewLoading];
                [self updateBottomInset];
                
                if (refreshDelegate != nil && [refreshDelegate respondsToSelector:@selector(pullingMoreData)] && !pullingMoreData) {
                    _paging.page ++;
                    [refreshDelegate pullingMoreData];
                }
                
                pullingMoreData = YES;
            }
            
        }
    }
}


- (void)updateBottomInset {
    
    int64_t delayInSeconds = 0.1;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
        [UIView animateWithDuration:.3f
                         animations:^{
                             self.contentInset = (pullingMoreData) ? UIEdgeInsetsMake(0, 0.0f, footerHeight, 0.0f) : UIEdgeInsetsZero;
                         }];
    });
    
}

@end


#pragma mark - RefreshTableFooterView implementation


@interface RefreshTableFooterView () {
    UIActivityIndicatorView* indicatoreView;
    UILabel* label;
    
    int _state;
}

@end

@implementation RefreshTableFooterView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    
    if (self) {
        [self initComponents];
    }
    
    return self;
}

- (void)initComponents {
    
    label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    label.backgroundColor = [UIColor clearColor];
    label.text = @"上拉加载更多数据";
    label.font = [UIFont systemFontOfSize:13];
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
    
    
    indicatoreView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    indicatoreView.hidden = YES;
    indicatoreView.center = CGPointMake(80, 22);
    [indicatoreView stopAnimating];
    
    [self addSubview:indicatoreView];
    
}

- (void)updateState:(RefreshTableFooterViewState)state {
    
    [indicatoreView stopAnimating];
    
    switch (state) {
        case RefreshTableFooterViewPulling:
            label.text = @"释放加载更多数据";
            indicatoreView.hidden = YES;
            break;
            
        case RefreshTableFooterViewNormal:
            indicatoreView.hidden = YES;
            label.text = @"上拉加载更多数据";
            break;
            
        case RefreshTableFooterViewLoading:
            indicatoreView.hidden = NO;
            [indicatoreView startAnimating];
            
            label.text = @"正在加载...";
            break;
            
        default:
            break;
    }
    
    _state = state;
    
}

- (void)resetState {
    [self updateState:RefreshTableFooterViewNormal];
}


@end
