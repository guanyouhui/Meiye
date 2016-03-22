//
//  NJKWebViewProgress.m
//
//  Created by Satoshi Aasano on 4/20/13.
//  Copyright (c) 2013 Satoshi Asano. All rights reserved.
//
#define xBackgroundColor [UIColor clearColor]

#define xForegroundColor RGB(226, 45, 38)


#import "TXWebViewProgress.h"

#import "ISRefreshControl.h"

NSString *completeRPCURL = @"webviewprogressproxy:///complete";

static const float initialProgressValue = 0.1;
static const float beforeInteractiveMaxProgressValue = 0.5;
static const float afterInteractiveMaxProgressValue = 0.9;
static const float progressViewHeight = 2;

@implementation TXWebViewProgress
{
    ISRefreshControl *refreshControl;
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    NSURL *_currentURL;
    BOOL _interactive;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAllSubviews];
    }
    return self;
}
-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initAllSubviews];
    }
    return self;
}
//自适应屏幕的大小，重新设置frame
- (void)layoutSubviews{
    [self initAllSubviewsFrame];
}
-(void)initAllSubviews{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    
    
    
    _webView=[[UIWebView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    _webView.delegate=self;
    [self addSubview:_webView];
    
    _progressView= [[TXProgressBarView alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, progressViewHeight)];
    [self addSubview:_progressView];
    
    
//    [self addObserver:self forKeyPath:@"contentOffset" options:0 context:nil];
    
    refreshControl = [[ISRefreshControl alloc] init];
    [_webView.scrollView addSubview:refreshControl];
    
    [refreshControl addTarget:self
                       action:@selector(refreshing)
             forControlEvents:UIControlEventValueChanged];
    
}

-(void)initAllSubviewsFrame{
    _progressView.frame=CGRectMake(0, 0, self.frame.size.width, progressViewHeight);
    _webView.frame=CGRectMake(0,0, self.frame.size.width, self.frame.size.height);
}
- (void)startProgress
{
    if (_progress < initialProgressValue) {
        [self setProgress:initialProgressValue];
    }
}

- (void)incrementProgress
{
    float progress = self.progress;
    float maxProgress = _interactive ? afterInteractiveMaxProgressValue : beforeInteractiveMaxProgressValue;
    float remainPercent = (float)_loadingCount / (float)_maxLoadCount;
    float increment = (maxProgress - progress) * remainPercent;
    progress += increment;
    progress = fmin(progress, maxProgress);
    [self setProgress:progress];
}

- (void)completeProgress
{
    [self setProgress:1.0];
}

- (void)setProgress:(float)progress
{
    // progress should be incremental only
    if (progress > _progress || progress == 0) {
        _progress = progress;
        if (progress == 0.0) {
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            _progressView.progress = 0.0;
            [UIView animateWithDuration:0.27 animations:^{
                _progressView.alpha = 1.0;
                
            }];
        }
        if (progress == 1.0) {
            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
            [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
                _progressView.alpha = 0.0;
                
                [refreshControl endRefreshing];
            } completion:nil];
        }
        
        _progressView.progress = progress;
        
        if ([_progressDelegate respondsToSelector:@selector(webViewProgress:updateProgress:)]) {
            [_progressDelegate webViewProgress:self updateProgress:progress];
        }
        if (_progressBlock) {
            _progressBlock(progress);
        }
    }
}
-(void)loadRequestUrl:(NSString *)url{
    NSURLRequest *req = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:url]];
    [_webView loadRequest:req];
}
-(void)reloadRequst{
    [_webView reload];
}
- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}
#pragma mark - Pull to refresh data

