//
//  XKPEActionSheetPicker.m
//  PestatePatient
//
//  Created by YJunxiao on 16/1/6.
//  Copyright © 2016年 袁俊晓. All rights reserved.
//

#import "AbstractActionSheetPicker+Interface.h"

@implementation AbstractActionSheetPicker (Interface)

- (void)customizeInterface{
    self.titleTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor blackColor], NSForegroundColorAttributeName,
                                [UIFont systemFontOfSize:16], NSFontAttributeName, nil];
    UIButton *doneBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 47, 25)];
    [doneBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [doneBtn setTitle:@"完成" forState:UIControlStateNormal];
    [doneBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithCustomView:doneBtn];
    UIButton *cancelBtn = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 47, 25)];
    [cancelBtn.titleLabel setFont:[UIFont boldSystemFontOfSize:15]];
    [cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancelBtn setTitleColor:[UIColor redColor] forState:UIControlStateNormal];
    UIBarButtonItem *cancelItem = [[UIBarButtonItem alloc] initWithCustomView:cancelBtn];
    [self setDoneButton:doneItem];
    [self setCancelButton:cancelItem];
}

@end
