//
//  CMNavBarNotificationView.h
//  Moped
//
//  Modified by Eduardo Pinho on 1/12/13.
//  Created by Engin Kurutepe on 1/4/13.
//  Copyright (c) 2013 Codeminer42 All rights reserved.
//  Copyright (c) 2013 Moped Inc. All rights reserved.
//

#import <UIKit/UIKit.h>

//通知
extern NSString *kCMNavBarNotificationViewTapReceivedNotification;
//block
typedef void (^CMNotificationSimpleAction)(id);
//代理 3种方式响应点击
@protocol CMNavBarNotificationViewDelegate;
@class OBGradientView;


@interface CMNavBarNotificationView : UIView

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UILabel *detailTextLabel;
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, assign) id<CMNavBarNotificationViewDelegate> delegate;
@property (nonatomic, strong) OBGradientView * contentView;

@property (nonatomic) NSTimeInterval duration;

@property (nonatomic,strong) id o_userInfo;



+ (CMNavBarNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                  image:(UIImage*)image
                            andDuration:(NSTimeInterval)duration
                                     userInfo:(id)userInfo;

+ (CMNavBarNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                            andDuration:(NSTimeInterval)duration
                                     userInfo:(id)userInfo;

+ (CMNavBarNotificationView *) notifyWithText:(NSString*)text
                                    andDetail:(NSString*)detail
                                     userInfo:(id)userInfo;

+ (CMNavBarNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                  image:(UIImage*)image
                               duration:(NSTimeInterval)duration
                                andTouchBlock:(CMNotificationSimpleAction)block
                                     userInfo:(id)userInfo;

+ (CMNavBarNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                               duration:(NSTimeInterval)duration
                                andTouchBlock:(CMNotificationSimpleAction)block
                                     userInfo:(id)userInfo;

+ (CMNavBarNotificationView *) notifyWithText:(NSString*)text
                                 detail:(NSString*)detail
                                andTouchBlock:(CMNotificationSimpleAction)block
                                     userInfo:(id)userInfo;

- (void) setBackgroundColor:(UIColor *)color;

@end

@protocol CMNavBarNotificationViewDelegate <NSObject>

@optional
- (void)didTapOnNotificationView:(CMNavBarNotificationView *)notificationView;

@end
