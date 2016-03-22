//
//  Constant.h
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#ifndef Yundx_Constant_h
#define Yundx_Constant_h

#define MYBUNDLE_NAME @ "mapapi.bundle"
#define MYBUNDLE_PATH [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent: MYBUNDLE_NAME]
#define MYBUNDLE [NSBundle bundleWithPath: MYBUNDLE_PATH]

#import "ServiceUrls.h"
#import "NotifyDefine.h"
#import "UserDefaultsKeies.h"

#import "AppDelegate.h"
#import "Global.h"
#import "GlobalVC.h"
#import "TXControllerCategory.h"
#import "WechatWebViewController.h"

#import "Http-Base-Layer.h" 
#import "SerialConstant.h"

#import "EGOImageView.h"
#import "IQKeyboardManager.h"

#import "AFAppDotNetAPIClient.h"
#import "AFUploadFileManager.h"


#define YUNDX_APP_ID @"888979399"

#define YUNDX_APP_URL @"https://itunes.apple.com/us/app/yun-dong-xi-zong-he-ban/id888979399?l=zh&ls=1&mt=8"

//百度地图
//#define BAIDU_MAP_KEY @"mMIRPRxsNLYFs0c4Q3ATMk5r"

#define BAIDU_MAP_KEY @"GsvgCuFEx4rt7UwTdHaobdew"


//百度推送
#define BAIDU_PUSH_ID_KEY @"6589122"
#define  BAIDU_PUSH_API_KEY @"GsvgCuFEx4rt7UwTdHaobdew"

//百度语音KEY
#define BAIDU_VOICE_AppID @"6589122"
#define BAIDU_VOICE_AppKey @"GsvgCuFEx4rt7UwTdHaobdew"
#define BAIDU_VOICE_SecretKey @"RGX5GclDV0ZRfUCLG9ZVhYlQwuwE3XkW"
//#define BAIDU_VOICE_AppID @"6528738"
//#define BAIDU_VOICE_AppKey @"mMIRPRxsNLYFs0c4Q3ATMk5r"
//#define BAIDU_VOICE_SecretKey @"Te4T0I1UXNyI6XFHjoicnwmvM8M6GbN3"

//友盟
#define UMENG_APPKEY @"55c96dcd67e58e777d000f1c"

//----------Sina-----------
#define WEIBO_KEY               @"sina.540ea724fd98c597e4004613"
#define WEIBO_SECRET            @"90fc23413c51d44741ffeadb98ca1a01"
#define WEIBO_CALLBACK_URL      @"http://sns.whalecloud.com/sina2/callback" //打开新浪微博的SSO开关，设置新浪微博回调地址，这里必须要和你在新浪微博后台设置的回调地址一致。若在新浪后台设置我们的回调地址，“http://sns.whalecloud.com/sina2/callback”，这里可以传nil


//QQ
#define QQ_KEY               @"1104821032"
#define QQ_SECRET            @"95H5XBGsAjub3jCz"
#define QQ_CALLBACK_URL      SERVICE_MP_URL


//----------微信-----------
#define WX_APP_ID       @"wxe509e6c2e9139fcb"
#define WX_APP_SCERET   @"1e19ff6928fad86308e94c3ca465458c"


////----------微信(ceshi)-------------
//#define WX_APP_ID       @"wx1fb4ff3229d58a76"
//#define WX_APP_SCERET   @"7314778dc1cf3c2e16fce3fbbdfc0d15"


//////----------微信(原来APPID  可用版)-------------
//#define WX_APP_ID       @"wx9a4738a5e2cab922"
//#define WX_APP_SCERET   @"06ff5539ea8567e9d1d7724624a680b5"

////----------微信(新版)-------------
//#define WX_APP_ID       @"wx6153117a2d5d591d"
//#define WX_APP_SCERET   @"d4624c36b6795d1d99dcf0547af5443d"

/*****************新版微信 支付，APP 不需要这些参数*********************/
//支付使用的 APP id
#define WX_PAY_APP_ID       @"wxae7e26dfe4b63a40"
#define WX_PAY_APP_SCERET   @"6a13c7c1b05572a6d7d5521642d0f602"

//(长度为 128 的字符串,用于支付过程中生 成 app_signature)
#define WX_APP_KEY   @"aEo8FBCBzNGsRfjndyLnBgoEI5YclX0jBiSAzQnLuBiTXpAOJu8O3ewOeinnTA3O2W0VtUReUURct6VAnBSnm5QcuArWpFHPk5wNM3MTqkP2Ydj0gGynkRDRLdgKAQP5"
/** 商家向财付通申请的商家 id */
#define WX_APP_PARTNER_ID   @"1304498101"
//(微信公众平台商户模块生成的商户密钥)
#define WX_APP_PARTNER_KEY   @"f1Fc6C25aea113f5e22c41039c2eEb39"
//微信支付成功 回调地址(服务器用)
#define WX_APP_CALL_BACK_URL @"http://www.paixie.net/payment/app_weixin_notify_url/"



////----------微信(测试 可用版)-------------
//#define WX_APP_ID       @"wxd930ea5d5a258f4f"
//#define WX_APP_SCERET   @"db426a9829e4b49a0dcac7b4162da6b6"
////(长度为 128 的字符串,用于支付过程中生 成 app_signature)
//#define WX_APP_KEY   @"L8LrMqqeGRxST5reouB0K66CaYAWpqhAVsq7ggKkxHCOastWksvuX1uvmvQclxaHoYd3ElNBrNO2DHnnzgfVG9Qs473M3DTOZug5er46FhuGofumV8H2FVR9qkjSlC5K"
///** 商家向财付通申请的商家 id */
//#define WX_APP_PARTNER_ID   @"1900000109"
////(微信公众平台商户模块生成的商户密钥)
//#define WX_APP_PARTNER_KEY   @"8934e7d15453e97507ef794cf7b0519d"



