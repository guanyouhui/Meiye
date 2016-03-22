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
    
    UIView* o_tableViewFootView;
}

@end

@implementation RefreshTableView

@synthesize refreshDelegate, footerView=_footerView, paging=_paging;

- (id)initWithFrame:(CGRect)frame style:(UITableViewStyle)style{
    
    self = [super initWithFrame:frame style:style];
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
    
    _o_isHaveFooterView = YES;
    
    [self addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    
    refreshControl = [[ISRefreshControl alloc] init];
    [self addSubview:refreshControl];
    
    [refreshControl addTarget:self
                       action:@selector(refreshing)
             forControlEvents:UIControlEventValueChanged];
    
    
    self.paging = [[Paging alloc] init];
    
    o_tableViewFootView = [self createTableFootView];
}

- (void)setContentOffset:(CGPoint)contentOffset{
    //手指拖拽时， 重置tableview的contentoffset 。 视为无效操作
    if (contentOffset.y == 0.0f && self.isTracking) {
        return;
    }
    [super setContentOffset:contentOffset];
}
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    
    if ([keyPath isEqualToString:@"contentOffset"]) {
        
        [self monitoringContentOffset];
        
    }
}

-(void) setTableHeaderView:(UIView *)tableHeaderView
{
    [super setTableHeaderView:tableHeaderView];
    
    
    if (self.footerView){
        CGRect frame = self.footerView.frame;
        frame.origin = CGPointMake(0, self.contentSize.height);
        self.footerView.frame = frame;
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


-(void) setO_isHaveFooterView:(BOOL)o_isHaveFooterView
{
    _o_isHaveFooterView = o_isHaveFooterView;
    if (_o_isHaveFooterView) {
        self.tableFooterView = o_tableViewFootView;
    }else{
        self.tableFooterView = nil;
    }
}


-(UIView*) createTableFootView
{
    UIView *footerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 40)];
    UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(100, 10, 117, 20)];
    imageView.image = [UIImage imageNamed:@"search_img_no_more.png"];
    [footerView addSubview:imageView];
    return footerView;
}

-(BOOL) isHaveCells
{
    BOOL tHaveCells = NO;
    NSInteger sectionValue = [self numberOfSections];
    
    for (NSInteger section = 0; section < sectionValue; section++) {
        NSInteger rows =  [self numberOfRowsInSection:section];
        if (rows>0) {
            tHaveCells = YES;
            break;
        }
    }
    
    return tHaveCells;
}

-(BOOL) isContentSizeHaveMoreThanSelfFrame
{
    CGSize contentsize = self.contentSize;
    
    return contentsize.height>self.frame.size.height;
    
}



#pragma mark - Override super methods

- (void)reloadData {
    [super reloadData];
    
    //    if (hasMoreData) {
    if (self.footerView == nil) {
        self.footerView = [[RefreshTableFooterView alloc] initWithFrame:CGRectMake(0, self.contentSize.height, self.frame.size.width, 44)];
    } else {
        CGRect frame = self.footerView.frame;
        frame.origin = CGPointMake(0, self.contentSize.height);
        self.footerView.frame = frame;
    }
    //    }
    
    if (![self isHaveCells] || ![self isContentSizeHaveMoreThanSelfFrame]) {
        self.tableFooterView = nil;
    }
    
}

- (void) dealloc
{
    [self removeObserver:self forKeyPath:@"contentOffset"];
}


#pragma mark - Pull to refresh data

- (void)refreshing {
    if (!self.paging) {
        self.paging = [[Paging alloc] init];
    }
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
        self.tableFooterView = nil;
        float bottomEdge = self.contentOffset.y + self.frame.size.height;
        if (bottomEdge > self.contentSize.height + footerHeight + 20) {
            
            if (self.isTracking) {
                [self.footerView updateState:RefreshTableFooterViewPulling];
            } else {
                if (self.decelerating) {
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
    }else{
        if (self.o_isHaveFooterView && [self isHaveCells] && [self isContentSizeHaveMoreThanSelfFrame]) {
            
            if (self.tableFooterView != o_tableViewFootView) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    self.tableFooterView = o_tableViewFootView;
                });
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
    
    NSInteger _state;
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
