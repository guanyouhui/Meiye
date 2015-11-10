//
//  ZDroppableView.m
//  DroppableViewTest
//
//  Created by zhwx on 15/4/16.
//
//

#import "ZDroppableView.h"

//长按时间
#define LongPressDuration   0.10f
//View 重叠 区域（宽、高）
#define OverlapRegionSize   1.f


@interface ZDroppableView ()

@property (nonatomic,weak)UIView* o_oldSuperView;
@property (nonatomic,weak)UIView* o_animationRegionView;
@property (nonatomic,weak)UIView* o_targetView;


@property (nonatomic,strong) NSDate* o_touchBeginDate;//开始 时间
@property (nonatomic,assign) BOOL o_isBeginDrag;//是否 判断为拖动 控件

@property (nonatomic,assign) BOOL o_isEntryTagert;//是否进入 目标区域
@property (nonatomic,assign) CGPoint o_oldOriginalPos;//self 的原始 center 坐标


@property (nonatomic,strong)UITapGestureRecognizer* o_tapGestureRecognizer;

@end



@implementation ZDroppableView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

/**
 * 用父视图、目标视图、活动区域视图 初始化，拖动控件。
 * superScrollView: self的 superView
 * targetView: 拖到目标区域的 目标视图
 * regionView: 整个 self 能拖动的区域 视图。
 */
-(id) initWithScrollView:(ZDropScrollView *)superScrollView
                  target:(UIView*)targetView
              regionView:(UIView*)regionView
{
    if(self = [super init]){
        _o_animationRegionView = regionView;
        _o_oldSuperView = superScrollView;
        _o_targetView = targetView;
        
        _o_touchBeginDate = nil;
        _o_isBeginDrag = NO;
        _o_isEntryTagert = NO;
        _o_oldOriginalPos = CGPointZero;
        self.exclusiveTouch = YES;
        [self addTapGestureRecognizer];
    }
    return self;
}


/**
 * 用父视图、目标视图、活动区域视图 初始化，拖动控件。（非 scrollview）
 * superView: self的 superView
 * targetView: 拖到目标区域的 目标视图
 * regionView: 整个 self 能拖动的区域 视图。
 */
-(id) initWithSuperView:(UIView *)superView
                 target:(UIView*)targetView
             regionView:(UIView*)regionView
{
    if(self = [super init]){
        _o_animationRegionView = regionView;
        _o_oldSuperView = superView;
        _o_targetView = targetView;
        
        _o_touchBeginDate = nil;
        _o_isBeginDrag = NO;
        _o_isEntryTagert = NO;
        _o_oldOriginalPos = CGPointZero;
        self.exclusiveTouch = YES;
        [self addTapGestureRecognizer];
    }
    return self;
}


- (NSComparisonResult) compareZDroppableViewIndex:(ZDroppableView*)otherView {
    
    ZDroppableView* selfView = (ZDroppableView*)self;
    
    NSComparisonResult result = selfView.o_index>otherView.o_index?NSOrderedDescending:NSOrderedAscending;
    
    return result;
    
    
}

#pragma mark- 点击手势
-(void) addTapGestureRecognizer
{
    if (!_o_tapGestureRecognizer) {
        _o_tapGestureRecognizer =[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapGestureRecognizerAct:)];
    }
    [self addGestureRecognizer:_o_tapGestureRecognizer];
}

-(void) tapGestureRecognizerAct:(UITapGestureRecognizer*)tapGR
{
    NSLog(@"tapGR ------------ %@",tapGR);
    if ([_o_delegate respondsToSelector:@selector(droppableViewDidSelected:)]) {
        [_o_delegate droppableViewDidSelected:self];
    }
    
}



#pragma mark- touch event
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addGestureRecognizer:_o_tapGestureRecognizer];
//    NSLog(@"touchesBegan 1");
    _o_touchBeginDate = [NSDate date];
    _o_oldOriginalPos = self.center;
    _o_isBeginDrag = NO;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(LongPressDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self handleStartStatusWithTouches:touches];
    });
    
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self addTapGestureRecognizer];
    NSArray* tOtherDropViews = nil;
    //处理 是否 有交换 动作
    if ([_o_delegate respondsToSelector:@selector(droppableView:exchangeWithOthers:)]) {
        [_o_delegate droppableView:self exchangeWithOthers:&tOtherDropViews];
        if (tOtherDropViews.count > 0) {
            [self handleExchangeWithOthers:tOtherDropViews];
        }
        
    }
    
    
//    NSLog(@"touchesMoved 2");
    [self handleStartStatusWithTouches:touches];
}


- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesEnded 3");
    [self endDrag];
}

