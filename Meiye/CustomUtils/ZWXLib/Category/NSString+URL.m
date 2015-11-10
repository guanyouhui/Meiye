//
//  NSString+URL.m
//  UFTMobile
//
//  Created by PENG.Q on 11-9-2.
//  Copyright 2011年 UFTobacco Inc. Ltd. All rights reserved.
//

#import "NSString+URL.h"


@implementation NSString (URL)

- (NSString*)stringByAppendingQuery:(NSString *)queryString {
    NSRange rng = [self rangeOfString:@"?"];
    BOOL hasQuestionMark = rng.location != NSNotFound;
    BOOL hasQuery = [queryString hasPrefix:@"&"];
    
    return [NSString stringWithFormat:@"%@%@%@%@"
            , self
            , hasQuestionMark ? @"" : @"?"
            , hasQuery ? @"" : @"&"
            , queryString];
}

- (NSString *)stringByAppendingQueryName:(NSString *)param andValue:(NSString *)paramValue
{
    if (!paramValue)
        paramValue = @"";
    NSString * queryString = [NSString stringWithFormat:@"%@=%@", param, [paramValue encodeAsURIComponent]];
    return [self stringByAppendingQuery:queryString];
}

- (NSString*)encodeAsURIComponent
{
	const char* p = [self UTF8String];
	NSMutableString* result = [NSMutableString string];
	
	for (;*p ;p++) {
		unsigned char c = *p;
		if (('0' <= c && c <= '9') || 
            ('a' <= c && c <= 'z') || 
            ('A' <= c && c <= 'Z') || 
            c == '-' || 
            c == '_') {
			[result appendFormat:@"%c", c];
		} else {
			[result appendFormat:@"%%%02X", c];
		}
	}
	return result;
}

- (NSString*)escapeHTML
{
	NSMutableString* s = [NSMutableString string];
	
	NSInteger start = 0;
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

@end
