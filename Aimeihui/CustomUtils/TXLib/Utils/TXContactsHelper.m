//
//  SYContactsHelper.m
//  SYContactsPicker
//
//  Created by reesun on 15/12/30.
//  Copyright © 2015年 SY. All rights reserved.
//

#import "TXContactsHelper.h"
#import <AddressBook/AddressBook.h>
#import <Contacts/Contacts.h>

@implementation TXContactsHelper

//获取通讯录权限
+ (BOOL)canAccessContacts {
    __block BOOL tmpGranted = YES;

    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
            tmpGranted = NO;
        }
    }
    else {
        ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            tmpGranted = granted;
            dispatch_semaphore_signal(sema);
        });
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    return tmpGranted;
}

+ (void)fetchContacts:(void(^)(NSArray <TXContacter *> *contacts, BOOL success))block {
    NSMutableArray *contactsTemp = [[NSMutableArray alloc] init];
    
#warning ABAddressBook_DEPRECATED
    if ([[UIDevice currentDevice].systemVersion floatValue] >= 9.0) {
        CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
        if (status == CNAuthorizationStatusDenied || status == CNAuthorizationStatusRestricted) {
            if (block) {
                block(contactsTemp, NO);
            }
        }
        else {
            CNContactStore *store = [[CNContactStore alloc] init];
            [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted, NSError * _Nullable error) {
                if (!granted) {
                    //刷新UI一定要在主线程
                    dispatch_async(dispatch_get_main_queue(), ^{
                        if (block) {
                            block(contactsTemp, NO);
                        }
                    });
                }
                else {
                    NSMutableArray *contacts = [[NSMutableArray alloc] init];
                    NSError *fetchError;
                    
                    //需要读取哪个就设置那个key属性，这里读取标示符、全名、电话号码、邮件
                    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:@[CNContactIdentifierKey, [CNContactFormatter descriptorForRequiredKeysForStyle:CNContactFormatterStyleFullName], CNContactPhoneNumbersKey, CNContactEmailAddressesKey]];
                    
                    BOOL success = [store enumerateContactsWithFetchRequest:request error:&fetchError usingBlock:^(CNContact *contact, BOOL *stop) {
                        [contacts addObject:contact];
                    }];
                    if (!success) {
                        NSLog(@"error = %@", fetchError);
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (block) {
                                block(contactsTemp, NO);
                            }
                        });
                    }
                    else {
                        NSLog(@"contacts = %@", contacts);
                        
                        CNContactFormatter *formatter = [[CNContactFormatter alloc] init];
                        
                        for (CNContact *contact in contacts) {
                            NSString *strName = [formatter stringFromContact:contact];
                            NSLog(@"contact = %@", strName);
                            NSLog(@"identifier = %@", contact.identifier);
                            
                            TXContacter *contacter = [[TXContacter alloc] init];
                            contacter.name = strName;
                            contacter.recordID = contact.identifier.integerValue;//对应ABRecordGetRecordID
                            contacter.selected = NO;
                            
                            //@property (copy, NS_NONATOMIC_IOSONLY) NSArray<CNLabeledValue<CNPhoneNumber*>*> *phoneNumbers;
                            //读取电话号码，遍历直到读到为止
                            for (CNLabeledValue *phoneNumberValue in contact.phoneNumbers) {
                                CNPhoneNumber *phoneNUmber = phoneNumberValue.value;
                                
                                if (phoneNUmber && phoneNUmber.stringValue) {
                                    NSString *strPhone = phoneNUmber.stringValue;
                                    
                                    if ([strPhone tx_trim]) {
                                        strPhone = [strPhone tx_reformatPhoneNumber];
#warning 注意这个tx_validatePhone验证，不需要的话注释掉
                                        BOOL isValid = [strPhone tx_validatePhone];
                                        if (isValid) {
                                            contacter.phone = strPhone;
                                            NSLog(@"phone = %@", contacter.phone);
                                            break;
                                        }
                                    }
                                }
                            }
                            
                            //@property (copy, NS_NONATOMIC_IOSONLY) NSArray<CNLabeledValue<NSString*>*>                    *emailAddresses;
                            //读取邮件，遍历直到读到为止
                            for (CNLabeledValue *emailValue in contact.emailAddresses) {
                                NSString *strEmail = emailValue.value;
                                
                                if (strEmail && [strEmail tx_trim]) {
                                    BOOL isValid = [strEmail tx_validateEmail];
                                    if (isValid) {
                                        contacter.email = strEmail;
                                        NSLog(@"email = %@", contacter.email);
                                        break;
                                    }
                                }
                            }
                            
                            [contactsTemp addObject:contacter];
                        }
                        dispatch_async(dispatch_get_main_queue(), ^{
                            if (block) {
                                block(contactsTemp, YES);
                            }
                        });
                    }
                }
            }];
        }
    }
    else {
        __block BOOL canAccess = NO;

        ABAddressBookRef addressBooks = ABAddressBookCreateWithOptions(NULL, NULL);
        
        //获取通讯录权限
        dispatch_semaphore_t addsemaphore = dispatch_semaphore_create(0);
        ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error) {
            canAccess = granted;
            dispatch_semaphore_signal(addsemaphore);
        });
        dispatch_semaphore_wait(addsemaphore, DISPATCH_TIME_FOREVER);
        
        if (!canAccess) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(contactsTemp, NO);
                }
            });
        }
        else {
            CFArrayRef contacts = ABAddressBookCopyArrayOfAllPeople(addressBooks);//联系人数组
            CFIndex contactsNumber = ABAddressBookGetPersonCount(addressBooks);//总数
            
            for (NSInteger i = 0; i < contactsNumber; i++) {
                TXContacter *contacter = [[TXContacter alloc] init];
                ABRecordRef abContacter = CFArrayGetValueAtIndex(contacts, i);//单个联系人
                CFStringRef abName = ABRecordCopyValue(abContacter, kABPersonFirstNameProperty);//名字
                CFStringRef abLastName = ABRecordCopyValue(abContacter, kABPersonLastNameProperty);//姓
                CFStringRef abFullName = ABRecordCopyCompositeName(abContacter);//全名
                
                NSString *strName = (__bridge NSString *)abName;
                NSString *strLastName = (__bridge NSString *)abLastName;
                
                if ((__bridge id)abFullName != nil) {
                    strName = (__bridge NSString *)abFullName;
                }
                else {
                    if ((__bridge id)abLastName != nil) {
                        strName = [NSString stringWithFormat:@"%@ %@", strName, strLastName];
                    }
                }
                
                contacter.name = strName;
                contacter.recordID = (int)ABRecordGetRecordID(abContacter);;
                contacter.selected = NO;
                
                ABPropertyID multiProperties[] = {
                    kABPersonPhoneProperty,
                    kABPersonEmailProperty
                };
                NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
                for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
                    ABPropertyID property = multiProperties[j];
                    ABMultiValueRef valuesRef = ABRecordCopyValue(abContacter, property);
                    NSInteger valuesCount = 0;
                    if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
                    
                    if (valuesCount == 0) {
                        CFRelease(valuesRef);
                        continue;
                    }
                    
                    //读取电话号码和邮件，遍历直到读到为止
                    for (NSInteger k = 0; k < valuesCount; k++) {
                        CFStringRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                        if (j == 0) {
                            NSString *strPhone = [(__bridge NSString *)value tx_reformatPhoneNumber];
                            if (strPhone && [strPhone tx_trim]) {
#warning 注意这个tx_validatePhone验证，不需要的话注释掉
                                BOOL isValid = [strPhone tx_validatePhone];
                                if (isValid) {
                                    contacter.phone = strPhone;
                                    break;
                                }
                            }
                        }
                        else {
                            NSString *strEmail = (__bridge NSString *)value;
                            if (strEmail && [strEmail tx_trim]) {
                                BOOL isValid = [strEmail tx_validateEmail];
                                if (isValid) {
                                    contacter.email = strEmail;
                                    break;
                                }
                            }
                        }
                        CFRelease(value);
                    }
                    CFRelease(valuesRef);
                }
                
                [contactsTemp addObject:contacter];
                
                if (abName) CFRelease(abName);
                if (abLastName) CFRelease(abLastName);
                if (abFullName) CFRelease(abFullName);
            }
            
            CFRelease(contacts);
            CFRelease(addressBooks);
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (block) {
                    block(contactsTemp, YES);
                }
            });
        }
    }
}

