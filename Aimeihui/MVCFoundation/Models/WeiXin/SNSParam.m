//
//  SNSParam.m
//  PaixieMall
//
//  Created by Bird Fu on 13-3-5.
//  Copyright (c) 2013年 拍鞋网. All rights reserved.
//

#import "SNSParam.h"

@implementation SNSParam

- (void)encodeWithCoder:(NSCoder *)encoder {
    //Encode properties, other class variables, etc
    [encoder encodeObject:self.o_uid forKey:@"o_uid"];
    [encoder encodeObject:self.o_nickName forKey:@"o_nickName"];
    [encoder encodeObject:self.o_email forKey:@"o_email"];
    [encoder encodeObject:self.o_phone forKey:@"o_phone"];
    [encoder encodeInt:self.o_platform forKey:@"o_platform"];
    [encoder encodeObject:self.o_unionId forKey:@"o_unionId"];
    [encoder encodeObject:self.o_headImgUrl forKey:@"o_headImgUrl"];
    [encoder encodeObject:self.o_sex forKey:@"o_sex"];
}

- (id)initWithCoder:(NSCoder *)decoder {
    if((self = [super init])) {
        //decode properties, other class vars
        self.o_uid = [decoder decodeObjectForKey:@"o_uid"];
        self.o_nickName = [decoder decodeObjectForKey:@"o_nickName"];
        self.o_email = [decoder decodeObjectForKey:@"o_email"];
        self.o_phone = [decoder decodeObjectForKey:@"o_phone"];
        self.o_platform = [decoder decodeIntForKey:@"o_platform"];
        self.o_unionId = [decoder decodeObjectForKey:@"o_unionId"];
        self.o_headImgUrl = [decoder decodeObjectForKey:@"o_headImgUrl"];
        self.o_sex = [decoder decodeObjectForKey:@"o_sex"];
    }
    return self;
}
@end



@implementation SNSBindParam


@end