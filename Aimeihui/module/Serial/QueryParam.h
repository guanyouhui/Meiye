//
//  QueryParam.h
//  PaixieMall
//
//  Created by zhwx on 14/12/8.
//  Copyright (c) 2014年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paging.h"
/**
 * 操作类型
 */
typedef enum : NSUInteger {
    AlterOperateType_Add=1,//添加
    AlterOperateType_Edit,//编辑
    AlterOperateType_Delete,//删除
} AlterOperateType;

/**
 * 查询多条数据的基类
 */
@interface QueryParam : NSObject {
    
}

/**
 * 页码信息
 */
@property (strong, nonatomic) Paging *paging;

@end