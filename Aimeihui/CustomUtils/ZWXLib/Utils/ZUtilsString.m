//
//  ZUtilsString.m
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#import "ZUtilsString.h"
#import <CommonCrypto/CommonDigest.h>
#import "NSString+URL.h"

@implementation ZUtilsString
/**
 *判断字符串是否为空
 */
+(BOOL) isEmpty:(NSString*)string
{
    
    if (!string) {
        return YES;
    }
    
    if (string.length <= 0) {
        return YES;
    }
    
    return NO;
}


/**
 * 是否为IP
 */
+(BOOL) isIPAdress :(NSString *)ip{
    
    NSArray *array = [ip componentsSeparatedByString:@"."];
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
 *  邮编判断是否正确
 */
+ (BOOL)isValidateZipCode:(NSString *)zipCode
{
//    NSString *emailCheck = @"^[0-9]\\d{5}$";
//    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
//    BOOL isValidate = [emailTest evaluateWithObject:zipCode];
//    return isValidate;
    
    NSString *emailCheck = @"^[0-9]\\d{0，10}$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES%@",emailCheck];
    BOOL isValidate = [emailTest evaluateWithObject:zipCode];
    return isValidate;
    
}

/**
 * 是否为邮箱
 */
+(BOOL)isValidateEmail:(NSString *)email
{
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [emailTest evaluateWithObject:email];
}

/**
 * 是否为手机号码
 */
+(BOOL) isValidateMobile:(NSString *)mobile
{
    
    NSString *phoneRegex = @"^1[3-8]\\d{9}$";
    NSPredicate *phoneTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",phoneRegex];
    return [phoneTest evaluateWithObject:mobile];
}

/**
 * 是否为车牌
 */
+(BOOL) isValidateCarNo:(NSString*)carNo
{
    NSString *carRegex = @"^[A-Za-z]{1}[A-Za-z_0-9]{5}$";
    NSPredicate *carTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",carRegex];
    NSLog(@"carTest is %@",carTest);
    return [carTest evaluateWithObject:carNo];
}


+ (NSString *) md5:(NSString *)str {
    const char *cStr = [str UTF8String];
    unsigned char digest[16];
    CC_MD5( cStr, (unsigned int)strlen(cStr), digest ); // This is the md5 call
    
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return  output;
}

/**
 * sha1
 */
+(NSString*) sha1:(NSString*)str
{
    const char *ptr = [str UTF8String];
    
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


/**
 * Encode Chinese to ISO8859-1 in URL
 */
+ (NSString *) utf8StringWithChinese:(NSString *)chinese
{
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)chinese, CFSTR(""), kCFStringEncodingUTF8));
    
    
    NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingUTF8));
    return newStr;
    
}


/**
 * Encode Chinese to GB2312 in URL
 */
+ (NSString *) gb2312StringWithChinese:(NSString *)chinese
{
    CFStringRef nonAlphaNumValidChars = CFSTR("![        DISCUZ_CODE_1        ]’()*+,-./:;=?@_~");
    NSString *preprocessedString = (NSString *)CFBridgingRelease(CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (CFStringRef)chinese, CFSTR(""), kCFStringEncodingGB_18030_2000));
    NSString *newStr = (NSString *)CFBridgingRelease(CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,(CFStringRef)preprocessedString,NULL,nonAlphaNumValidChars,kCFStringEncodingGB_18030_2000));
    return newStr;
}


/**
 * URL encode
 */
+ (NSString*)urlEncodeWithString:(NSString *)string
{
    
    NSString *newString = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    return newString;
}


/**
 * URL decode
 */
+ (NSString*)urlDecodeWithString:(NSString *)string
{
    //NSString *decodedString = [encodedString stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding ];
    
    NSString *decodedString  = (__bridge_transfer NSString *)CFURLCreateStringByReplacingPercentEscapesUsingEncoding(NULL,
                                                                                                                     (__bridge CFStringRef)string,
                                                                                                                     CFSTR(""),
                                                                                                                     CFStringConvertNSStringEncodingToEncoding(NSUTF8StringEncoding));
    return decodedString;
}

/**
 * 是否是汉字
 */
