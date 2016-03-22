//
//  TXWebBrowser.m
//  TinyShop
//
//  Created by tingxie on 14-12-10.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import <SystemConfiguration/CaptiveNetwork.h>
#import <UIKit/UIKit.h>
//#import <sys/types.h>
#import <sys/sysctl.h>
//#import <mach/host_info.h>
//#import <mach/mach_host.h>
//#import <mach/task_info.h>
//#import <mach/task.h>

#include <sys/socket.h>
#include <sys/sysctl.h>
#include <net/if.h>
#include <net/if_dl.h>


#import "TXWebBrowser.h"
#import "ISRefreshControl.h"
#import "MSWeakTimer.h"
static void *KINContext = &KINContext;


#define COMPLETE_REC_URL @"webviewprogressproxy:///complete"

#define INITIAL_PROGRESS 0.1
#define BEFORE_INTER_MAX_PROGRESS 0.5
#define AFTER_INTER_MAX_PROGRESS 0.9

#define BAR_ANIMATION_DURATION 0.27f
#define FADE_ANIMATION_DURATION 0.27f

#define xForegroundColor RGB(227, 73, 73)
@interface TXWebBrowser (){
    ISRefreshControl *refreshControl;
    UIView * errorView;
    UITapGestureRecognizer * reloadGestureRecognizer;
    
    //uiwebview param
    NSUInteger _loadingCount;
    NSUInteger _maxLoadCount;
    BOOL _interactive;
    float _progress;

    
}

@property (nonatomic, strong) MSWeakTimer *fakeProgressTimer;

//@property (nonatomic, assign) BOOL uiWebViewIsLoading;
@property (nonatomic, copy) NSURL * currentURL;

@property (nonatomic, copy) NSString* o_htmlString;

@end

@implementation TXWebBrowser

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

- (void)dealloc {
    
    if (self.wkWebView) {
        [self.wkWebView setNavigationDelegate:nil];
        [self.wkWebView setUIDelegate:nil];
        [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
    }
    else{
        [self.uiWebView setDelegate:nil];
    }
   
    
}

//- (void)awakeFromNib{
//    [self initAllSubviews];
//}

- (void)layoutSubviews{
    [self initWebViewFrame];
}

- (void)initAllSubviews{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    
    refreshControl = [[ISRefreshControl alloc] init];
    
    [refreshControl addTarget:self
                       action:@selector(reloadUrl)
             forControlEvents:UIControlEventValueChanged];
    

    [self initWebView];
    
    CGFloat progressBarHeight = 2.5f;
    CGRect barFrame = CGRectMake(0, 0, self.bounds.size.width, progressBarHeight);
    _progressView = [[TXProgressView alloc] initWithFrame:barFrame];
    
    [self addSubview:self.progressView];
    
    [self initErrorView];
    
    reloadGestureRecognizer = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(errorToReloadRequstAction:)];
    [self addGestureRecognizer:reloadGestureRecognizer];
}

- (void)initErrorView{
    errorView = [[UIView alloc]initWithFrame:CGRectMake(0, 150, self.width, 60)];
    errorView.hidden = YES;
    [self addSubview:errorView];
    
    UIImageView * errorImageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 35, 38)];
    errorImageView.image = [UIImage imageNamed:@"all_error_icon"];
    errorImageView.centerX = errorView.width / 2;
    [errorView addSubview:errorImageView];
    
    UILabel * errorLabel = [[UILabel alloc]initWithFrame:CGRectMake(20, errorImageView.bottom + 10, 280, 21)];
    errorLabel.font = [UIFont systemFontOfSize:15];
    errorLabel.textColor = RGB(212, 212, 212);
    errorLabel.textAlignment = NSTextAlignmentCenter;
    errorLabel.text = @"加载失败，点击重新加载";
    [errorView addSubview:errorLabel];
}

- (void)reloadUrl
{
    [self refreshing];
    _isReload = YES;
}

- (void)initWebView{
    
    //WKWebView在iphone6以上设备上会有BUG，暂时不使用
//    if([WKWebView class]) {
//        [self initWKWebView];
//    }
//    else{
        [self initUIWebView];
//    }
    
    [self bringSubviewToFront:_progressView];
}

