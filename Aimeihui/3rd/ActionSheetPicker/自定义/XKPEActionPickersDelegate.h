//
//  XKPEActionPickersDelegate.h
//  PestatePatient
//
//  Created by YJunxiao on 16/1/6.
//  Copyright © 2016年 xikang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "AbstractActionSheetPicker.h"
#import "ActionSheetCustomPicker.h"
#import "ActionSheetCustomPickerDelegate.h"
@protocol XKPEDocPopoDelegate <NSObject>

- (void)xkactionSheetPickerDidSucceed:(AbstractActionSheetPicker *)actionSheetPicker origin:(id)origin;

@end
@interface XKPEActionPickersDelegate : NSObject<UIPickerViewDataSource,UIPickerViewDelegate,ActionSheetCustomPickerDelegate>

@property (nonatomic, strong) NSString *selectedKey1;
@property (nonatomic, strong) NSString *selectedkey2;
@property (nonatomic, strong) NSString *selectedkey3;
@property (nonatomic ,strong) NSString *title;
@property (nonatomic, strong) NSArray *listArr1;
@property (nonatomic, strong) NSArray *listArr2;
@property (nonatomic, strong) NSArray *listArr3;
@property (nonatomic, assign) id<XKPEDocPopoDelegate> delegates;
-(instancetype)initWithArr1:(NSArray *)arr1 Arr2:(NSArray *)arr2 arr3:(NSArray *)arr3 title:(NSString *)title;

@end
