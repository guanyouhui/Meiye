//
//  RegisterViewController.m
//  Yundx
//
//  Created by Pro on 15/7/31.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "RegisterViewController.h"
//#import "EditCarInfoViewController.h"

@interface RegisterViewController ()
{
    IBOutlet TXTextField *o_phoneTxt;
    IBOutlet TXTextField *o_verifyCodeTxt;
    IBOutlet TXTextField *o_passwordTxt;
    IBOutlet TXTextField *o_inviteTxt;
    IBOutlet TXVerifyCodeButton *o_verifyCodeButton;
    
    IBOutlet UIButton *o_registerButton;
    
}
@end

@implementation RegisterViewController

- (void)viewDidLoad {
    self.title = @"注册";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    o_passwordTxt.needSecure = YES;
    
    o_phoneTxt.textTitle = @"手机号码:";
    o_verifyCodeTxt.textTitle = @"验证码:";
    o_passwordTxt.textTitle = @"密码:";
    o_inviteTxt.textTitle = @"邀请码:";
    o_phoneTxt.leftLabel.width = 80;
    o_verifyCodeTxt.leftLabel.width = 80;
    o_inviteTxt.leftLabel.width = 80;
    o_passwordTxt.leftLabel.width = 80;
    o_phoneTxt.leftLabel.textAlignment = NSTextAlignmentRight;
    o_verifyCodeTxt.leftLabel.textAlignment = NSTextAlignmentRight;
    o_passwordTxt.leftLabel.textAlignment = NSTextAlignmentRight;
    o_inviteTxt.leftLabel.textAlignment = NSTextAlignmentRight;
    
    o_verifyCodeButton.cornerRadius = 2.0f;
    
    [o_registerButton setBackgroundColor:RGBS(204) forState:UIControlStateDisabled];
}

- (IBAction)getVerifyCodeAction:(id)sender {
    if ([self validatePhoneNumber]) {
        [asyncTask executeTask:0];
    }
    
}

- (IBAction)userRegisterAction:(id)sender {
    
    if ([self validatePhoneNumber] && [self validatePassword] && [self validateNoteCode]) {
        
        [asyncTask executeTask:1];
        
    }
}
- (IBAction)checkAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    o_registerButton.enabled = sender.selected;
}

- (IBAction)policatAction:(id)sender {
//    WechatWebViewController * controller = [[WechatWebViewController alloc] init];
//    controller.o_url = SERVICE_PROTOCOL_RUL;
//    controller.title = @"运生活服务协议";
//    [self.navigationController pushViewController:controller animated:YES];
}


#pragma mark -- 验证
- (BOOL)validatePhoneNumber {
    
    if ([ZUtilsString isEmpty:o_phoneTxt.text]) {
        [JoProgressHUD makeToast:@"先填写手机号"];
        return NO;
    }
    else if (![ZUtilsString isValidateMobile:o_phoneTxt.text]){
        [JoProgressHUD makeToast:@"手机号输入错误"];
        return NO;
    }
    else {
        return YES;
    }
}

- (BOOL)validatePassword {
    
    if ([ZUtilsString isEmpty:o_passwordTxt.text]) {
        [JoProgressHUD makeToast:@"请输入密码"];
        return NO;
    } else if (o_passwordTxt.text.length < 6 || o_passwordTxt.text.length > 20) {
        [JoProgressHUD makeToast:@"密码至少6位"];
        return NO;
    } else {
        return YES;
    }
}
- (BOOL)validateNoteCode{
    if ([ZUtilsString isEmpty:o_verifyCodeTxt.text]) {
        [JoProgressHUD makeToast:@"请输入验证码"];
        return NO;
    }else {
        return YES;
    }
}


- (id)executeAsyncTask:(NSInteger)what withParam:(id)param{
    switch (what) {
        case 0:
        {
            [self.baseService getDetailWithoutCache:URI_MobileSend requestParam:@{@"SendType":@(0),@"MobilePhone":o_phoneTxt.text}];
        }
            break;
        case 1:
        {
            NSMutableDictionary * requestParam = [NSMutableDictionary dictionary];
            [requestParam setObjectNotNull:o_phoneTxt.text forKey:@"MobilePhone"];
            [requestParam setObjectNotNull:o_verifyCodeTxt.text forKey:@"VaildateCode"];
            [requestParam setObjectNotNull:o_passwordTxt.text forKey:@"Password"];
            [requestParam setObjectNotNull:o_inviteTxt.text forKey:@"RecommendNo"];
            [self.baseService getDetailWithoutCache:URI_Register requestParam:requestParam];
        }
            break;
            
        default:
            break;
    }
    return nil;
}
- (void)asyncTaskCallback:(NSInteger)what result:(id)result{
    switch (what) {
        case 0:
        {
            [JoProgressHUD makeToast:@"短信验证码已发送至您的手机号码"];
            [o_verifyCodeButton setVerifyStatus:TXVerifyStatusStartCountdown];
            [o_verifyCodeTxt becomeFirstResponder];
            
        }
            break;
        case 1:
        {
            
            NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
            [defaults setObject:o_phoneTxt.text forKey:UD_USER_ACOUNT];
            [defaults synchronize];
            
//            [[GlobalVC sharedInstance].loginVC requesLogin:o_phoneTxt.text passward:o_passwordTxt.text];
//            
//            [self.navigationController pushViewController:[[EditCarInfoViewController alloc] init] animated:YES];
//            [JoProgressHUD makeToast:@"注册成功，请登录"];
//            [self back];
        }
            break;
            
        default:
            break;
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