- (void)touchesCancelled:(NSSet *)touches withEvent:(UIEvent *)event
{
//    NSLog(@"touchesCancelled 4");
    [self endDrag];
    
}


#pragma mark- 逻辑
/**
 * 计算 开始状态
 */
-(void) handleStartStatusWithTouches:(NSSet*)touches
{
    //未判断为 开始，则计算
    if (!_o_isBeginDrag) {
        NSTimeInterval interval = [[NSDate date] timeIntervalSinceDate:_o_touchBeginDate];
        if (interval >= LongPressDuration) {
            _o_isBeginDrag = YES;
            [self beginDrag];
            [self dragAtPosition: [touches anyObject]];
        }else{
            _o_isBeginDrag = NO;
        }
    
    //开始了 则执行拖动
    }else{
        [self dragAtPosition: [touches anyObject]];
    }
}



- (void) beginDrag
{
    [self removeGestureRecognizer:_o_tapGestureRecognizer];
    //默认动画
    if (_o_isDefaultAnimation) {
        [self showDropViewBeginDroppingAnimation];
    }
    
    if ([_o_delegate respondsToSelector: @selector(droppableViewBeganDragging:)]) {
        [_o_delegate droppableViewBeganDragging: self];
    };

    
    [self changeSuperViewToRegionView];
}




- (void) dragAtPosition: (UITouch *) touch
{
    [UIView beginAnimations: @"drag" context: nil];
    self.center = [touch locationInView: self.superview];
    [UIView commitAnimations];
    
    CGRect drapForRegionViewRect = [_o_animationRegionView convertRect:self.frame fromView:self.superview];
    
    CGRect targetForRegionViewRect = [_o_animationRegionView convertRect:_o_targetView.frame fromView:_o_targetView.superview];
    
    
    CGRect intersect = CGRectIntersection(drapForRegionViewRect, targetForRegionViewRect);
    
    //落在 区间内
    if (intersect.size.width >= OverlapRegionSize || intersect.size.height >= OverlapRegionSize)
    {
        if (!_o_isEntryTagert)
        {
            _o_isEntryTagert = YES;
            
            if (_o_isDefaultAnimation) {
                [self showDropViewEnterTargetAnimation];
            }
            
            if ([_o_delegate respondsToSelector:@selector(droppableView:enterTarget:)]) {
                [_o_delegate droppableView:self enterTarget:_o_targetView];
            }
        }
    }
    //从区间内 又 离开
    else if (_o_isEntryTagert)
    {
        _o_isEntryTagert = NO;
        
        if (_o_isDefaultAnimation) {
            [self showDropViewLeaveTargetAnimation];
        }
        
        if ([_o_delegate respondsToSelector:@selector(droppableView:leaveTarget:)]) {
            [_o_delegate droppableView:self leaveTarget:_o_targetView];
        }
    }
}


- (void) endDrag
{
    [self addTapGestureRecognizer];
    //默认动画
    if (_o_isDefaultAnimation) {
        [self showDropViewEndedDroppingAnimation];
    }
    
    if (_o_isBeginDrag) {
        _o_touchBeginDate = nil;
        _o_isBeginDrag = NO;
        _o_isEntryTagert = NO;
        
        if (_o_isDefaultAnimation) {
            [self showDropViewLeaveTargetAnimation];
        }
        
        if([_o_delegate respondsToSelector: @selector(droppableViewEndedDragging:)]) {
            [_o_delegate droppableViewEndedDragging:self];
        }
        
        CGRect drapForRegionViewRect = [_o_animationRegionView convertRect:self.frame fromView:self.superview];
        
        CGRect targetForRegionViewRect = [_o_animationRegionView convertRect:_o_targetView.frame fromView:_o_targetView.superview];
        
        CGRect intersect = CGRectIntersection(drapForRegionViewRect, targetForRegionViewRect);
        
        //拖动结束时，判断 是否落在 区间内
        if (intersect.size.width >= OverlapRegionSize || intersect.size.height >= OverlapRegionSize){
            
            //如果 未处理， 则不做其他操作
            if([self handleDroppedView]) {
                return;
            }
        }
        
        [self changeSuperViewToOldSuperView];

    }else{
        _o_touchBeginDate = nil;
        _o_isBeginDrag = NO;
        _o_isEntryTagert = NO;
    }
    
    
}


#pragma mark-
/**
 * 返回YES 表示代理 成功处理了 拖到事件
 */