@end

@implementation NSString (TX)

- (BOOL)tx_containsString:(NSString *)string {
    NSRange range = [[self lowercaseString] rangeOfString:[string lowercaseString]];
    return range.location != NSNotFound;
}

- (NSString *)tx_reformatPhoneNumber {
    NSString *string = self;
    if ([string tx_containsString:@"-"]) {
        string = [string stringByReplacingOccurrencesOfString:@"-" withString:@""];
    }
    
    if ([string tx_containsString:@"("]) {
        string = [string stringByReplacingOccurrencesOfString:@"(" withString:@""];
    }
    
    if ([string tx_containsString:@")"]) {
        string = [string stringByReplacingOccurrencesOfString:@")" withString:@""];
    }
    
    if (([string tx_containsString:@"+86"])) {
        string = [string stringByReplacingOccurrencesOfString:@"+86" withString:@""];
    }
    
    if ([string tx_containsString:@" "]) {
        string = [string stringByReplacingOccurrencesOfString:@" " withString:@""];
    }
    
    return string;
}

- (BOOL)tx_validateEmail {
    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";
    NSPredicate *email = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    return [email evaluateWithObject:self];
}

- (BOOL)tx_validatePhone {
    //    NSString *phoneRegex = @"^13[0-9]{9}$|^14[0-9]{9}$|^15[0-9]{9}$|^18[0-9]{9}$|^17[0-9]{9}$|^400[0-9]{7}-?([1-9]{1}[0-9]{0,4})?$";
    NSString *phoneRegex = @"^1\\d{10}$";
    
    NSPredicate *phone = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", phoneRegex];
    return [phone evaluateWithObject:self];
}

- (NSString *)tx_trim {
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end


@implementation TXContacter

- (NSString *)getContacterName {
    if (_name && _name.length > 0) {
        return _name;
    }
    return @"";
}

@end


