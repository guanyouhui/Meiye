//
//  ChangePasswardViewController.m
//  Yundx
//
//  Created by Pro on 15/8/23.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "ChangePasswardViewController.h"
#import "LoginUtils.h"

@interface ChangePasswardViewController ()
{
    IBOutlet TXTextField *password1Txt;
    IBOutlet TXTextField *password2Txt;
    IBOutlet TXTextField *password3Txt;
}
@end

@implementation ChangePasswardViewController

- (void)viewDidLoad {
    
    self.title = @"修改密码";
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    password1Txt.needSecure = YES;
    password2Txt.needSecure = YES;
    password3Txt.needSecure = YES;
    
    switch (self.o_type) {
        case 0:
        {
            password1Txt.textTitle = @"旧密码:";
            password2Txt.textTitle = @"新密码:";
            password3Txt.textTitle = @"确认密码:";
        }
            break;
        case 1:
        {
            self.navTitle = @"设置密码";
            password1Txt.textTitle = @"登录密码:";
            password2Txt.textTitle = @"交易密码:";
            password3Txt.textTitle = @"确认密码:";
            
            password1Txt.placeholder = @"请输入登录密码";
            password2Txt.placeholder = @"请输入交易密码";
            password3Txt.placeholder = @"请输入确认密码";
        }
            break;
        case 2:
        {
            password1Txt.textTitle = @"旧密码:";
            password2Txt.textTitle = @"新密码:";
            password3Txt.textTitle = @"确认密码:";
        }
            break;
            
        default:
            break;
    }
}

- (IBAction)confirmAction:(id)sender {
    if([self validatePassword]){
        [asyncTask executeTask:0];
    }
}


#pragma mark -- 验证

- (BOOL)validatePassword {
    
    NSString * old = [[NSUserDefaults standardUserDefaults] objectForKey:UD_USER_PASSWORD];
    if ([ZUtilsString isEmpty:password1Txt.text]) {
        [JoProgressHUD makeToast:@"请输入旧密码"];
        return NO;
    }
    else if (![password1Txt.text isEqualToString:old]) {
        [JoProgressHUD makeToast:@"旧密码错误"];
        return NO;
    }
    else if ([ZUtilsString isEmpty:password2Txt.text]) {
        [JoProgressHUD makeToast:@"请输入新密码"];
        return NO;
    }
    else if (![password2Txt.text isEqualToString:password3Txt.text]) {
        [JoProgressHUD makeToast:@"确认密码和新密码不一致"];
        return NO;
    }
    else {
        return YES;
    }
}



- (id)executeAsyncTask:(NSInteger)what withParam:(id)param{
    return [self.baseService getDetailWithoutCache:URI_ChangePassword requestParam:@{@"OldPwd":password1Txt.text,@"NewPwd":password2Txt.text,@"NewPwd_Confirm":password3Txt.text}];
}
- (void)asyncTaskCallback:(NSInteger)what result:(id)result{
//    [LoginUtils saveLoginInfoToUserDefaultWithType:Login_Type_Normal Account:[[NSUserDefaults standardUserDefaults] objectForKey:UD_USER_ACOUNT] pswd:password2Txt.text ThirdpartyOpenId:nil];
    [self back];
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
