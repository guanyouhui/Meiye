//
//  main.m
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AppDelegate.h"

int main(int argc, char * argv[]) {
    @autoreleasepool {
        @try {
            return UIApplicationMain(argc, argv, nil, NSStringFromClass([AppDelegate class]));
        }
        @catch (NSException *exception) {
            NSLog(@"蛋疼的异常:\n%@\n---------",[exception callStackSymbols]);
            NSLog(@"NSThread callStackSymbols:\n%@\n-------",[NSThread callStackSymbols]);
        }
        @finally {
            
        }
    }
}
