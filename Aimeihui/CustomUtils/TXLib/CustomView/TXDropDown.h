//
//  NIDropDown.h
//  NIDropDown
//
//  Created by Bijesh N on 12/28/12.
//  Copyright (c) 2012 Nitor Infotech. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DropDownBlock)(NSObject * result);

@interface TXDropDown : UIView <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, assign) BOOL isShow;


-(void)hideDropDown;
-(void)showDropDown;
- (id)initDropDownWithFrame:(CGRect )frame list:(NSArray *)arr dropDownBlock:(DropDownBlock)block;

@end