- (void)refreshing {
    [self reloadRequst];
}
#pragma mark -
#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    BOOL ret = YES;
//    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:shouldStartLoadWithRequest:navigationType:)]) {
//        ret = [_webViewProxyDelegate webView:webView shouldStartLoadWithRequest:request navigationType:navigationType];
//    }
    
    if ([request.URL.absoluteString isEqualToString:completeRPCURL]) {
        [self completeProgress];
        return NO;
    }
    
    BOOL isFragmentJump = NO;
    if (request.URL.fragment) {
        NSString *nonFragmentURL = [request.URL.absoluteString stringByReplacingOccurrencesOfString:[@"#" stringByAppendingString:request.URL.fragment] withString:@""];
        isFragmentJump = [nonFragmentURL isEqualToString:webView.request.URL.absoluteString];
    }

    BOOL isTopLevelNavigation = [request.mainDocumentURL isEqual:request.URL];

    BOOL isHTTP = [request.URL.scheme isEqualToString:@"http"] || [request.URL.scheme isEqualToString:@"https"];
    if (ret && !isFragmentJump && isHTTP && isTopLevelNavigation && navigationType != UIWebViewNavigationTypeBackForward) {
        _currentURL = request.URL;
        [self reset];
    }
    return ret;
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
//    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidStartLoad:)]) {
//        [_webViewProxyDelegate webViewDidStartLoad:webView];
//    }

    _loadingCount++;
    _maxLoadCount = fmax(_maxLoadCount, _loadingCount);

    [self startProgress];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [refreshControl endRefreshing];
//    if ([_webViewProxyDelegate respondsToSelector:@selector(webViewDidFinishLoad:)]) {
//        [_webViewProxyDelegate webViewDidFinishLoad:webView];
//    }
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [refreshControl endRefreshing];
//    if ([_webViewProxyDelegate respondsToSelector:@selector(webView:didFailLoadWithError:)]) {
//        [_webViewProxyDelegate webView:webView didFailLoadWithError:error];
//    }
    
    _loadingCount--;
    [self incrementProgress];

    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];

    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", completeRPCURL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
}

#pragma mark - 
#pragma mark Method Forwarding
// for future UIWebViewDelegate impl

- (NSMethodSignature *)methodSignatureForSelector:(SEL)selector
{
    NSMethodSignature *signature = [super methodSignatureForSelector:selector];
//    if(!signature) {
//        if([_webViewProxyDelegate respondsToSelector:selector]) {
//            return [(NSObject *)_webViewProxyDelegate methodSignatureForSelector:selector];
//        }
//    }
    return signature;
}

- (void)forwardInvocation:(NSInvocation*)invocation
{
//    if ([_webViewProxyDelegate respondsToSelector:[invocation selector]]) {
//        [invocation invokeWithTarget:_webViewProxyDelegate];
//    }
}

@end




@implementation TXProgressBarView {
    UIView * _backgroundView;
    UIView * _foregroundView;
    CGFloat minimumForegroundWidth;
    CGFloat availableWidth;
}
-(id)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
        [self initAllSubviews];
    }
    return self;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initAllSubviews];
    }
    return self;
}
-(void)initAllSubviews{
    self.backgroundColor = [UIColor clearColor];
    
    _backgroundView = [[UIView alloc] initWithFrame:self.bounds];
    _backgroundView.backgroundColor=xBackgroundColor;
    [self addSubview:_backgroundView];
    
    _foregroundView = [[UIView alloc] initWithFrame:self.bounds];
    _foregroundView.backgroundColor = xForegroundColor;
    [self addSubview:_foregroundView];
    
    //        UIEdgeInsets insets = foregroundColor.capInsets;
    //        minimumForegroundWidth = insets.left + insets.right;
    
    availableWidth = self.bounds.size.width - minimumForegroundWidth;
    
    self.progress = 0.0;
}
- (void)setProgress:(double)progress
{
    
    NSLog(@"progress = %lf",progress);
    
    _progress = progress;
    [UIView animateWithDuration:progress animations:^{
        
        CGRect frame = _foregroundView.frame;
        frame.size.width = roundf(minimumForegroundWidth + availableWidth * progress);
        _foregroundView.frame = frame;
    }];
}

@end


