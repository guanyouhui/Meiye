//
//  NJKWebViewProgress.h
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//

#import <Foundation/Foundation.h>
@class TXProgressBarView;
#undef njk_weak
#if __has_feature(objc_arc_weak)
#define njk_weak weak
#else
#define njk_weak unsafe_unretained
#endif

typedef void (^TXWebViewProgressBlock)(float progress);
@protocol TXWebViewProgressDelegate;
@interface TXWebViewProgress : UIView<UIWebViewDelegate>
@property (nonatomic, njk_weak) id<TXWebViewProgressDelegate>progressDelegate;
@property (nonatomic, copy) TXWebViewProgressBlock progressBlock;
@property (nonatomic, readonly) float progress; // 0.0..1.0
@property (nonatomic, strong) UIWebView * webView;
@property (nonatomic, strong) TXProgressBarView * progressView;
-(void)loadRequestUrl:(NSString *)url;
-(void)reloadRequst;
- (void)reset;
@end

@protocol TXWebViewProgressDelegate <NSObject>
- (void)webViewProgress:(TXWebViewProgress *)webViewProgress updateProgress:(float)progress;
@end


@interface TXProgressBarView : UIView

@property (nonatomic, assign) double progress;

@end


