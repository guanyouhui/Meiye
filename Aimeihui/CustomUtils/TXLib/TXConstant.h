//
//  TXConstant.h
//  Yundx
//
//  Created by Pro on 15/7/30.
//  Copyright (c) 2015年 王庭协. All rights reserved.
//

#ifndef Yundx_TXConstant_h
#define Yundx_TXConstant_h


//版本
#define SYSTEM_VERSION [[[UIDevice currentDevice] systemVersion] floatValue]
#define IOS7_OR_LATER ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)

//设备
#define IPHONE5_OR_LATER ( fabsl( ( double )[ [ UIScreen mainScreen ] bounds ].size.height - ( double )568 ) < DBL_EPSILON )

//屏幕宽高、相对于 640 宽的屏幕比例
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)
#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_SCALE ([UIScreen mainScreen].bounds.size.width/640.0f)

//固定颜色模板
#define SUBJECT_COLOR [UIColor colorWithRed:0/255.0f green:153/255.0f blue:255/255.0f alpha:1]

#define MAIN_BG_COLOR [UIColor colorWithRed:238/255.0f green:238/255.0f blue:238/255.0f alpha:1]

//RGB便利构造宏
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBS(v) [UIColor colorWithRed:(v)/255.0f green:(v)/255.0f blue:(v)/255.0f alpha:1]

//线程
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //全局并发队列
#define kMainQueue dispatch_get_main_queue() //主线程队列

//格式化 字符串
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]
#define STRING_INT(value) [NSString stringWithFormat:@"%ld",(long)value]
#define STRING_FLOAT0(value) [NSString stringWithFormat:@"%.0f",value]
#define STRING_FLOAT2(value) [NSString stringWithFormat:@"%.2f",value]
#define STRING_FLOAT_P(value) [NSString stringWithFormat:@"￥%.2f",value]


#define  kUserDefaults [NSUserDefaults standardUserDefaults]
//控制打印
#ifndef __OPTIMIZE__s
#else
#define NSLog(...) {}
#endif

#endif
