//
//  ZWXMenuBar.h
//  AAActivityActionDemo
//
//  Created by zhwx on 14-11-27.
//  Copyright (c) 2014年 r-plus. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ZWXMenuBarItem;

typedef void(^ZWXMenuBarItemDismissBlcok)();//隐藏弹出的view
typedef void(^ZWXMenuBarItemClickBlcok)(ZWXMenuBarItem* item , NSInteger selectIndex);//响应按钮点击事件

@interface ZWXMenuBarItem : UIView

@property (nonatomic, strong) UIButton* button;
@property (nonatomic, strong) UILabel* label;

/**
 * 点击消失弹框的 block  （ZWXMenuBar 内部用）
 */
@property (nonatomic, copy) ZWXMenuBarItemDismissBlcok o_dismissBlock;

//自定义参数
@property (nonatomic,strong) id o_userInfo;

/**
 * 初始化 按钮
 */
-(id) initWithTitle:(NSString*)title
              image:(UIImage *)image
      selectedImage:(UIImage *)selectedImage
           userInfo:(id)userInfo
         clickBolck:(ZWXMenuBarItemClickBlcok)block;


@end


//@interface ZWXMenuBar : UIView

// 兼容拍鞋网 请求获取分享数据
@interface ZWXMenuBar : UIView

@property (nonatomic, copy) NSString * o_menuTitle;
@property (nonatomic,strong) NSMutableArray* o_items;



-(void) clearSubViews;



/**
 * 用 ZWXMenuBarItem 数组 初始化
 */
-(id) init;


- (void)show;
- (void)showInView:(UIView *)view;
- (void)dismiss;

@end
