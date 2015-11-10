//
//  ZDroppableView.h
//  DroppableViewTest
//
//  Created by zhwx on 15/4/16.
//
//

#import <UIKit/UIKit.h>
#import "ZDropScrollView.h"

@class ZDroppableView;

@protocol ZDroppableViewDelegate <NSObject>


@optional
/**
 * 拖动开始、结束时 对拖动控件【dropView】的操作
 */
- (void) droppableViewBeganDragging:(ZDroppableView*)dropView;
- (void) droppableViewEndedDragging: (ZDroppableView*)dropView;


/**
 * 拖动控件【dropView】 进入、离开 目标控件【targetView】的操作
 */
- (void) droppableView:(ZDroppableView*)dropView enterTarget:(UIView*)targetView;
- (void) droppableView:(ZDroppableView*)dropView leaveTarget:(UIView*)targetView;

/**
 * 代理方法 是否处理了 【dropView 落在 targetView 的行为】
 * 返回 YES 表示处理了。 返回 NO 表示未处理
 */
- (BOOL) shouldAnimateDroppableView:(ZDroppableView*)dropView isDroppedOnTarget:(UIView*)targetView;


/**
 * 处理 【dropView 和 其他视图 交换位置  的行为】
 *
 * otherDropViews 二级指针 从代理中获得 其他控件的数组对象
 */
-(void) droppableView:(ZDroppableView*)dropView exchangeWithOthers:(NSArray**)otherDropViews;



/**
 * 处理 【dropView 被点击事件】
 *
 */
-(void) droppableViewDidSelected:(ZDroppableView*)dropView;

@end


/**
 * 从数组图片控件 中 拖动到 目标控件
 */
@interface ZDroppableView : UIView


@property (nonatomic,assign) id<ZDroppableViewDelegate> o_delegate;
@property (nonatomic,strong) id o_userInfo;//保存用户 自定义信息

/**
 * 顺序,默认为依次递增
 */
@property (nonatomic,assign) NSUInteger o_index;

/**
 * 默认的 基本动画特效，（默认为YES）
 */
@property (nonatomic,assign) BOOL o_isDefaultAnimation;


/**
 * 用父视图、目标视图、活动区域视图 初始化，拖动控件。
 * superScrollView: self的 superView
 * targetView: 拖到目标区域的 目标视图
 * regionView: 整个 self 能拖动的区域 视图。
 */
-(id) initWithScrollView:(ZDropScrollView *)superScrollView
                  target:(UIView*)targetView
              regionView:(UIView*)regionView;


/**
 * 用父视图、目标视图、活动区域视图 初始化，拖动控件。（非 scrollview）
 * superView: self的 superView
 * targetView: 拖到目标区域的 目标视图
 * regionView: 整个 self 能拖动的区域 视图。
 */
-(id) initWithSuperView:(UIView *)superView
                 target:(UIView*)targetView
             regionView:(UIView*)regionView;



@end
