//
//  MIntroduceView.m
//  New-SZY
//
//  Created by apple on 10/10/13.
//  Copyright (c) 2013 szy. All rights reserved.
//

#import "MIntroduceView.h"
@implementation MIntroduceView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        self.backgroundColor = [UIColor clearColor];
        self.o_releaseLock = [[NSLock alloc] init];
        [self setupBackground];
        [self setupContentView];
    }
    return self;
}

/*
 // Only override drawRect: if you perform custom drawing.
 // An empty implementation adversely affects performance during animation.
 - (void)drawRect:(CGRect)rect
 {
 // Drawing code
 }
 */

#pragma mark -
#pragma mark Self Static

+ (BOOL)isIntroduceNeedDisplayAtLaunch {
//    //MFM TEST
//    return YES;
    
    // 第一次的话，值默认为NO
    BOOL hasDisplay = [[NSUserDefaults standardUserDefaults] boolForKey:kIntroduce4PlayVideoHasDisplayAtLaunch];
    if (hasDisplay) {
        return NO;
    }
    return YES;
}


#pragma mark Self Static
#pragma mark -

#pragma mark -
#pragma mark Self Private


- (void)closeView {
    //    NSLog(@"closeView");
    
    //    [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIntroduce4PlayVideoHasDisplayAtLaunch];
    //    [[NSUserDefaults standardUserDefaults] synchronize];
    //
    //    [self removeFromSuperview];
    
    [self _close];
    //[self performSelector:@selector(_close) withObject:nil afterDelay:0.5];
    
}

- (void)_close {
    //    NSLog(@"_close enter");
    dispatch_async(dispatch_get_main_queue(), ^{
        //        NSLog(@"_close before lock");
        [self.o_releaseLock lock];
        //        NSLog(@"_close after lock");
        
        [[NSUserDefaults standardUserDefaults] setBool:YES forKey:kIntroduce4PlayVideoHasDisplayAtLaunch];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        //就是不放 到removeFromSuperview 里会调用 dealloc 再里面会强行放锁 然后relese
        //[self.o_releaseLock unlock];
        
        [UIView  animateWithDuration:1 animations:^{
            self.alpha=0;
        } completion:^(BOOL finished) {
            if (finished) {
                [self removeFromSuperview];
            }
        }];
    });
    
}


#define PADDING  0

- (CGRect)frameForPagingScrollView
{
    CGRect frame = [[UIScreen mainScreen] bounds];
    frame.origin.x -= PADDING;
    frame.size.width += (2 * PADDING);
    return frame;
}

- (CGRect)frameForPageAtIndex:(NSUInteger)index
{
    // We have to use our paging scroll view's bounds, not frame, to calculate the page placement. When the device is in
    // landscape orientation, the frame will still be in portrait because the pagingScrollView is the root view controller's
    // view, so its frame is in window coordinate space, which is never rotated. Its bounds, however, will be in landscape
    // because it has a rotation transform applied.
    CGRect bounds = [self.o_scrollView bounds];
    CGRect pageFrame = bounds;
    pageFrame.size.width -= (2 * PADDING);
    pageFrame.origin.x = (bounds.size.width * index) + PADDING;
    return pageFrame;
}

#pragma mark Self Private
#pragma mark -

#pragma mark -
#pragma mark Self Public
#pragma mark Self Public
#pragma mark -

#pragma mark -
#pragma mark Button Action

- (void)closeClick:(id)sender {
    //    NSLog(@"closeClick BEGIN");
    [self closeView];
    //    NSLog(@"closeClick END");
}

#pragma mark -
#pragma mark Implement UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    
    NSInteger pageIndex = ([scrollView contentOffset].x + [self  width]/2) / [self width];
    
    [self.o_pageControl setCurrentPage:pageIndex];
    
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    //    NSLog(@"scrollViewDidEndDecelerating");
    //    CGPoint offset = [scrollView contentOffset];
    //    CGFloat closeOffset = (kIntroducePageCount-1)*[scrollView width];
    //    if (offset.x > closeOffset) {
    //        NSLog(@"close and exit");
    //        CGPoint moveToPoint = CGPointMake(kIntroducePageCount*[scrollView width], 0);
    //        [scrollView setContentOffset:moveToPoint animated:YES];
    //    }
    
    if ([scrollView contentOffset].x >= kIntroduce4PlayVideoPageCount*[scrollView width]) {
        //        NSLog(@"scrollViewDidEndDecelerating BEGIN");
        [self.o_releaseLock lock];
        [self closeView];
        //scrollView.delegate = nil;
        //        NSLog(@"scrollViewDidEndDecelerating END");
        [self.o_releaseLock unlock];
    }
    
    
    
}

#pragma mark Implement UIScrollViewDelegate
#pragma mark -

