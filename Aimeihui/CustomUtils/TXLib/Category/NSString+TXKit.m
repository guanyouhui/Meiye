//
//  NSString+TXKit.m
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

#import "NSString+TXKit.h"
#import <CommonCrypto/CommonDigest.h>

@implementation NSString (TXKit)

#pragma mark - 验证

/**
 *判断字符串是否为空
 */

- (BOOL)isNotEmpty
{
    return [self length] > 0 ? YES : NO;
}

- (BOOL)isNormal
{
    NSString *		regex = @"([^%&',;=!~?$]+)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

/**
 * 是否为IP
 */
-(BOOL) isIPAdress{
    
    NSArray *array = [self componentsSeparatedByString:@"."];
    //    NSLog(@"number of array %ld",[array count]);
    //    for (NSString *sIP in array) {
    //        NSLog(@"%@",sIP);
    //    }
    BOOL flag = YES;
    if ([array count] == 4) {//判断是否为四段
        for (int i = 0; i<4; i++) {
            //判断是否由数字组成
            const char *str = [array[i] cStringUsingEncoding:NSUTF8StringEncoding];
            int j = 0;
            while (str[j] != '\0' ) {
                if (str[j] >= '0' && str[j] <= '9') {
                    j++;
                }else{
                    flag = NO;
                    break;
                }
            }
            //判断ip是否在0-255范围中
            if (flag) {
                NSInteger temp = [array[i] integerValue];
                if (temp < 0 || temp > 255) {
                    flag = NO;
                    break;
                }
            }
        }
    }else{
        flag = NO;
    }
    return flag;
}



/**
 * 是否为邮箱
 */
-(BOOL)isEmail
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:self];
}

/**
 * 是否为手机号码
 */
+(BOOL) isPhoneNumber
{
    
    NSString *phoneRegex = @"^1[3-8]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:self];
}

/**
 * 是否为车牌
 */
+(BOOL) isCarNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:self];
}

/**
 * 是否是汉字
 */
- (BOOL)isHanzi{
    
    NSString *		regex = @"([\u4e00-\u9fa5]+)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}
/**
 * 是否是中文名字
 */
- (BOOL)isChineseName
{
    NSString *		regex = @"(^[\u4e00-\u9fa5]{2,16}$)";
    NSPredicate *	pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    return [pred evaluateWithObject:self];
}

//身份证号
- (BOOL) isIdentityCard
{
    BOOL flag;
    if (self.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:self];
}

/**
 * 判断是否为数字或字母：
 */
- (BOOL)isPureNumberOrLetter{
    NSString *regex = @"[a-zA-Z0-9]+";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:self] == YES) {
        return YES;
    }
    return NO;
}

#pragma mark - 匹配


- (BOOL)hasString:(NSString *)string
{
    if (string.length == 0) {
        return NO;
    }
    return !([self rangeOfString:string].location == NSNotFound);
}

- (BOOL)matchAnyOf:(NSArray *)array
{
    for ( NSString * str in array )
    {
        if ( NSOrderedSame == [self compare:str options:NSCaseInsensitiveSearch] )
        {
            return YES;
        }
    }
    
    return NO;
}

#pragma mark - 变量强转字符串
/**
 *  整型转字符串
 */
+ (NSString *)valueOfInteger:(NSInteger)value
{
    NSString *str = [NSString stringWithFormat:@"%ld",(long)value];
    return str;
}

/**
 *  浮点型转字符串
 */
+ (NSString *)valueOfFloat:(CGFloat)value
{
    NSString *str = [NSString stringWithFormat:@"%f",value];
    
    return str;
}

/**
 *  价格型转小数点后两位字符串
 */
+ (NSString *)valueOfPrice:(double)value
{
    NSString *str = [NSString stringWithFormat:@"%.2f",value];
    
    return str;
}


#pragma mark - URL
+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict
{
    return [self queryStringFromDictionary:dict encoding:YES];
}

