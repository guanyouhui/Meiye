//
//  SYContactsHelper.h
//  SYContactsPicker
//
//  Created by reesun on 15/12/30.
//  Copyright © 2015年 SY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@class TXContacter;

@interface TXContactsHelper : NSObject

//是否可以访问通讯录
+ (BOOL)canAccessContacts;

//读取通讯录,contacts成员限制为SYContacter
+ (void)fetchContacts:(void(^)(NSArray <TXContacter *> *contacts, BOOL success))block;

@end


@interface NSString (TX)

- (BOOL)tx_containsString:(NSString *)string;
- (NSString *)tx_reformatPhoneNumber;
- (BOOL)tx_validateEmail;
- (BOOL)tx_validatePhone;
- (NSString *)tx_trim;

@end



@interface TXContacter : NSObject

@property (nonatomic) NSInteger section;
@property (nonatomic) NSInteger recordID;
@property (nonatomic) BOOL selected;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *phone;
@property (nonatomic, strong) NSString *email;

- (NSString *)getContacterName;

@end
