//
//  SplashViewController.m
//  TinyShop
//
//  Created by zhwx on 14-8-26.
//  Copyright (c) 2014年 zhenwanxiang. All rights reserved.
//

#import "LaunchViewController.h"
#import "Member.h"
#import "MemberService.h"
#import "MSWeakTimer.h"

#define MINUTE_COUNT 5

@interface LaunchViewController ()<UIAlertViewDelegate>
{
    MemberService *memberService;
}
@property (weak, nonatomic) IBOutlet UIImageView *o_bgImageView;

//第一次 创建此控制器(即第一次启动软件)
@property (assign, nonatomic)BOOL o_isFirstLoadView;


@end

@implementation LaunchViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _o_isFirstLoadView = YES;
        
//        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(appBecomeActiveNotify:) name:UIApplicationDidBecomeActiveNotification object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    
    self.o_bgImageView.image = [UIImage imageNamed:IS_GREAT_IPHONE5?@"Default-568h":@"Default"];
    
    
    [UIApplication sharedApplication].statusBarHidden = NO;
    memberService = [[MemberService alloc] init];
  
//    NSURLRequest* request = [[NSURLRequest alloc] initWithURL:[NSURL URLWithString:@"http://www.baidu.com"]];
//    
//    UIWebView* agentWebView = [[UIWebView alloc] init];
//    agentWebView.delegate = self;
//    [agentWebView loadRequest:request];
//    [self.view addSubview:agentWebView];

    
//    [((AppDelegate*)[UIApplication sharedApplication].delegate) showDefaultImageView];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    
    __weak LaunchViewController* __mySelf = self;
    dispatch_async(kBgQueue, ^{
        [__mySelf asynAutoLogin];
    });
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) asynAutoLogin
{
//    //网络检测
//    if (![Global sharedInstance].applicationHelper.isOnlineMode) {
//        dispatch_async(kMainQueue, ^{
//            [JoProgressHUD makeToast:@"当前网络不可用,请检查"];
//        });
//        
//        return;
//    }

    [self checkLogin];
    
    //先进入首页
    __weak LaunchViewController* __mySelf = self;
    dispatch_async(kMainQueue, ^{
        [__mySelf entryToHome];
        return ;
    });
    
}

- (void)entryToHome{
    
    AppDelegate* app = [UIApplication sharedApplication].delegate;
    app.window.rootViewController = [GlobalVC sharedInstance].mainTabVC;
}

-(void) asyncTaskWillExecute:(NSInteger)what
{
    
}

-(void) asyncTaskDidExecute:(NSInteger)what
{
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
//    if (alertView == o_strongUpateAlert) {
//        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:WeiXiaoDian_Appstore_URL]];
//        o_strongUpateAlert = nil;
//    }
    
}

-(void) dealloc
{
    
    
}

@end
