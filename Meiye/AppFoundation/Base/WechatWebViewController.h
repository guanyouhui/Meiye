//
//  WechatViewController.h
//  TinyShop
//
//  Created by tingxie on 15/1/22.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import "TXWebBrowser.h"

@interface WechatWebViewController : YundxViewController

@property (strong, nonatomic) TXWebBrowser * o_webBrowser;

@property (nonatomic,strong) NSString *o_url;

@property (nonatomic,strong) NSString *o_htmlString;

@end