#pragma mark -
#pragma mark OverWrite BaseViewController

- (void)setupBackground {
    //[self setBackgroundColor:[UIColor clearColor]];
    
    UIView *backgroundMask = [[UIView alloc] initWithFrame:[self bounds]];
    [backgroundMask setBackgroundColor:[UIColor clearColor]];
    //[backgroundMask setAlpha:0.7];
    [self addSubview:backgroundMask];
    
}


- (void)setupContentView {
    //[[self view] setBackgroundColor:[UIColor blackColor]];
    
    self.o_scrollView = [[UIScrollView alloc] initWithFrame:[self frameForPagingScrollView]];
    [self.o_scrollView setBackgroundColor:[UIColor clearColor]];
    self.o_scrollView.bounces=NO;
    [self.o_scrollView setDelegate:self];
//    // 多出一个view的content，作为滑动到最后一个页面后，消失的操作。
//    [self.o_scrollView setContentSize:CGSizeMake(self.o_scrollView.bounds.size. width * (kIntroduce4PlayVideoPageCount + 1), self.o_scrollView.bounds.size.height)];
    //不做最后一页滑动消失的效果
    [self.o_scrollView setContentSize:CGSizeMake(self.o_scrollView.bounds.size. width * (kIntroduce4PlayVideoPageCount), self.o_scrollView.bounds.size.height)];
    [self.o_scrollView setPagingEnabled:YES];
    //    [_scrollView setBounces:NO];
    [self.o_scrollView setShowsHorizontalScrollIndicator:NO];
    [self addSubview:self.o_scrollView];
    
    NSArray *introduceImages = nil;
    
    if (IPHONE5_OR_LATER) {
        introduceImages = kIntroduce4PlayVideoImagesArray1136;
    } else {
        introduceImages = kIntroduce4PlayVideoImagesArray960;
    }
    
    for (NSInteger index = 0; index < kIntroduce4PlayVideoPageCount; index++) {
        UIImage *image = [UIImage imageNamed:[introduceImages objectAtIndex:index]];
        UIImageView *imageView = [[UIImageView alloc] initWithImage:image];
        [imageView setFrame:[self frameForPageAtIndex:index]];
        [self.o_scrollView addSubview:imageView];
        
    }
    
//    UIButton *cornerButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [cornerButton setBackgroundColor:[UIColor clearColor]];
//    [cornerButton setBackgroundImage:[UIImage imageNamed:@"close@2x.png"] forState:UIControlStateNormal];
//    [cornerButton setSize:CGSizeMake(40, 38)];
//    [cornerButton setRight:[self width]];
//    [cornerButton setTop:0];
//    [cornerButton addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
//    [self addSubview:cornerButton];
    
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setBackgroundColor:[UIColor clearColor]];
    [button setSize:[self.o_scrollView size]];
    [button setRight:kIntroduce4PlayVideoPageCount*[self.o_scrollView width]];
    [button setTop:0];
//    button.t
    [button addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.o_scrollView addSubview:button];
    
    
    UIButton *start = [UIButton buttonWithType:UIButtonTypeCustom];
    [start setBackgroundColor:[UIColor clearColor]];
    //[start setTitle:@"开始" forState:UIControlStateNormal];
    //[start setSize:CGSizeMake(60, 30)];
    [start setSize:CGSizeMake(120, 35)];
    [start setCenterX:(kIntroduce4PlayVideoPageCount - 0.5)*[self.o_scrollView width]];
    //    [start setBottom:[_scrollView height] - 70];
    [start setBottom:[self.o_scrollView height] - 20];
    //[start setBackgroundImage:[UIImage imageNamed:@"guanbi@2x.png"] forState:UIControlStateNormal];
    [start addTarget:self action:@selector(closeClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.o_scrollView addSubview:start];
    
    
    UIPageControl *pageControl = [[UIPageControl alloc] initWithFrame:CGRectZero];
    [pageControl setNumberOfPages:kIntroduce4PlayVideoPageCount];
    [pageControl setSize:[pageControl sizeForNumberOfPages:kIntroduce4PlayVideoPageCount] ];
    [pageControl setHeight:10];
    [pageControl setBottom:[self height] - 5];
    [pageControl setCenterX:[self width]/2];
    [self addSubview:pageControl];
    pageControl.hidden = YES;//资源图上自带小灯了---
    self.o_pageControl = pageControl;
}


//////////////////////////////////////////////////////////////////////////////////////////////////
- (void)dealloc {
    //     NSLog(@"dealloc");
    self.o_scrollView = nil;
    self.o_pageControl = nil;
    if (![self.o_releaseLock tryLock]) {
        //这种做法很龌蹉
        [self.o_releaseLock unlock];
    }
    self.o_releaseLock = nil;
}



@end
