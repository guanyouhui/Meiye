//
//  ForgetViewController.m
//  Yundx
//
//  Created by Pro on 15/7/31.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import "ForgetViewController.h"
#import "TXVerifyCodeButton.h"
#import "TXAutoScrollView.h"

#define USER_ALTER_PASSWORD  0
#define GET_PHONE_CODE_TASK  1

@interface ForgetViewController ()<UITextFieldDelegate>
{
    IBOutlet TXAutoScrollView *o_aotoScrollView;
    IBOutlet TXTextField *o_phoneTxt;
    IBOutlet TXTextField *o_verifyCodeTxt;
    IBOutlet TXTextField *o_passwordTxt;
    IBOutlet TXVerifyCodeButton *o_verifyCodeButton;
    
    IBOutlet UIButton *o_submitButton;
    
}
@end

@implementation ForgetViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    self.title=@"忘记密码";
    [super viewDidLoad];
    [self addRightBarButtonItemsAdd];
    [self initCommonData];
}


#pragma mark -- init
-(void)initCommonData{
    
    [self setCustomBorderView:o_phoneTxt];
    [self setCustomBorderView:o_verifyCodeTxt];
    [self setCustomBorderView:o_passwordTxt];
    o_verifyCodeButton.cornerRadius = 3.0f;
    
    o_aotoScrollView.txtDelegate=self;
    o_aotoScrollView.maxContentOffsetY=CGRectGetMaxY(o_submitButton.frame)+10;
    
    if (_o_phoneNumber) {
        o_phoneTxt.text=_o_phoneNumber;
    }
}


- (void)setCustomBorderView:(UIView *)aView{
    aView.borderColor = RGBS(231);
    aView.borderWidth = 1.0f;
    aView.cornerRadius = 3.0f;
    
    TXTextField *tf = (TXTextField *)aView;
    if (tf.secureTextEntry == YES) {
        tf.needSecure = YES;
    }
}

- (void)addRightBarButtonItemsAdd{
    
//    Member * memberInfo = [GlobalData shared].applicationHelper.loginedMember;
//    if (memberInfo.o_shopType == MemberShopType_B) {
//        return;
//    }
//    UIButton *addButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    addButton.frame = CGRectMake(0, 0, 40, 40);
//    [addButton setTitleColor:SUBJECT_COLOR forState:UIControlStateNormal];
//    [addButton setImage:[UIImage imageNamed:@"icon_question_red.png"] forState:UIControlStateNormal];
//    [addButton addTarget:self action:@selector(addAction:) forControlEvents:UIControlEventTouchUpInside];
//    [self addNavigationRightBarButtonItemWithView:addButton];
}



#pragma mark -- action
//-(void)addAction:(UIButton*)sender{
//    [AlertUtils alert:@"如果您的账号没有绑定手机\n请登录PC端后台进行找回操作\nhttp://shop.weixiaodian.com"];
//}

#pragma mark -- textDelegate
-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@"\n"]){
        return YES;
    }
    if (textField==o_phoneTxt) {
        NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([aString length] > 11) {
            return NO;
        }
    }
    else if (textField==o_passwordTxt) {
        
        NSString * aString = [textField.text stringByReplacingCharactersInRange:range withString:string];
        
        if ([aString length] > 20) {
            return NO;
        }
    }
    return YES;
}


#pragma end mark
- (IBAction)getVerifyCodeAction:(id)sender {
    if ([self validatePhoneNumber]) {
        [o_aotoScrollView dismissKeyBoard];
        //验证完毕后 获取验证码
        [asyncTask executeTask:GET_PHONE_CODE_TASK];
    }
}

- (IBAction)submitAction:(id)sender {
    if ([self validatePhoneNumber] && [self validateNoteCode]) {
        [o_aotoScrollView dismissKeyBoard];
        //校验完  提交服务器
        [asyncTask executeTask:USER_ALTER_PASSWORD];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark -- 验证
- (BOOL)validatePhoneNumber {
    if ([ZUtilsString isEmpty:o_phoneTxt.text]) {
        [JoProgressHUD makeToast:@"先填写手机号"];
        return NO;
    }
    else if (![ZUtilsString isValidateMobile:o_phoneTxt.text]){
        [JoProgressHUD makeToast:@"请输入正确的手机号码"];
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
        [JoProgressHUD makeToast:@"请输入6-20位的正确密码"];
        return NO;
    } else {
        return YES;
    }
}

- (BOOL)validateNoteCode{
    if ([ZUtilsString isEmpty:o_verifyCodeTxt.text]) {
        [JoProgressHUD makeToast:@"请输入验证码"];
        return NO;
    } else {
        return YES;
    }
}

#pragma mark - asyncTask
- (id)executeAsyncTask:(NSInteger)what withParam:(id)param {
    switch (what) {
        case USER_ALTER_PASSWORD:
        {
            NSMutableDictionary * requestParam = [NSMutableDictionary dictionary];
            [requestParam setObjectNotNull:o_phoneTxt.text forKey:@"MobilePhone"];
            [requestParam setObjectNotNull:o_verifyCodeTxt.text forKey:@"VaildateCode"];
            [self.baseService getDetailWithoutCache:URI_RetrievePassword requestParam:requestParam];
        }
            break;
        case GET_PHONE_CODE_TASK:
        {
            [self.baseService getDetailWithoutCache:URI_MobileSend requestParam:@{@"SendType":@(1),@"MobilePhone":o_phoneTxt.text}];
        }
            break;
        default:
            break;
    }
    
    return nil;
}

- (void)asyncTaskCallback:(NSInteger)what result:(id)result {
    switch (what) {
        case USER_ALTER_PASSWORD: {
            [JoProgressHUD makeToast:@"重置成功，密码已发送至您的手机号码"];
//            [[GlobalVC sharedInstance].loginVC setPhoneText];
            [self back];
        }
            break;
        case GET_PHONE_CODE_TASK:
            [o_verifyCodeButton setVerifyStatus:TXVerifyStatusStartCountdown];
            [o_verifyCodeTxt becomeFirstResponder];
            //获取短信验证码成功
            [JoProgressHUD makeToast:@"短信验证码已发送至您的手机号码"];
            break;
            
        default:
            break;
    }
}


@end