+(BOOL)isValidateHanzi:(NSString *)string{
    NSUInteger length = [string length];
    
    for (NSUInteger i=0; i<length; ++i)
    {
        //        NSRange range = NSMakeRange(i, 1);
        //        NSString *subString = [string substringWithRange:range];
        //        const char    *cString = [subString UTF8String];
        //        if (cString || strlen(cString) != 3)
        //        {
        //            NSLog(@"不是汉字:%s", cString);
        //            return NO;
        //        }
        //        else{
        //            NSLog(@"汉字:%s", cString);
        //        }
        unichar ch = [string characterAtIndex:i];
        if (0x4e00 >= ch  || ch >= 0x9fff)
        {
            return NO;
        }
        
    }
    return YES;
}


//身份证号
+ (BOOL) isValidateIdentityCard: (NSString *)string
{
    BOOL flag;
    if (string.length <= 0) {
        flag = NO;
        return flag;
    }
    NSString *regex2 = @"^(\\d{14}|\\d{17})(\\d|[xX])$";
    NSPredicate *identityCardPredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",regex2];
    return [identityCardPredicate evaluateWithObject:string];
}

/**
 * 判断是否为数字或字母：
 */
+ (BOOL)isPureNumberOrLetter:(NSString*)string{
    NSString *regex = @"[a-zA-Z0-9]+";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    
    if ([predicate evaluateWithObject:string] == YES) {
        return YES;
    }
    return NO;
}

/**
 * #FFFFFF 或者0xFFFFFF 字符串（html颜色值转 uicolor）
 */
+ (UIColor *) colorWithHexString:(NSString *) hexString
{
    NSString *cString = [[hexString stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]] uppercaseString];
    // String should be 6 or 8 characters
    
    if ([cString length] < 6)
        return [UIColor blackColor];
    // strip 0X if it appears
    if ([cString hasPrefix:@"0X"] || [cString hasPrefix:@"0x"])
        cString = [cString substringFromIndex:2];
    if ([cString hasPrefix:@"#"])
        cString = [cString substringFromIndex:1];
    if ([cString length] != 6)
        return [UIColor blackColor];
    
    // Separate into r, g, b substrings
    
    NSRange range;
    range.location = 0;
    range.length = 2;
    NSString *rString = [cString substringWithRange:range];
    range.location = 2;
    NSString *gString = [cString substringWithRange:range];
    range.location = 4;
    NSString *bString = [cString substringWithRange:range];
    // Scan values
    unsigned int r, g, b;
    
    [[NSScanner scannerWithString:rString] scanHexInt:&r];
    [[NSScanner scannerWithString:gString] scanHexInt:&g];
    [[NSScanner scannerWithString:bString] scanHexInt:&b];
    
    return [UIColor colorWithRed:((float) r / 255.0f)
                           green:((float) g / 255.0f)
                            blue:((float) b / 255.0f)
                           alpha:1.0f];
}


/**
 *  判断 非空字符串
 */
+ (BOOL)isNotEmpty:(NSString *)str
{
    return ![self isEmpty:str];
}

/**
 *  整型转字符串
 */
+ (NSString *)valueOfInt:(NSInteger)value
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
 *  url拼接字典参数
 */
+ (NSString *)buildHttpQueryString:(NSString *)url requestParam:(NSDictionary *)param
{
    for(NSString *key in param.allKeys) {
        NSString *value = [param objectForKey:key];
        url = [url stringByAppendingQueryName:key andValue:value];
    }
    return url;
}

/**
 * NSDictionary to NSString
 */