+ (NSString *)queryStringFromDictionary:(NSDictionary *)dict encoding:(BOOL)encoding
{
    NSMutableArray * pairs = [NSMutableArray array];
    for ( NSString * key in dict.allKeys )
    {
        NSString * value = [dict objectForKey:key];
        NSString * urlEncoding = encoding ? [value urlEncode] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromArray:(NSArray *)array
{
    return [self queryStringFromArray:array encoding:YES];
}

+ (NSString *)queryStringFromArray:(NSArray *)array encoding:(BOOL)encoding
{
    NSMutableArray *pairs = [NSMutableArray array];
    
    for ( NSUInteger i = 0; i < [array count]; i += 2 )
    {
        NSObject * obj1 = [array objectAtIndex:i];
        NSObject * obj2 = [array objectAtIndex:i + 1];
        
        NSString * key = nil;
        NSString * value = nil;
        
        if ( [obj1 isKindOfClass:[NSNumber class]] )
        {
            key = [(NSNumber *)obj1 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            key = (NSString *)obj1;
        }
        else
        {
            continue;
        }
        
        if ( [obj2 isKindOfClass:[NSNumber class]] )
        {
            value = [(NSNumber *)obj2 stringValue];
        }
        else if ( [obj1 isKindOfClass:[NSString class]] )
        {
            value = (NSString *)obj2;
        }
        else
        {
            continue;
        }
        
        NSString * urlEncoding = encoding ? [value urlEncode] : value;
        [pairs addObject:[NSString stringWithFormat:@"%@=%@", key, urlEncoding]];
    }
    
    return [pairs componentsJoinedByString:@"&"];
}

+ (NSString *)queryStringFromKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    va_end( args );
    return [NSString queryStringFromDictionary:dict];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params
{
    return [self urlByAppendingDict:params encoding:YES];
}

- (NSString *)urlByAppendingDict:(NSDictionary *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [NSString queryStringFromDictionary:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingArray:(NSArray *)params
{
    return [self urlByAppendingArray:params encoding:YES];
}

- (NSString *)urlByAppendingArray:(NSArray *)params encoding:(BOOL)encoding
{
    NSURL * parsedURL = [NSURL URLWithString:self];
    NSString * queryPrefix = parsedURL.query ? @"&" : @"?";
    NSString * query = [NSString queryStringFromArray:params encoding:encoding];
    return [NSString stringWithFormat:@"%@%@%@", self, queryPrefix, query];
}

- (NSString *)urlByAppendingKeyValues:(id)first, ...
{
    NSMutableDictionary * dict = [NSMutableDictionary dictionary];
    
    va_list args;
    va_start( args, first );
    
    for ( ;; )
    {
        NSObject<NSCopying> * key = [dict count] ? va_arg( args, NSObject * ) : first;
        if ( nil == key )
            break;
        
        NSObject * value = va_arg( args, NSObject * );
        if ( nil == value )
            break;
        
        [dict setObject:value forKey:key];
    }
    va_end( args );
    return [self urlByAppendingDict:dict];
}

- (NSString *)urlEncode
{
    NSMutableString *output = [NSMutableString string];
    const unsigned char *source = (const unsigned char *)[self UTF8String];
    int sourceLen = (int)strlen((const char *)source);
    for(int i = 0; i < sourceLen; ++i)
    {
        const unsigned char thisChar = source[i];
        
        if(thisChar == ' ')
        {
            [output appendString:@"+"];
        }
        else if(thisChar == '.' || thisChar == '-' || thisChar == '_' || thisChar == '~' || (thisChar >= 'a' && thisChar <= 'z') || (thisChar >= 'A' && thisChar <= 'Z') || (thisChar >= '0' && thisChar <= '9'))
        {
            [output appendFormat:@"%c", thisChar];
        }
        else
        {
            [output appendFormat:@"%%%02X", thisChar];
        }
    }
    
//    NSString *newString = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef)string, nil, (CFStringRef)@"!*'&=();:@+$,/?%#[]", kCFStringEncodingUTF8));
    return output;
}

- (NSString *)urlDecode
{
    NSMutableString * string = [NSMutableString stringWithString:self];
    [string replaceOccurrencesOfString:@"+"
                            withString:@" "
                               options:NSLiteralSearch
                                 range:NSMakeRange(0, [string length])];
    return [string stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
}

- (NSString*)escapeHTML
{
    NSMutableString* s = [NSMutableString string];
    
    NSUInteger start = 0;
    NSInteger len = [self length];
    NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"<>&\""];
    
    while (start < len) {
        NSRange r = [self rangeOfCharacterFromSet:chs options:0 range:NSMakeRange(start, len-start)];
        if (r.location == NSNotFound) {
            [s appendString:[self substringFromIndex:start]];
            break;
        }
        
        if (start < r.location) {
            [s appendString:[self substringWithRange:NSMakeRange(start, r.location-start)]];
        }
        
        switch ([self characterAtIndex:r.location]) {
            case '<':
                [s appendString:@"&lt;"];
                break;
            case '>':
                [s appendString:@"&gt;"];
                break;
            case '"':
                [s appendString:@"&quot;"];
                break;
            case '&':
                [s appendString:@"&amp;"];
                break;
        }
        
        start = r.location + 1;
    }
    
    return s;
}

- (NSString*)unescapeHTML
{
    NSMutableString* s = [NSMutableString string];
    NSMutableString* target = [self mutableCopy];
    NSCharacterSet* chs = [NSCharacterSet characterSetWithCharactersInString:@"&"];
    
    while ([target length] > 0) {
        NSRange r = [target rangeOfCharacterFromSet:chs];
        if (r.location == NSNotFound) {
            [s appendString:target];
            break;
        }
        
        if (r.location > 0) {
            [s appendString:[target substringToIndex:r.location]];
            [target deleteCharactersInRange:NSMakeRange(0, r.location)];
        }
        
        if ([target hasPrefix:@"&lt;"]) {
            [s appendString:@"<"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&gt;"]) {
            [s appendString:@">"];
            [target deleteCharactersInRange:NSMakeRange(0, 4)];
        } else if ([target hasPrefix:@"&quot;"]) {
            [s appendString:@"\""];
            [target deleteCharactersInRange:NSMakeRange(0, 6)];
        } else if ([target hasPrefix:@"&amp;"]) {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 5)];
        } else {
            [s appendString:@"&"];
            [target deleteCharactersInRange:NSMakeRange(0, 1)];
        }
    }
    
    return s;
}


#pragma mark - 截取

- (NSString *)substringFromChar:(char)start charEnd:(char)end
{
    int inizio = 0, stop = 0;
    for(int i = 0; i < [self length]; i++)
    {
        if([self characterAtIndex:i] == start)
        {
            inizio = i+1;
            i += 1;
        }
        if([self characterAtIndex:i] == end)
        {
            stop = i;
            break;
        }
    }
    stop -= inizio;
    NSString *string = [[self substringFromIndex:inizio-1] substringToIndex:stop+1];
    
    return string;
}

- (NSString *)substringFromIndex:(NSUInteger)from untilString:(NSString *)string
{
    if ( 0 == self.length )
        return nil;
    
    if ( from >= self.length )
        return nil;
    
    NSRange range = NSMakeRange( from, self.length - from );
    NSRange range2 = [self rangeOfString:string options:NSCaseInsensitiveSearch range:range];
    
    if ( NSNotFound == range2.location )
    {
        return [self substringWithRange:range];
    }
    else
    {
        return [self substringWithRange:NSMakeRange(from, range2.location - from)];
    }
}

#pragma mark - 加密

- (NSString *) md5{
    
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *cStr = [self UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (CC_LONG)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

/**
 * sha1
 */
- (NSString*) sha1
{
    if(self == nil || [self length] == 0)
        return nil;
    
    const char *ptr = [self UTF8String];
    
    int i =0;
    int len = (int)strlen(ptr);
    Byte byteArray[len];
    while (i!=len)
    {
        unsigned eachChar = *(ptr + i);
        unsigned low8Bits = eachChar & 0xFF;
        
        byteArray[i] = low8Bits;
        i++;
    }
    
    unsigned char digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(byteArray, len, digest);
    
    NSMutableString *hex = [NSMutableString string];
    for (int i=0; i<20; i++)
        [hex appendFormat:@"%02x", digest[i]];
    
    NSString *immutableHex = [NSString stringWithString:hex];
    
    return immutableHex;
}

@end
