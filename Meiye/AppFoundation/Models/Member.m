//
//  Member.m
//  PaixieMall
//
//  Created by Enways on 12-12-11.
//  Copyright (c) 2012年 拍鞋网. All rights reserved.
//

#import "Member.h"

@implementation Member

+(NSString *) authenStatusString:(AuthenStatus)authenStatus{
    NSString * detail ;
    switch (authenStatus) {
        case AuthenStatus_ToBeCertified:
            detail = @"待认证";
            break;
        case AuthenStatus_Certified:
            
            detail = @"认证成功";
            break;
        case AuthenStatus_Fail:
            detail = @"认证失败";
            break;
        case AuthenStatus_Unauthorized:
            detail = @"未认证";
            break;
        case AuthenStatus_certificating:
            detail = @"认证中";
            break;
        default:
            detail = @"";
            break;
    }

    return detail;
}

+(UIImage *) authenStatusImage:(AuthenStatus)authenStatus{
    NSString * detail ;
    switch (authenStatus) {
        case AuthenStatus_ToBeCertified:
            detail = @"icon_state_unrecognized_circle";
            break;
        case AuthenStatus_Certified:
            
            detail = @"icon_state_success_circle";
            break;
        case AuthenStatus_Fail:
            detail = @"icon_state_failure_circle";
            break;
        case AuthenStatus_Unauthorized:
            detail = @"icon_state_unrecognized_circle";
            break;
        case AuthenStatus_certificating:
            detail = @"icon_state_review_circle";
            break;
        default:
            detail = @"";
            break;
    }
    
    return [UIImage imageNamed:detail];
}
@end