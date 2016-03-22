//
//  TXWebBrowser.h
//  TinyShop
//
//  Created by tingxie on 14-12-10.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <WebKit/WebKit.h>
@class TXProgressView;
@class TXWebBrowser;
@protocol TXWebBrowserDelegate <NSObject>
@optional
- (void)webBrowser:(TXWebBrowser *)webBrowser didStartLoadingURL:(NSURL *)URL;
- (void)webBrowser:(TXWebBrowser *)webBrowser didFinishLoadingURL:(NSURL *)URL;
- (void)webBrowser:(TXWebBrowser *)webBrowser didFailToLoadURL:(NSURL *)URL error:(NSError *)error;
@end

@interface TXWebBrowser : UIView<WKNavigationDelegate, UIWebViewDelegate>

#pragma mark - Public Properties

@property (nonatomic, weak) id <TXWebBrowserDelegate> delegate;

// The main and only UIProgressView
@property (nonatomic, strong) TXProgressView *progressView;

// The web views
// Depending on the version of iOS, one of these will be set

@property (nonatomic, strong) WKWebView * wkWebView;

@property (nonatomic, strong) UIWebView * uiWebView;

@property (nonatomic, assign) BOOL isReload;        //是否刷新

//@property (nonatomic,assign, readonly) BOOL o_isClickWebView;//记录是否点击 webview（点击了 返回操作 显示关闭按钮）

#pragma mark - Public Interface

// Load a NSURL to webView
// Can be called any time after initialization
- (void)loadURL:(NSURL *)URL;

// Loads a URL as NSString to webView
// Can be called any time after initialization
- (void)loadRequestUrl:(NSString *)URLString;


- (void)loadHTMLSting:(NSString *)HTMLSting;

-(void)reloadUrlRequst;

- (BOOL)canGoBack;

- (void)goBack;
    
@end


@interface TXProgressView : UIView
@property (nonatomic) float progress;

@property (nonatomic, strong) UIView *progressBarView;
@property (nonatomic, assign) NSTimeInterval barAnimationDuration; // default 0.27
@property (nonatomic, assign) NSTimeInterval fadeAnimationDuration; // default 0.27
@property (nonatomic, assign) NSTimeInterval fadeOutDelay; // default 0.1

- (void)setProgress:(float)progress animated:(BOOL)animated;

@end

