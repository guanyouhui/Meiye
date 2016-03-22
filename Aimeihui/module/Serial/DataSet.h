//
//  DataSet.h
//  EnwaysFoundation
//
//  Created by Jackson Fu on 5/12/11.
//  Copyright (c) 2012 厦门英睿信息科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Paging.h"
#import "Entity.h"

/**
 * 分页数据信息
 */
@interface DataSet : NSObject {

}

/**
 * 对象数组
 */
@property (strong, nonatomic) NSArray *data;
/**
 * 分页对象
 */
@property (strong, nonatomic) Paging *paging;


/**
 * 单个对象（对象中有数组情况下使用）
 */
@property (strong, nonatomic) id currentdata;

@end