#define WX_APP_SHARE_RES_KEY        @"platformId="
#define WX_APP_LOGIN_OAUTH_RES_KEY  @"oauth?code="



#define PARTNER @"2088811482215075"
#define SELLER  @"chenzipin@weixiaodian.com"
#define RSA_PRIVATE @"MIICdgIBADANBgkqhkiG9w0BAQEFAASCAmAwggJcAgEAAoGBALbluUb9bfR0DkCuHnlQNuuxf6OpMWl9Uz8AjJ9a8rORhEHCgRFi9s4DCfhjaYbHSBvNmgTZwf3l/lwiYn7YgCjVlzc41+akr9kXmAOmk2JZdVpBAby16MiIKuVOhDqE/LRckpAxX+himql8X202PrQFd7g5XAPmk+MbvqrX6rpnAgMBAAECgYAOqaAO5uZXwK4b1VmwFBQzFQnMjxXdBSUVWe/sHphyeOoHc5ZxVGPA5FF6Tk35diR7xiHg3axFtJiNvlvzG1w6xxaYKx8ro4mgNI6pUy6+vEPWsNk2Stu9vMUiufAx/FpLs7tWRPe9ZI/PqjG02q5yGuqqaxame+KXLyfJX13qoQJBAOQdyDcwTxB1w4Wy2j+JU4kMjMG4Uj+nrfmQI5xKj1mx8cfmvVJH1kYRKcDGHorPtOoUJSYQyH1DcCXddR+8wYkCQQDNQPL3jVdTQ4yk8/rURt7R19lBUEd5Xv3hyK4OdxDIRQIE4eh9i+uzn2oAVNi8nmqHCH3X5SAyZdX7SiMl2FBvAkBtHuoFrHBF2W+cZ0ALoK97Iau7h2ag2J9agF7ohqooJ/0WuQPbdk3D2rX0Z1F46X8LcnOK0AB4G2hsVJGQiwSxAkBh08b5/j/Uy6lJJZAzhOPGmF5QJvcp/gB7kK6E7nLtQRbJRPMOg5X/ssdPCSGUJN0ZJw7zy50g6DCo6Jj//K25AkEAt50WL+P08BWjjKgTe89gnbbHftDD2qRbQ/qyiQEI/q8ZKkqBjOefTP/R+mRuQhajQmasRT+eRE6NgP8I3IfDBw=="



#define TEST_PARTNER @"2088101568358171"
#define TEST_SELLER  @""
#define TEST_MD5_PRIVATE @"uxt01uurwxvstkxpmleeok76ezicp8k4"
#define TEST_RSA_PRIVATE @"MIICdwIBADANBgkqhkiG9w0BAQEFAASCAmEwggJdAgEAAoGBANEliZbjWsu4KpsHAFAMAJoa9x5nfS8t0+xhEAvQ5qheFPv+rEwRne8Mr/D+a3uH3iEz7890kGp6lnPrLKhvSWbKXJmZnPWjYnyVnANL48hQZfvxclUF/Qkxfe2EIttZbuM8nIOIyh5Dfx398kWHVS6TPZrda/VJm9C3cph/b0a3AgMBAAECgYAtQJX4k9C9a2esi2NB7pbiwRre9T1cy+mip421QMnnfBPGQmA9RUKKyo/28NWIsOka/gXROUNWBpgvFJ9hAlM7CjcKzqTV4ph0IQ5XSo0TWvYaJq9aJAelCH+RMa0/If58AIOrJ+qGYESRO4386xAhxXQb89RpTBEIy3M0LxtlIQJBAO7rCW1RXSRtT7Aj5Fb4FmOhlukqL7yLNlhuz2KY+axcyFqzihM39zDB1sF7XYN94b21elLAZntJkufzW67Gk1sCQQDgGZZs3IU5lvVokOJaTZVTynDKAYFMlv6t76yD7DkRtVh/2U9UZOew1fLQvBRDcWP8flpQdXLsLQkV1XfYP8TVAkEAoK5aDLdn2RPbQC8jZoo7JI6MnAvPRxKpXhhISZtwb0eHR9jvx7Uf/h6ffEinv8NtitT+i6DyS4BT2MOGqajLeQJAFHVhjTiolPRaHRy0/Wd9zXN6zoZKppJWV8y8pCKJpzs2BB3zpxG7MSKnEzVIaEvOw/tJBXVjc3o9DRg646wWrQJBAOBeQVevEq1m8dmEgiQDeajUolJeItwTw3eksrH8CypEWOgGsIdafGCWexSBs68+3zs2mR32cPquPmT99HSoVUI="
#define TEST_ALIPAY_PUBLIC @"MIGfMA0GCSqGSIb3DQEBAQUAA4GNADCBiQKBgQDPVyp1OBahVYt/pbVsT1DAzbZNRKREqQDz2S18wM1h+P5Of8XNxTTtqTE12Tgriij7WfIUQtnBq/dJaDx5OJ7MOubKvWEzdhJUHCWCnKmI5e/UFrDj169mRVO3k+HeILRnKUiFuRcAFiyVMKnTtp2/GYcvt+tHNCIcfN1NKFofFwIDAQAB"



#endif
