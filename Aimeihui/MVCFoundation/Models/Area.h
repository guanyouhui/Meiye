//
//  Area.h
//  Mall
//
//  Created by  on 12-8-15.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "Entity.h"

/**
 * 城市区域 （省、市、区 都用此类）
 */
@interface Area : Entity

@property (strong, nonatomic) NSString *o_id;
@property (strong, nonatomic) NSString *o_name;
@property (strong, nonatomic) NSString *o_pid;
@property (assign, nonatomic) NSInteger o_type;

@end
