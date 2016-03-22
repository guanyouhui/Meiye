//
//  ZUtilsString.h
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZUtilsString : NSObject

/**
 *判断字符串是否为空
 */
+(BOOL) isEmpty:(NSString*)string;
/**
 * 是否为IP
 */
+(BOOL) isIPAdress :(NSString *)ip;

/**
 *  邮编判断是否正确
 */
+ (BOOL)isValidateZipCode:(NSString *)zipCode;

/**
 * 是否为邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email;

/**
 * 是否为手机号码
 */
+(BOOL) isValidateMobile:(NSString *)mobile;

/**
 * 是否为车牌
 */
+(BOOL) isValidateCarNo:(NSString*)carNo;

/**
 * MD5
 */
+ (NSString *) md5:(NSString *)str;


/**
 * sha1
 */
+(NSString*) sha1:(NSString*)str;


/**
 * Encode Chinese to ISO8859-1 in URL
 */
+ (NSString *) utf8StringWithChinese:(NSString *)chinese;

/**
 * Encode Chinese to GB2312 in URL
 */
+ (NSString *) gb2312StringWithChinese:(NSString *)chinese;

/**
 * URL encode
 */
+(NSString*) urlEncodeWithString:(NSString *)string;


/**
 * URL decode
 */
+ (NSString*)urlDecodeWithString:(NSString *)string;


/**
 * 是否是汉字
 */
+(BOOL)isValidateHanzi:(NSString *)string;


/**
 * 判断是否为身份证号码
 */
+ (BOOL) isValidateIdentityCard:(NSString*)string;

/**
 * 判断是否为数字或字母：
 */
+ (BOOL)isPureNumberOrLetter:(NSString*)string;

/**
 * #FFFFFF 或者0xFFFFFF 字符串（html颜色值转 uicolor）
 */
+ (UIColor *) colorWithHexString:(NSString *) hexString;

/**
 *  判断 非空字符串
 */
+ (BOOL)isNotEmpty:(NSString *)str;

/**
 *  整型转字符串
 */
+ (NSString *)valueOfInt:(NSInteger)value;

/**
 *  浮点型转字符串
 */
+ (NSString *)valueOfFloat:(CGFloat)value;

/**
 *  url拼接字典参数
 */
+ (NSString *)buildHttpQueryString:(NSString *)url requestParam:(NSDictionary *)param;



/**
 * NSDictionary to NSString
 */
+(NSString*) jsonStringWithDictionary:(NSDictionary *)dic;

/**
 * NSString to NSDictionary
 */
+(NSDictionary*) dictionaryWithJsonString:(NSString *)jsonString;


/**
 *  计算字体大小
 */
+(CGSize)getTextSizeWithStyle:(NSDictionary *)style withFont:(UIFont *)font wihtText:(NSString *)text withMaxWidth:(CGFloat)maxWidth withLineBrak:(NSLineBreakMode)lineBrak;

/**
 * 简用
 * 获取 文字 的宽带
 */
+ (CGFloat )estimateTextHeightByContent:(NSString *)content textFont:(UIFont *)font width:(CGFloat)width;

+ (CGFloat )estimateTextWidthByContent:(NSString *)content textFont:(UIFont *)font;

+ (CGSize )estimateTextSizeByContent:(NSString *)content textFont:(UIFont *)font size:(CGSize )size;

/**
 *  使某段区域(range) 变成指定 颜色（color）
 */
+ (NSMutableAttributedString *)getAbStringWithText:(NSString *)text range:(NSRange)range color:(UIColor*)color;


/**
 * 获取属性字符串  修改颜色
 * text: 原字符串
 * ranges:要标识颜色的 区域数组 （NSString 类型） NSStringFromRange()
 * colors:要标识区域对应的颜色数组。 若只设置一个 color 则表示，所有待标识区域都为此 color
 */
+ (NSMutableAttributedString *)getAbStringWithText:(NSString *)text ranges:(NSArray*)ranges coler:(NSArray*)colors;

/**
 *  获取label高度 限制最大行数
 */
+ (CGFloat)getLabelHeightWithFont:(CGFloat)textFont withText:(NSString *)text withMaxWidth:(CGFloat)maxWid with:(NSLineBreakMode)lineBrak maxNumberLine:(NSInteger)maxNumberLine;


@end