- (void)initWKWebView{
    if (self.wkWebView) {
        [self.wkWebView setNavigationDelegate:nil];
        [self.wkWebView setUIDelegate:nil];
        if (self.wkWebView) {
            [self.wkWebView removeObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress))];
        }
        
        [self.wkWebView removeFromSuperview];
        self.wkWebView = nil;
    }
    self.wkWebView = [[WKWebView alloc] init];
    [self.wkWebView setFrame:self.bounds];
    self.wkWebView.backgroundColor = RGB(240, 240, 240);;
    [self.wkWebView setNavigationDelegate:self];
    [self.wkWebView setMultipleTouchEnabled:YES];
    [self.wkWebView setAutoresizesSubviews:YES];
    [self.wkWebView.scrollView setAlwaysBounceVertical:YES];
    [self.wkWebView addObserver:self forKeyPath:NSStringFromSelector(@selector(estimatedProgress)) options:0 context:KINContext];
    
    [self addSubview:self.wkWebView];
    self.wkWebView.hidden=NO;
    [self.wkWebView.scrollView addSubview:refreshControl];
}

- (void)initUIWebView{
    if (self.uiWebView) {
        [self.uiWebView setDelegate:nil];
        [self.uiWebView removeFromSuperview];
        self.uiWebView = nil;
    }
    self.uiWebView = [[UIWebView alloc] init];
    [self.uiWebView setFrame:self.bounds];
    self.uiWebView.backgroundColor = RGB(240, 240, 240);
    [self.uiWebView setDelegate:self];
    [self.uiWebView setMultipleTouchEnabled:YES];
    [self.uiWebView setAutoresizesSubviews:YES];
//    [self.uiWebView setScalesPageToFit:YES];
    [self.uiWebView.scrollView setAlwaysBounceVertical:YES];
    [self addSubview:self.uiWebView];
    [self.uiWebView.scrollView addSubview:refreshControl];
}

