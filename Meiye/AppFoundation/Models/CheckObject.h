//
//  CheckObject.h
//  TinySeller
//
//  Created by xhs on 15/4/23.
//  Copyright (c) 2015年 zhenwanxiang. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@protocol CheckDelegate <NSObject>
@optional

/**
 *  获取选中对象集合
 */
- (void)getSelectObjs:(NSArray *)objs;

/**
 *  获取选中行
 */
- (void)getSelectIndexs:(NSArray *)indexs;
@end


typedef enum : NSUInteger {
    CheckStyle_simple,     //单选
    CheckStyle_simpleOver, //单选 点击同个时会取消
    CheckStyle_multi       //多选
} CheckStyle;

@interface CheckObject : NSObject

@property (nonatomic,assign) CheckStyle o_style;

@property (nonatomic,assign) id<CheckDelegate>o_delegate;

@property (nonatomic,strong) NSArray *o_willCheck;
@property (nonatomic,assign) BOOL o_isGroup;                //是否分组表格
@property (nonatomic,strong) NSString *o_key;               //对象中唯一值的key
@property (nonatomic,strong) NSArray *o_defalutObjs;        //默认选中对象(必须传入o_key)

/**
 *  初始化
 */
- (id)initWihtObjs:(NSArray *)objs;

/**
 *  选择时调用
 */
- (void)setSelectStateWith:(NSIndexPath *)indexPath;

/**
 *  获取选中对象结果
 */
- (NSArray *)getCheckObjs;

/**
 *  获取选中行
 */
- (NSArray *)getCheckPaths;

/**
 *  取消所有选中 清除所有对象
 */
- (void)cancelOver;

/**
 *  取消某个对象选中状态（传入对象）
 */
- (void)cancelObj:(id)obj;

/**
 *  获取选中状态
 */
- (BOOL)isCheckWith:(NSIndexPath *)indexPath;
@end
