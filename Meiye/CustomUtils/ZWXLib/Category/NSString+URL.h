//
//  NSString+URL.h
//  UFTMobile
//
//  Created by PENG.Q on 11-9-2.
//  Copyright 2011年 UFTobacco Inc. Ltd. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface NSString (URL)

/**
 * 拼接符号
 */
- (NSString*)stringByAppendingQuery:(NSString *)queryString;

/**
 * 传入key value进行拼接
 */
- (NSString *)stringByAppendingQueryName:(NSString *)param andValue:(NSString *)paramValue;

/**
 * 编码
 */
- (NSString*)encodeAsURIComponent;


- (NSString*)escapeHTML;


- (NSString*)unescapeHTML;
@end
