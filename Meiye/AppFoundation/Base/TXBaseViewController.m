//
//  YundxViewController.m
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "TXBaseViewController.h"
#import "LoginUtils.h"
#import "WXApi.h"

@interface TXBaseViewController ()<MBProgressHUDDelegate> {
    ApplicationHelper *applicationHelper;
    UITapGestureRecognizer *tapGestureRecognizer;
}


//菊花
@property (nonatomic,strong) MBProgressHUD* o_processHud;
@property (nonatomic,copy)NSString* o_processMessage;

@end

@implementation TXBaseViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    applicationHelper = [[Global sharedInstance] applicationHelper];
    _baseService = [[PaiXieBaseService alloc] init];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    //    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Logic

- (void)addNavigationRightBarButtonItemWithView:(UIView *)view {
    UIBarButtonItem *item = [[UIBarButtonItem alloc] initWithCustomView:view];
    item.style = UIBarButtonItemStyleDone;
    
    NSMutableArray *rightItems = [NSMutableArray arrayWithArray:self.navigationItem.rightBarButtonItems];
    //ios7 按钮的靠左间距问题
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7.0)
    {
        UIBarButtonItem *negativeSeperator = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSeperator.width = -10;
        
        [rightItems addObject:negativeSeperator];
    }
    
    [rightItems addObject:item];
    
    self.navigationItem.rightBarButtonItems = rightItems;
}

#pragma mark - 异常处理
/**
 * 处理登录超时异常，可以是远程服务返回的超时异常，也可以是本地系统的超时异常
 */
- (void)handleLoginTimeoutException:(NSInteger)what
{
//    Member *member = [LoginUtils checkLoginStatus];
//    [GlobalData shared].applicationHelper.loginedMember = member;
//    
//    BOOL isSuccess = member?YES:NO;
//    if (isSuccess) {
//        //        [JoProgressHUD makeToast:@"重新登录成功"];
//        NSLog(@"-----------重新登录成功--------");
//    }else{
//        [JoProgressHUD makeToast:@"重新登录失败"];
//        NSLog(@"-----------重新登录失败--------");
//    }
    
    //重新登录之后，交给子类处理登录结果
//    [self subViewControllerHandleLoginAagin:what isSuccess:isSuccess];
}

/**
 * 处理网络异常
 */
- (void)handleNetworkingException:(NSInteger)what
{
    [self showNetworkMessage];
}

/**
 * 处理 请求超时
 */
- (void)handleRequestTimeoutException:(NSInteger)what
{
    [self showNetworkErrorView];
}


/**
 * 处理未知异常，通常为业务异常
 */
- (void)handleUnknowException:(NSInteger)what exception:(NSException *)exception
{
    
    if (exception.reason && [exception.reason length]>0) {
        [JoProgressHUD makeToast:exception.reason];
    }else{
        [JoProgressHUD makeToast:exception.name];
    }
}


/**
 * 交给子类 处理【重新登录】的结果
 */
- (void)subViewControllerHandleLoginAagin:(NSInteger)what isSuccess:(BOOL)isSuccess{
    NSLog(@"子类【%@】未实现:【%s】",[self class],__FUNCTION__);
}

/**
 * 重写 超时的自定义 key 值
 */
- (NSString *)getTimeoutExceptionName {
    
    return nil;
}

-(BOOL) showNetworkMessage
{
    if (applicationHelper.isOnlineMode) {
        return YES;
    }
    
    [AlertUtils alert:@"当前网络不可用,请检查"];
    return NO;
}


#pragma mark - Network Error
- (void)showNetworkErrorView {
    //    if (applicationHelper.isOnlineMode) {
    //        return;
    //    }
    
    //    [AlertUtils alert:@"网络不给力哦！"];
    [JoProgressHUD makeToast:@"网络不稳定哦！"];
    //    [networkErrorView setHidden:NO];
}

- (void)hideNetworkErrorView {
    
}

- (void)refreshData {
    //    [self hideNetworkErrorView];
}

- (void)refreshData:(id)sender {
    [self refreshData];
}


#pragma mark - Network 加载的进度条
/**
 * 获取MBProgressHUD用于显示加载提示
 */
- (MBProgressHUD *)createMBProgressHUD
{
    //每次创建新的
    if (self.o_processHud) {
        [self.o_processHud removeFromSuperview];
        self.o_processHud = nil;
    }
    
    if (!self.o_processHud) {
        self.o_processHud = [[MBProgressHUD alloc] initWithView:self.view];
        self.o_processHud.labelText = self.o_processMessage;
        self.o_processHud.mode = MBProgressHUDModeIndeterminate;
        self.o_processHud.delegate = self;
        
        [self.view addSubview: self.o_processHud];
    }
    [self.view bringSubviewToFront:self.o_processHud];
    
    return self.o_processHud;
}