- (void)initWebViewFrame{
    
    if(self.wkWebView) {
        [self.wkWebView setFrame:self.bounds];
        [self.wkWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
    if(self.uiWebView) {
        [self.uiWebView setFrame:self.bounds];
        [self.uiWebView setAutoresizingMask:UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight];
    }
//    [self.progressView setFrame:CGRectMake(0, 0, self.frame.size.width, 3)];
}

#pragma mark - Public Interface

- (void)loadURL:(NSURL *)URL {
    self.currentURL = URL;
    self.o_htmlString = nil;
    if (!URL) {
        [self showError:YES];
        
        [self setProgress:1];
        return;
    }
    
    [self showError:NO];
    
    if(self.wkWebView) {
        [self.wkWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
    
    if(self.uiWebView) {
        [self.uiWebView loadRequest:[NSURLRequest requestWithURL:URL]];
    }
}

- (void)loadRequestUrl:(NSString *)URLString {
    NSURL *URL = [NSURL URLWithString:URLString];
    [self loadURL:URL];
}

- (void)loadHTMLSting:(NSString *)HTMLSting {
    if(self.wkWebView) {
        [self.wkWebView loadHTMLString:HTMLSting baseURL:nil];
    }
    
    if(self.uiWebView) {
        [self.uiWebView loadHTMLString:HTMLSting baseURL:nil];
    }
    self.o_htmlString = HTMLSting;
    self.currentURL = nil;
}


-(void)reloadUrlRequst{
    
    [self showError:NO];
    
    if(self.wkWebView) {
        if (self.wkWebView.URL) {
            
            [self.wkWebView stopLoading];
            [self.wkWebView reload];
            
        }else if (self.currentURL){
            [self loadURL:self.currentURL];
        }
        else{
            
            [self showError:YES];
        }
    }
    
    if(self.uiWebView) {
        if (self.uiWebView.request) {
            
            [self.uiWebView stopLoading];
            [self.uiWebView reload];
            
        }else if (self.currentURL){
            [self loadURL:self.currentURL];
        }
        else{
            [self showError:YES];
        }
    }
}

- (BOOL)canGoBack{
    
    if(self.wkWebView) {
        return self.wkWebView.canGoBack;
    }
    
    if(self.uiWebView) {
        return self.uiWebView.canGoBack;
    }
    
    return NO;
}

- (void)goBack{
    
    if(self.wkWebView) {
        [self.wkWebView goBack];
    }
    
    if(self.uiWebView) {
        [self.uiWebView goBack];
    }
}

#pragma mark - Pull to refresh url

- (void)refreshing {
    if (self.o_htmlString) {
        [self loadHTMLSting:self.o_htmlString];
    }else{
        [self reloadUrlRequst];
    }
    
}

#pragma mark - load error
- (void)showError:(BOOL) isFail{

    
    errorView.hidden = !isFail;
    
    if(self.wkWebView) {
        self.wkWebView.hidden = isFail;
    }
    
    if(self.uiWebView) {
        self.uiWebView.hidden = isFail;
    }
    
}
- (void)errorToReloadRequstAction:(UITapGestureRecognizer *)recognizer{
    errorView.hidden = YES;
    
    [self initWebView];
    
//    [self insertSubview:self.progressView atIndex:self.subviews.count - 1];
    [self sendSubviewToBack:self.progressView];
    
    [self loadURL:self.currentURL];
}

#pragma mark - WKNavigationDelegate

//- (void)webView:(WKWebView *)webView decidePolicyForNavigationAction:(WKNavigationAction *)navigationAction decisionHandler:(void (^)(WKNavigationActionPolicy))decisionHandler{
//    if (navigationAction.navigationType == WKNavigationTypeLinkActivated) {
//        _o_isClickWebView = YES;
//    }
//    decisionHandler (WKNavigationActionPolicyAllow);
//}

- (void)webView:(WKWebView *)webView didStartProvisionalNavigation:(WKNavigation *)navigation {
    [self showError:NO];
    
    NSLog(@"didStartProvisionalNavigation：%@",webView.URL);
    if(webView == self.wkWebView) {
        
        self.currentURL = self.wkWebView.URL;
        //        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
            [self.delegate webBrowser:self didStartLoadingURL:self.wkWebView.URL];
        }
    }
}

- (void)webView:(WKWebView *)webView didFinishNavigation:(WKNavigation *)navigation {
    if(webView == self.wkWebView) {
        [refreshControl endRefreshing];
        //        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
            [self.delegate webBrowser:self didFinishLoadingURL:self.wkWebView.URL];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailProvisionalNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [self showError:YES];
    [refreshControl endRefreshing];
    if(webView == self.wkWebView) {
        //        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
            [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}

- (void)webView:(WKWebView *)webView didFailNavigation:(WKNavigation *)navigation
      withError:(NSError *)error {
    [refreshControl endRefreshing];
    if(webView == self.wkWebView) {
        //        [self updateToolbarState];
        if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
            [self.delegate webBrowser:self didFailToLoadURL:self.wkWebView.URL error:error];
        }
    }
}
#pragma mark - Estimated Progress KVO (WKWebView)

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
    if ([keyPath isEqualToString:NSStringFromSelector(@selector(estimatedProgress))] && object == self.wkWebView) {
        [self.progressView setAlpha:1.0f];
        BOOL animated = (self.wkWebView.estimatedProgress > self.progressView.progress);
        [self.progressView setProgress:self.wkWebView.estimatedProgress animated:animated];
        
        // Once complete, fade out UIProgressView
        if(self.wkWebView.estimatedProgress >= 1.0f) {
            [UIView animateWithDuration:0.5f delay:0.5f options:UIViewAnimationOptionCurveEaseOut animations:^{
                [self.progressView setAlpha:0.0f];
            } completion:^(BOOL finished) {
                [self.progressView setProgress:0.0f animated:NO];
                
            }];
        }
        else if (self.wkWebView.estimatedProgress == 0.0f){
//            [self showError:YES];
            NSLog(@"--------------- = 0");
        }
    }
    else {
        [super observeValueForKeyPath:keyPath ofObject:object change:change context:context];
    }
}

#pragma mark - UIWebView
- (void)reset
{
    _maxLoadCount = _loadingCount = 0;
    _interactive = NO;
    [self setProgress:0.0];
}

- (void)startProgress
{
    if (_progress < INITIAL_PROGRESS) {
        [self setProgress:INITIAL_PROGRESS];
    }
}

- (void)incrementProgress
{
    float progress = _progress;
    float maxProgress = _interactive ? AFTER_INTER_MAX_PROGRESS : BEFORE_INTER_MAX_PROGRESS;
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
        [_progressView setProgress:progress animated:YES];
        
//        
//        
//        
//        if (progress == 0.0) {
//            //[UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//            _progressView.progress = 0.0;
//            [UIView animateWithDuration:0.27 animations:^{
//                _progressView.alpha = 1.0;
//                
//            }];
//        }
//        if (progress == 1.0) {
//            //[UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
//            [UIView animateWithDuration:0.27 delay:progress - _progressView.progress options:0 animations:^{
//                _progressView.alpha = 0.0;
//                
//                [refreshControl endRefreshing];
//            } completion:nil];
//        }
//        
//        [_progressView setProgress:progress animated:YES];
        
        if ([_delegate respondsToSelector:@selector(webBrowser:didStartLoadingURL:)]) {
            [_delegate webBrowser:self didStartLoadingURL:self.currentURL];
        }
    }
}

#pragma mark UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
//    if (navigationType == UIWebViewNavigationTypeLinkClicked) {
//        _o_isClickWebView = YES;
//    }
    BOOL ret = YES;
    self.currentURL = request.URL;
    
    if ([request.URL.absoluteString isEqualToString:COMPLETE_REC_URL]) {
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
    [self showError:NO];
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
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", COMPLETE_REC_URL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }

    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
    
    
    
    if([self.delegate respondsToSelector:@selector(webBrowser:didFinishLoadingURL:)]) {
        [self.delegate webBrowser:self didFinishLoadingURL:self.uiWebView.request.URL];
    }
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    NSLog(@"webViewloadFail:%@",error);
    [refreshControl endRefreshing];
    
    //此时可能已经加载完成，则忽略此error，继续进行加载。
    
    if ([[self networkErrorCodes] containsObject:[NSNumber numberWithInteger:[error code]]]){
        [self showError:YES];
        
        [self.progressView setProgress:1.0f animated:YES];
        float duration = 1 - self.progressView.progress;
        [UIView animateWithDuration:duration delay:0.9f options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.progressView setAlpha:0.0f];
        } completion:^(BOOL finished) {
            [self.progressView setProgress:0.0f animated:NO];
            
        }];

        // Fire Alert View Here
    }else{
        [self showError:NO];
    }
//    if([error code] > kCFURLErrorBackgroundSessionInUseByAnotherProcess || [error code] < kCFURLErrorDataLengthExceedsMaximum)
//    {
//        [self showError:YES];
//        
//        [self.progressView setProgress:1.0f animated:YES];
//        float duration = 1 - self.progressView.progress;
//        [UIView animateWithDuration:duration delay:0.9f options:UIViewAnimationOptionCurveEaseOut animations:^{
//            [self.progressView setAlpha:0.0f];
//        } completion:^(BOOL finished) {
//            [self.progressView setProgress:0.0f animated:NO];
//            
//        }];
//    }else{
//        
//    }
   
    
    _loadingCount--;
    [self incrementProgress];
    
    NSString *readyState = [webView stringByEvaluatingJavaScriptFromString:@"document.readyState"];
    
    BOOL interactive = [readyState isEqualToString:@"interactive"];
    if (interactive) {
        _interactive = YES;
        NSString *waitForCompleteJS = [NSString stringWithFormat:@"window.addEventListener('load',function() { var iframe = document.createElement('iframe'); iframe.style.display = 'none'; iframe.src = '%@'; document.body.appendChild(iframe);  }, false);", COMPLETE_REC_URL];
        [webView stringByEvaluatingJavaScriptFromString:waitForCompleteJS];
    }
    
    BOOL isNotRedirect = _currentURL && [_currentURL isEqual:webView.request.mainDocumentURL];
    BOOL complete = [readyState isEqualToString:@"complete"];
    if (complete && isNotRedirect) {
        [self completeProgress];
    }
    
    if([self.delegate respondsToSelector:@selector(webBrowser:didFailToLoadURL:error:)]) {
        [self.delegate webBrowser:self didFailToLoadURL:self.uiWebView.request.URL error:error];
    }

}

-(NSArray*)networkErrorCodes
{
    static NSArray *codesArray;
    if (![codesArray count]){
        @synchronized(self){
            const int codes[] = {
                //****CFURLConnection & CFURLProtocol Errors*****
                kCFURLErrorUnknown, //-998 //一个未知的错误发生。
                //kCFURLErrorCancelled, //-999 //一个页面没有被完全加载之前收到下一个请求
                //kCFURLErrorBadURL, //-1000 //连接失败由于畸形的URL。
                kCFURLErrorTimedOut, //-1001 //链接超时。
                //kCFURLErrorUnsupportedURL, //-1002 //由于一个不支持的URL连接失败的计划。。
                kCFURLErrorCannotFindHost, //-1003 //连接失败,因为主机无法找到。
                kCFURLErrorCannotConnectToHost, //-1004 //连接失败,因为不能对主机的连接。。
                kCFURLErrorNetworkConnectionLost, //-1005 //连接失败,因为网络连接丢失。
                kCFURLErrorDNSLookupFailed, //-1006 //连接失败,因为DNS查找失败。
                //kCFURLErrorHTTPTooManyRedirects, //-1007 //由于太多的重定向HTTP连接失败。
                //kCFURLErrorResourceUnavailable, //-1008  //连接的资源不可用。
                kCFURLErrorNotConnectedToInternet, //-1009 //连接失败,因为设备没有连接到互联网。
                //kCFURLErrorRedirectToNonExistentLocation, //-1010 //连接重定向到一个不存在的位置。
                //kCFURLErrorBadServerResponse, //-1011 //收到了一个无效的服务器响应的连接。
                //kCFURLErrorUserCancelledAuthentication, //-1012 //连接失败,因为用户取消需要身份验证。
                //kCFURLErrorUserAuthenticationRequired, //-1013 //连接失败,因为身份验证是必须的。
                //kCFURLErrorZeroByteResource, //-1014 //资源检索的连接是零字节。
                //kCFURLErrorCannotDecodeRawData, //-1015 //连接无法与一个已知的内容编码的编码解码数据。
                //kCFURLErrorCannotDecodeContentData, //-1016 //连接不能解码数据编码与未知内容编码。
                //kCFURLErrorCannotParseResponse, //-1017 //无法解析服务器的响应的连接。
                //kCFURLErrorInternationalRoamingOff, //-1018 //连接失败,因为国际漫游是禁用的设备。
                //kCFURLErrorCallIsActive, //-1019 //连接失败,因为电话是活跃的。
                //kCFURLErrorDataNotAllowed, //-1020 //连接失败,因为数据目前不允许在设备上使用。
                //kCFURLErrorRequestBodyStreamExhausted, //-1021 //连接失败,因为它要求的身体流筋疲力尽。
            };
            int size = sizeof(codes)/sizeof(int);
            NSMutableArray *array = [[NSMutableArray alloc] init];
            for (int i=0;i<size;++i){
                [array addObject:[NSNumber numberWithInt:codes[i]]];
            }
            codesArray = [array copy];
        }
    }
    return codesArray;
}

@end



@implementation TXProgressView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled = NO;
        self.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _progressBarView = [[UIView alloc] initWithFrame:self.bounds];
        _progressBarView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
        _progressBarView.width = 0;
        _progressBarView.backgroundColor = SUBJECT_COLOR;
        [self addSubview:_progressBarView];
        
        _barAnimationDuration = 0.27f;
        _fadeAnimationDuration = 0.27f;
        _fadeOutDelay = 0.1f;
    }
    return self;
}

-(void)setProgress:(float)progress
{
    [self setProgress:progress animated:NO];
}

- (void)setProgress:(float)progress animated:(BOOL)animated
{
//    NSLog(@"Test:***************** progress: %f",progress);
    BOOL isGrowing = progress > 0.0;
    [UIView animateWithDuration:(isGrowing && animated) ? _barAnimationDuration : 0.0 delay:0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
        CGRect frame = _progressBarView.frame;
        frame.size.width = progress * self.bounds.size.width;
        _progressBarView.frame = frame;
    } completion:nil];
    
    if (progress >= 1.0) {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:_fadeOutDelay options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 0.0;
        } completion:^(BOOL completed){
            CGRect frame = _progressBarView.frame;
            frame.size.width = 0;
            _progressBarView.frame = frame;
        }];
    }
    else {
        [UIView animateWithDuration:animated ? _fadeAnimationDuration : 0.0 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^{
            _progressBarView.alpha = 1.0;
        } completion:nil];
    }
}

@end
