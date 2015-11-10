//
//  NSString+TXKit.h
//  TXKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2014 Fabrizio Brancati. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in all
//  copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
//  SOFTWARE.

/**
 *  This class add some useful methods to NSString
 */
@interface NSString (TXKit)

#pragma mark - 验证

/**
 *判断字符串是否为空
 */
- (BOOL)isEmpty;
- (BOOL)isNotEmpty;

/**
 *判断特殊字符
 */
- (BOOL)isNormal;

/**
 * IP
 */
-(BOOL) isIPAdress;


/**
 * 邮箱
 */
-(BOOL)isEmail;

/**
 * 手机号码
 */
+(BOOL) isPhoneNumber;

/**
 * 车牌
 */
+(BOOL) isCarNo;

/**
 * 汉字
 */
- (BOOL)isHanzi;

/**
 * 中文名字
 */
- (BOOL)isChineseName;

/**
 * 身份证号
 */
- (BOOL) isIdentityCard;

/**
 * 数字或字母：
 */
- (BOOL)isPureNumberOrLetter;

#pragma mark - 匹配


- (BOOL)hasString:(NSString *)string;

- (BOOL)matchAnyOf:(NSArray *)array;

#pragma mark - 变量强转字符串
/**
 *  整型转字符串
 */
+ (NSString *)valueOfInteger:(NSInteger)value;

/**
 *  浮点型转字符串
 */
+ (NSString *)valueOfFloat:(CGFloat)value;

/**
 *  价格型转小数点后两位字符串
 */
+ (NSString *)valueOfPrice:(double)value;


#pragma mark - URL
- (NSString *)urlByAppendingDict:(NSDictionary *)params;
- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingArray:(NSArray *)params;
- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding;
- (NSString *)urlByAppendingKeyValues:(id)first, ...;

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict;
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromArray:(NSArray *)array;
+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding;;
+ (NSString *)queryStringFromKeyValues:(id)first, ...;



- (NSString *)urlEncode;
- (NSString *)urlDecode;

- (NSString*)escapeHTML;
- (NSString*)unescapeHTML;

#pragma mark - 截取
- (NSString *)substringFromChar:(char)start charEnd:(char)end;
- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string;


#pragma mark - 加密

- (NSString *) md5;
- (NSString*) sha1;


@end