/**
 * 执行异步操作时，显示“处理中”，参数what当前具体的操作。
 *
 */
- (void)asyncTaskWillExecute:(NSInteger)what
{
    [super asyncTaskWillExecute:what];
    [[self createMBProgressHUD] show:YES];
}

/**
 * 执行异步操作结束时，关闭“处理中”，参数what当前具体的操作。
 *
 */
- (void)asyncTaskDidExecute:(NSInteger)what
{
    [super asyncTaskDidExecute:what];
    [[self createMBProgressHUD] hide:YES];
}



#pragma mark - Keyboard events

- (void)showLoginViewController {
    //    NewLoginViewController* controller = [[NewLoginViewController alloc] initWithDefaultNibName:[NewLoginViewController class]];
    //    LoginViewController *controller = [[UIStoryboard storyboardWithName:IPHONE_MAIN_STORYBOARD bundle:nil] instantiateViewControllerWithIdentifier:@"LoginViewController"];
    
    //    [self.navigationController pushViewController:controller animated:YES];
}



- (BOOL)checkLogin {
    Member *member = [LoginUtils checkLoginStatus];
    
    [Global sharedInstance].applicationHelper.loginedMember = member;
    
    return (member);
}

//
//#pragma mark - 友盟分享
//- (void)doShareWithType:(ShareManagerType ) type andTargetId:(NSInteger)targetId
//{
//    if (!o_shareService) {
//        o_shareService = [[ShareService alloc]init];
//    }
//
//    ShareQueryParam * shareQueryParam = [[ShareQueryParam alloc]init];
//    shareQueryParam.o_targetId = targetId;
//    shareQueryParam.o_type = type;
//
//    [asyncTask executeTask:GET_SHARE_INFO_TASK withParam:nil];
//}
/*
 - (void)doShareWithManager:(ShareManager *)shareManager{
 
 if (!shareManager) return;
 
 
 [asyncTask executeTask:GET_SHARE_INFO_TASK withParam:nil];
 
 }
 
 - (void)showShareSheetWithShareManager:(ShareManager *)shareManager{
 
 
 
 NSMutableArray* buttonItems = [NSMutableArray array];
 for (int i=0; i<shareManager.o_snsPlatforms.count; i++) {
 
 NSString * platform = shareManager.o_snsPlatforms[i];
 
 NSString * title = nil;
 UIImage* image = nil;
 if ([platform isEqualToString:UMShareToWechatSession]) {
 title = @"微信好友";
 image = [UIImage imageNamed:@"icon_weixin_friend"];
 }
 else if ([platform isEqualToString:UMShareToWechatTimeline]) {
 title = @"朋友圈";
 image = [UIImage imageNamed:@"icon_pengyouquan"];
 }
 else if ([platform isEqualToString:UMShareToSina]) {
 title = @"新浪微博";
 image = [UIImage imageNamed:@"icon_sina"];
 }
 else if ([platform isEqualToString:UMShareToTencent]) {
 title = @"腾讯微博";
 image = [UIImage imageNamed:@"icon_qqblog"];
 }
 else if ([platform isEqualToString:UMShareToQQ]) {
 title = @"QQ好友";
 image = [UIImage imageNamed:@"icon_qq"];
 }
 else if ([platform isEqualToString:UMShareToQzone]) {
 title = @"QQ空间";
 image = [UIImage imageNamed:@"icon_qqzone"];
 }
 else if ([platform isEqualToString:UMShareToCopy]) {
 title = @"复制链接";
 image = [UIImage imageNamed:@"icon_copy_url"];
 }
 else if ([platform isEqualToString:UMShareToSms]) {
 title = @"短信";
 image = [UIImage imageNamed:@"icon_message"];
 }
 else{
 continue;
 }
 
 {
 __weak PaiXieMallBaseViewController * baseViewController =self;
 
 ZWXMenuBarItem* item = [[ZWXMenuBarItem alloc] initWithTitle:title image:image selectedImage:image userInfo:shareManager clickBolck:^(ZWXMenuBarItem * item , NSInteger selectIndex) {
 
 [baseViewController.asyncTask executeTask:1 withParam:nil];
 
 //                NSLog(@"item:%@,selectIndex:%d",item.o_userInfo,selectIndex);
 
 //                [baseViewController shareSnsWithShareManager:item.o_userInfo selectIndex:selectIndex];
 
 }];
 [buttonItems addObject:item];
 
 }
 }
 
 
 ZWXMenuBar* toolBar = [[ZWXMenuBar alloc] initWithItems:buttonItems];
 [toolBar setO_menuTitle:@"分享才能获得更多客流"];
 [toolBar show];
 
 }
 
 - (void) shareSnsWithShareManager:(ShareManager *)shareManager selectIndex:(NSInteger) index{
 
 NSString * platform = shareManager.o_snsPlatforms [index];
 NSString * shareContent = [NSString string];
 
 if ([platform isEqualToString:UMShareToCopy]) {
 [[UIPasteboard generalPasteboard] setPersistent:YES];
 [[UIPasteboard generalPasteboard] setValue:shareManager.o_url forPasteboardType:[UIPasteboardTypeListString objectAtIndex:0]];
 [JoProgressHUD makeToast:@"复制链接成功"];
 return;
 }
 else if ([platform isEqualToString:UMShareToWechatSession] || [platform isEqualToString:UMShareToWechatTimeline]) {
 shareContent = shareManager.o_content;
 }
 //将分享的信息集成一个字符串
 else {
 if ([ZUtilsString isNotEmpty:shareManager.o_title]) {
 shareContent = [shareContent stringByAppendingString:FORMAT(@" %@",shareManager.o_title)];
 }
 if ([ZUtilsString isNotEmpty:shareManager.o_content]) {
 shareContent = [shareContent stringByAppendingString:FORMAT(@" %@",shareManager.o_content)];
 }
 if ([ZUtilsString isNotEmpty:shareManager.o_url]) {
 shareContent = [shareContent stringByAppendingString:FORMAT(@" %@",shareManager.o_url)];;
 }
 
 }
 //    else if ([platform isEqualToString:UMShareToTencent]) {
 //    }
 //    else if ([platform isEqualToString:UMShareToQQ]) {
 //    }
 //    else if ([platform isEqualToString:UMShareToQzone]) {
 //    }
 //    else if ([platform isEqualToString:UMShareToCopy]) {
 //    }
 //    else if ([platform isEqualToString:UMShareToSms]) {
 //    }else{
 //
 //    }
 
 [UMSocialData defaultData].shareText =shareContent;
 [UMSocialData defaultData].shareImage =shareManager.o_image;
 
 if ([ZUtilsString isNotEmpty:shareManager.o_url]) {
 [[UMSocialData defaultData].urlResource setResourceType:UMSocialUrlResourceTypeDefault url:shareManager.o_url];
 }
 
 WXWebpageObject * ext = [WXWebpageObject object];
 ext.webpageUrl = shareManager.o_url;
 [UMSocialData defaultData].extConfig.title = shareManager.o_title;
 [UMSocialData defaultData].extConfig.wxMediaObject = ext;
 [UMSocialData defaultData].extConfig.wxMessageType = UMSocialWXMessageTypeOther;
 
 
 //设置分享内容，和回调对象
 UMSocialControllerService * socialControllerService = [[UMSocialControllerService alloc]initWithUMSocialData:[UMSocialData defaultData]];
 [socialControllerService setShareText:shareContent shareImage:shareManager.o_image socialUIDelegate:self];
 
 //捕捉页面跳转状态
 [socialControllerService.socialDataService requestSocialDataWithCompletion:^(UMSocialResponseEntity *response) {
 NSLog(@"response = %@",response);
 if (response.responseCode == UMSResponseCodeSuccess) {
 NSLog(@"分享平台跳转成功");
 }else if(response.responseCode == UMSResponseCodeCancel) {
 
 }else{
 
 }
 }];
 
 UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:platform];
 snsPlatform.snsClickHandler(self,socialControllerService,YES);
 
 }
 
 
 //代理返回
 
 
 -(void)didFinishGetUMSocialDataInViewController:(UMSocialResponseEntity *)response {
 
 NSLog(@"response = %@",response);
 if (response.responseCode == UMSResponseCodeSuccess) {
 [JoProgressHUD makeToast:@"发送成功"];
 }
 else if(response.responseCode == UMSResponseCodeCancel) {
 [JoProgressHUD makeToast:@"取消分享"];
 }
 else{
 [JoProgressHUD makeToast:@"发送失败"];
 }
 }
 
 */

#pragma end mark

#pragma mark - UIGestureRecognizerDelegate

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    
    if (  [ZUtilsDevice deviceSystemVersion] < 6.0 && [touch.view isKindOfClass:[UIButton class]]){
        return NO;
    }
    
    return YES;
}

-(void) dealloc
{
    self.o_processHud.delegate = nil;
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