- (BOOL) handleDroppedView
{
    if ([_o_delegate respondsToSelector:@selector(shouldAnimateDroppableView:isDroppedOnTarget:)]) {
        
        BOOL isSuccess = [_o_delegate shouldAnimateDroppableView:self isDroppedOnTarget:_o_targetView];
        if (isSuccess && self.o_isDefaultAnimation) {
            [self showDropViewDisappearAnimation];
        }
        return isSuccess;
        
    }
    
    return NO;
}


/**
 * 返回YES 表示代理 成功处理了 拖到事件
 */
- (void) handleExchangeWithOthers:(NSArray*)otherDropViews
{
    for (UIView* otherView in otherDropViews) {
        
        if(otherView != self && [otherView isKindOfClass:[ZDroppableView class]]){
            
            CGPoint center = self.center;

            CGPoint convertCenter = [_o_oldSuperView convertPoint:center fromView:self.superview];
            
            if (CGRectContainsPoint(otherView.frame, convertCenter)) {
                
                //交换 赋值 view 的中心坐标
                CGPoint newCenter = otherView.center;
                CGPoint oldCenter = _o_oldOriginalPos;
                _o_oldOriginalPos = newCenter;
                
//                //交换自定义数据
//                id tempUserInfoOther = ((ZDroppableView*)otherView).o_userInfo;
//                id tempUserInfoSelf = _o_userInfo;
//                ((ZDroppableView*)otherView).o_userInfo = tempUserInfoSelf;
//                _o_userInfo = tempUserInfoOther;
                
                //交换Index
                NSUInteger tempIndexOther = ((ZDroppableView*)otherView).o_index;
                NSUInteger tempIndexSelf = _o_index;
                ((ZDroppableView*)otherView).o_index = tempIndexSelf;
                _o_index = tempIndexOther;
                
                
                
                [UIView beginAnimations: @"cxchange" context: nil];
                otherView.center = oldCenter;
                [UIView commitAnimations];
                
                break;
            }
            
            
        }
        
    }

    
}




- (void) changeSuperViewToRegionView
{
    UIView* oldSuperView = self.superview;
    CGPoint oldCenter = self.center;

    [_o_animationRegionView addSubview: self];

    CGPoint newCenter = [_o_animationRegionView convertPoint:oldCenter fromView:oldSuperView];
    self.center = newCenter;

}

- (void) changeSuperViewToOldSuperView
{
    UIView* oldSuperView = self.superview;
    CGPoint oldCenter = self.center;
    
    [_o_oldSuperView addSubview: self];
    
    CGPoint newCenter = [_o_oldSuperView convertPoint:oldCenter fromView:oldSuperView];
    self.center = newCenter;
    
    //动画复位
    [UIView beginAnimations: @"drag" context: nil];
    self.center = _o_oldOriginalPos;
    [UIView commitAnimations];

}

#pragma mark- 默认特效制作
/**
 * droppableView 消失动画
 */
-(void) showDropViewDisappearAnimation
{
    CGRect frame = self.frame;
    frame.size.width *= 0.1;
    frame.size.height *= 0.1;
    
    CGPoint newCenter = [_o_animationRegionView convertPoint:_o_targetView.center fromView:_o_targetView.superview];

    frame.origin.x = newCenter.x - (frame.size.width)/2;
    frame.origin.y = newCenter.y - (frame.size.height)/2;;
    
    
    [UIView beginAnimations: @"drag" context: nil];
    [UIView setAnimationDelegate:self];
    [UIView setAnimationDidStopSelector:@selector(removeFromSuperview)];
    [UIView setAnimationDuration:0.3];
    self.frame = frame;
    [UIView commitAnimations];
}


/**
 * droppableView 拖动开始动画
 */
-(void) showDropViewBeginDroppingAnimation
{
    CABasicAnimation* shake = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
    
    //设置抖动幅度
    shake.fromValue = [NSNumber numberWithFloat:-0.05];
    
    shake.toValue = [NSNumber numberWithFloat:+0.05];
    
    shake.duration = 0.1;
    
    shake.autoreverses = YES; //是否重复
    
    shake.repeatCount = 0;
    
    [self.layer addAnimation:shake forKey:@"imageView"];
    
    self.alpha = 0.8;

}


/**
 * droppableView 拖动结束动画
 */
-(void) showDropViewEndedDroppingAnimation
{
    self.alpha = 1.0;
}


/**
 * droppableView 进入到目标视图区域动画
 */
-(void) showDropViewEnterTargetAnimation
{
    _o_targetView.transform = CGAffineTransformMakeScale(1.5, 1.5);
}

/**
 * droppableView 离开目标视图区域动画
 */
-(void) showDropViewLeaveTargetAnimation
{
    _o_targetView.transform = CGAffineTransformMakeScale(1.0, 1.0);
}

@end
