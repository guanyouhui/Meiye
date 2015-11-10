//
//  MIntroduceView.h
//  New-SZY
//
//  Created by apple on 10/10/13.
//  Copyright (c) 2013 szy. All rights reserved.
//

#import <UIKit/UIKit.h>

#define kIntroduce4PlayVideoHasDisplayAtLaunch @"kIntroduce4PlayVideoHasDisplayAtLaunch"
#define kIntroduce4PlayVideoPageCount 3

#define kIntroduce4PlayVideoImagesArray960 [NSArray arrayWithObjects:@"guide3.png", @"guide2.png", @"guide4.png",  nil]

#define kIntroduce4PlayVideoImagesArray1136 [NSArray arrayWithObjects:@"guide3-568.png", @"guide2-568.png", @"guide4-568.png",   nil]

@interface MIntroduceView : UIView <UIScrollViewDelegate> {
    
    
}

+ (BOOL)isIntroduceNeedDisplayAtLaunch;

@property(nonatomic, retain) UIScrollView *o_scrollView;
@property(nonatomic, retain) UIPageControl *o_pageControl;
@property (nonatomic, retain) NSLock *o_releaseLock;

@end
