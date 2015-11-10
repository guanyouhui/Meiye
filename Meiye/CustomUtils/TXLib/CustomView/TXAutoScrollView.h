//
//  TXAutoScrollView.h
//  WeiXiaoDian
//
//  Created by Pro on 8/26/14.
//  Copyright (c) 2014 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TXAutoScrollView : UIScrollView<UITextFieldDelegate,UITextViewDelegate>
@property (weak,nonatomic) id<UITextFieldDelegate> txtDelegate;
@property (weak,nonatomic) id<UITextViewDelegate> txtViewDelegate;
@property (nonatomic, assign) CGFloat maxContentOffsetY;//限制滑动最低值，为0时表示不受限制

-(void)dismissKeyBoard;
@end
