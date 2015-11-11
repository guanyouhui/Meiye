//
//  WechatViewController.m
//  TinyShop
//
//  Created by tingxie on 15/1/22.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

//web的加载数据类型
typedef NS_ENUM(NSInteger, WebViewLoadType) {
    WebViewLoadTypeDefault = 0,
    WebViewLoadTypeURL ,
    WebViewLoadTypeHTML
};

#import "TXWebViewController.h"


#define REQUEST_MESSAGE_DETAIL_TASK 0

@interface TXWebViewController ()
{
//    UIView *o_leftItemView;
//    HSButton *o_leftButton;
    UIButton *o_closeButton;
    
    WebViewLoadType o_loadType;
}
@end

@implementation TXWebViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    [self initWebBrowser];
    
//    [self createCloseBackButton];
}
- (void)setO_url:(NSString *)o_url{
    NSLog(@"Load web url：%@",o_url);
    _o_url = o_url;
    
    o_loadType = WebViewLoadTypeURL;
    
    [_o_webBrowser loadRequestUrl:o_url];
    
}

- (void)setO_htmlString:(NSString *)o_htmlString{
    _o_htmlString = o_htmlString;
    
    o_loadType = WebViewLoadTypeHTML;
    
    [_o_webBrowser loadHTMLSting:o_htmlString];
    
}

#pragma mark -- init

- (void)initWebBrowser{
    
    UIViewAutoresizing autoresize = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleBottomMargin;
    
    _o_webBrowser = [[TXWebBrowser alloc]initWithFrame:self.view.frame];
    _o_webBrowser.autoresizingMask = autoresize;
    if (o_loadType == WebViewLoadTypeURL) {
        [_o_webBrowser loadRequestUrl:_o_url];
    }
    else if(o_loadType == WebViewLoadTypeHTML){
        [_o_webBrowser loadHTMLSting:_o_htmlString];
    }
    [self.view addSubview:_o_webBrowser];
}

- (void)createCloseBackButton
{
//    o_leftItemView = [UIButton buttonWithType:UIButtonTypeCustom];
//    o_leftItemView.frame = CGRectMake(0, 0, 45, 40);
//    
//    o_leftButton = [HSButton buttonWithType:UIButtonTypeCustom];
//    [o_leftButton setImage:[UIImage imageNamed:@"back_btn"] forState:UIControlStateNormal];
////    o_leftButton.titleLabel.font = [UIFont systemFontOfSize:16.0];
//    [o_leftButton setTitleColor:SUBJECT_COLOR forState:UIControlStateNormal];
//    o_leftButton.frame = o_leftItemView.frame;
//    [o_leftButton addTarget:self action:@selector(webViewGoBack) forControlEvents:UIControlEventTouchUpInside];
//    [o_leftButton setTitle:@"返回" forState:UIControlStateNormal];
//    
//    [o_leftItemView addSubview:o_leftButton];
    
//    [self setBackButtonWidth];
    
//    o_closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    [o_closeButton setTitle:@"关闭" forState:UIControlStateNormal];
//    [o_closeButton setTitleColor:SUBJECT_COLOR forState:UIControlStateNormal];
////    o_closeButton.titleLabel.font = [UIFont systemFontOfSize:15.5];
//    [o_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
//    o_closeButton.frame = CGRectMake(40 + 10, 0,35, o_leftItemView.height);
//    o_closeButton.hidden = YES;
//    [o_leftItemView insertSubview:o_closeButton aboveSubview:o_leftButton];
//    
//    o_leftItemView.clipsToBounds = YES;
//    UIBarButtonItem *leftItem = [[UIBarButtonItem alloc]initWithCustomView:o_leftItemView];
//    self.navigationItem.leftBarButtonItem = leftItem;
}

#pragma mark- webview返回、close view
- (void)back
{
    //显示 关闭按钮
//    if (_o_webBrowser.o_isClickWebView) {
//        [self showCloseButton];
//    }
    
    if ([_o_webBrowser canGoBack]) {
        [self showCloseButton];
        NSLog(@"can back ----!!!!!!!!!!!!!!!");
        [_o_webBrowser goBack];
    }else{
        NSLog(@"can't  back **************************");
        [self closeView];
    }
    
}


-(void) showCloseButton
{
    if (!o_closeButton) {
        o_closeButton = [self addLeftNavBarItemsWithText:@"  关闭" andImage:nil];
        [o_closeButton addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
        
        
    }
}

- (void)closeView
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end


