//
//  LoginViewController.m
//  Yundx
//
//  Created by Pro on 15/7/31.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "LoginViewController.h"
#import "RegisterViewController.h"
#import "ForgetViewController.h"

@interface LoginViewController ()
{
    IBOutlet TXTextField *accountTxt;
    IBOutlet TXTextField *passwordTxt;
    
    __weak IBOutlet UIButton *autoLoginButton;
    
    Login_Type loginType;
    NSString * ThirdpartyOpenId;
}
@end

@implementation LoginViewController

- (void)viewDidLoad {
    self.title = @"登录";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self customBackButton];
    
    [[self addRightNavBarItemsWithText:@"注册" andImage:nil] addTarget:self action:@selector(registerAction) forControlEvents:UIControlEventTouchUpInside];
    
    passwordTxt.needSecure = YES;
    
    accountTxt.textTitle = @"账号:";
    passwordTxt.textTitle = @"密码:";
    
    accountTxt.borderWidth = 1.0;
    accountTxt.borderColor = RGBS(204);
    passwordTxt.borderWidth = 1.0;
    passwordTxt.borderColor = RGBS(204);
    
    NSUserDefaults* accountDefaults = [NSUserDefaults standardUserDefaults];
    accountTxt.text = [accountDefaults objectForKey:UD_USER_ACOUNT];
    passwordTxt.text = [accountDefaults objectForKey:UD_USER_PASSWORD];
    
}

- (void)setPhoneText{
    NSUserDefaults* accountDefaults = [NSUserDefaults standardUserDefaults];
    accountTxt.text = [accountDefaults objectForKey:UD_USER_ACOUNT];
}


- (IBAction)loginAction:(id)sender {
    
    if ([self validatePhoneNumber] && [self validatePassword]) {
        [[IQKeyboardManager sharedManager] resignFirstResponder];
        
        loginType = Login_Type_Normal;
        [asyncTask executeTask:0];
    }
}


- (void)registerAction{
    RegisterViewController * controller = [[RegisterViewController alloc] init];
    [self.navigationController pushViewController:controller animated:YES];
}
- (IBAction)forgetPasswordAction:(id)sender {
    
    ForgetViewController * controller = [[ForgetViewController alloc] init];
    if ([ZUtilsString isValidateMobile:accountTxt.text]) {
        controller.o_phoneNumber = accountTxt.text;
    }
    [self.navigationController pushViewController:controller animated:YES];
}

- (IBAction)autoLoginAction:(UIButton *)sender {
    sender.selected = !sender.selected;
}
- (IBAction)qqLogin:(id)sender {
    UMSocialSnsPlatform *snsPlatform = [UMSocialSnsPlatformManager getSocialPlatformWithName:UMShareToQQ];
    
    snsPlatform.loginClickHandler(self,[UMSocialControllerService defaultControllerService],YES,^(UMSocialResponseEntity *response){
        
        //          获取微博用户名、uid、token等
        
        if (response.responseCode == UMSResponseCodeSuccess) {
            
            UMSocialAccountEntity *snsAccount = [[UMSocialAccountManager socialAccountDictionary] valueForKey:UMShareToQQ];
            
            NSLog(@"username is %@, uid is %@, token is %@ url is %@",snsAccount.userName,snsAccount.usid,snsAccount.accessToken,snsAccount.iconURL);
            ThirdpartyOpenId = snsAccount.usid;
            loginType = Login_Type_QQ;
            [asyncTask executeTask:1];
        }});
    
}

- (IBAction)wechatLogin:(id)sender {
}
- (IBAction)sinaLogin:(id)sender {
}

#pragma mark -- 验证
- (BOOL)validatePhoneNumber {
    
    if ([ZUtilsString isEmpty:accountTxt.text]) {
        [JoProgressHUD makeToast:@"先填写手机号"];
        return NO;
    }
    else {
        return YES;
    }
}
- (BOOL)validatePassword {
    
    if ([ZUtilsString isEmpty:passwordTxt.text]) {
        [JoProgressHUD makeToast:@"请输入密码"];
        return NO;
    }
    else {
        return YES;
    }
}



- (void)requesLogin:(NSString *)phone passward:(NSString *)passward{
    accountTxt.text = phone;
    passwordTxt.text = passward;
    loginType = Login_Type_Normal;
    [asyncTask executeTask:1];
}

- (id)executeAsyncTask:(NSInteger)what withParam:(id)param{
    
    return [[[MemberService alloc] init] memberLoginWithLoginType:loginType Account:accountTxt.text password:passwordTxt.text thirdpartyOpenId:ThirdpartyOpenId andAuto:autoLoginButton.selected];
}
- (void)asyncTaskCallback:(NSInteger)what result:(id)result{
    
    [[NSNotificationCenter defaultCenter] postNotificationName:kNotify_For_LOGIN_SUCCESS_Notify object:nil userInfo:@{kNotify_Object_Info_Todo:[NSNumber numberWithInteger:self.todo]}];
    if (what == 0) {
        [self back];
    }
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
