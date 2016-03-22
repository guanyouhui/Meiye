//
//  XKPEWeightAndHightActionPickerDelegate.h
//  PestatePatient
//
//  Created by YJunxiao on 16/1/7.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetCustomPickerDelegate.h"
@protocol XKPEWeigthAndHightDelegate <NSObject>

- (void)xkwightactionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin;

@end

@interface XKPEWeightAndHightActionPickerDelegate : NSObject<UIPickerViewDataSource,UIPickerViewDelegate,ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) NSString *selectedKey1;
@property (nonatomic, strong) NSString *selectedkey2;
@property (nonatomic, strong) NSString *selectedkey3;
@property (nonatomic, strong) NSString *selectedKey4;
@property (nonatomic, strong) NSString *selectedkey5;
@property (nonatomic, strong) NSString *selectedkey6;
@property (nonatomic, strong) NSArray *listArr1;
@property (nonatomic, strong) NSArray *listArr2;
@property (nonatomic, strong) NSArray *listArr3;
@property (nonatomic, strong) NSArray *listArr4;
@property (nonatomic, strong) NSArray *listArr5;
@property (nonatomic, strong) NSArray *listArr6;
@property (nonatomic, assign) id<XKPEWeigthAndHightDelegate> delegates;
-(instancetype)initWithArr1:(NSArray *)arr1 Arr2:(NSArray *)arr2 arr3:(NSArray *)arr3 Arr4:(NSArray *)arr4 Arr5:(NSArray *)arr5 arr6:(NSArray *)arr6;


@end