+(NSString*) jsonStringWithDictionary:(NSDictionary *)dic
{
    if (!dic || ![dic isKindOfClass:[NSDictionary class]]) {
        return nil;
    }
    
    NSString *jsonString = nil;
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    if (! jsonData) {
        NSLog(@"Got an error: %@", error);
    } else {
        jsonString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
    return jsonString;
}

/**
 * NSString to NSDictionary
 */
+(NSDictionary*) dictionaryWithJsonString:(NSString *)jsonString
{
    if (!jsonString || ![jsonString isKindOfClass:[NSString class]]) {
        return nil;
    }
    //    CFStringConvertEncodingToNSStringEncoding (kCFStringEncodingGB_18030_2000)
    
    //转成 utf8
    NSData* tdata = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSError* error = nil;
    NSDictionary* recDic = [NSJSONSerialization JSONObjectWithData:tdata options:NSJSONReadingAllowFragments error:&error];
    
    return recDic;
}




/**
 *  ios7以上传style text maxWidth ios7以下传font text maxWidth linbark
 */
+(CGSize)getTextSizeWithStyle:(NSDictionary *)style withFont:(UIFont *)font wihtText:(NSString *)text withMaxWidth:(CGFloat)maxWidth withLineBrak:(NSLineBreakMode)lineBrak
{
    
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 7.0) {
        CGSize textSize = [text boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                                             options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading
                                          attributes:style
                                             context:nil].size;
        textSize.width = ceil(textSize.width);
        textSize.height = ceil(textSize.height);
        
        return textSize;
    }
    
    CGSize textSize = [text sizeWithFont:font
                       constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)
                           lineBreakMode:lineBrak];
    textSize.width = ceil(textSize.width);
    textSize.height = ceil(textSize.height);
    return textSize;
}


/**
 *  获取label高度 限制最大行数
 */
+ (CGFloat)getLabelHeightWithFont:(CGFloat)textFont withText:(NSString *)text withMaxWidth:(CGFloat)maxWid with:(NSLineBreakMode)lineBrak maxNumberLine:(NSInteger)maxNumberLine
{
    CGFloat height = 0;
    NSDictionary* dic = [NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:textFont],NSFontAttributeName, nil];
    CGSize size = [ZUtilsString getTextSizeWithStyle:dic withFont:[UIFont systemFontOfSize:textFont] wihtText:text withMaxWidth:maxWid withLineBrak:lineBrak];
    height = size.height;
    
    return height;
}




+ (CGFloat )estimateTextHeightByContent:(NSString *)content textFont:(UIFont *)font width:(CGFloat)width
{
    CGSize theSize = CGSizeZero;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(width, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        theSize = rect.size;
    }else{
        theSize = [content sizeWithFont:font constrainedToSize:CGSizeMake(width, MAXFLOAT) lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return ceil(theSize.height);
}

+ (CGFloat )estimateTextWidthByContent:(NSString *)content textFont:(UIFont *)font
{
    
    if ( nil == content || 0 == content.length )
        return 0.0f;
    
    CGSize theSize = CGSizeZero;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [content boundingRectWithSize:CGSizeMake(MAXFLOAT, 0.0f) options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        theSize = rect.size;
    }else{
        theSize = [content sizeWithFont:font];
    }
    
    return ceil(theSize.width);
}

+ (CGSize )estimateTextSizeByContent:(NSString *)content textFont:(UIFont *)font size:(CGSize )size
{
    CGSize theSize = CGSizeZero;
    
    NSDictionary *attribute = [NSDictionary dictionaryWithObjectsAndKeys:font,NSFontAttributeName, nil];
    
    if ([content respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]) {
        CGRect rect = [content boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading attributes:attribute context:nil];
        theSize = rect.size;
    }else{
        theSize = [content sizeWithFont:font constrainedToSize:size lineBreakMode:NSLineBreakByWordWrapping];
    }
    
    return theSize;
}

/**
 *  使某段区域(range) 变成指定 颜色（color）
 */
+ (NSMutableAttributedString *)getAbStringWithText:(NSString *)text range:(NSRange)range color:(UIColor*)color
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    return attributedString;
}


/**
 * 获取属性字符串  修改颜色
 * text: 原字符串
 * ranges:要标识颜色的 区域数组 （NSString 类型） NSStringFromRange()
 * colors:要标识区域对应的颜色数组。 若只设置一个 color 则表示，所有待标识区域都为此 color
 */
+ (NSMutableAttributedString *)getAbStringWithText:(NSString *)text ranges:(NSArray*)ranges coler:(NSArray*)colors
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc]initWithString:text];
    for (NSInteger i=0; i<ranges.count && colors.count>0; i++) {
        
        
        NSString* rangeString = ranges[i];
        
        UIColor* color = nil;
        
        @try {
            color = colors[i];
        }
        @catch (NSException *exception) {
            color = colors.firstObject;
        }
        @finally {
            
        }
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:NSRangeFromString(rangeString)];
    }
    return attributedString;
}

@end
