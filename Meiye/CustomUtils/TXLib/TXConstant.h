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

//固定颜色模板
#define SUBJECT_COLOR [UIColor colorWithRed:17/255.0f green:135/255.0f blue:209/255.0f alpha:1]

//RGB便利构造宏
#define RGB(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBA(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]
#define RGBS(v) [UIColor colorWithRed:(v)/255.0f green:(v)/255.0f blue:(v)/255.0f alpha:1]

//线程
#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //全局并发队列
#define kMainQueue dispatch_get_main_queue() //主线程队列

//格式化 字符串
#define FORMAT(format, ...) [NSString stringWithFormat:(format), ##__VA_ARGS__]


//控制打印
#ifndef __OPTIMIZE__s
#else
#define NSLog(...) {}
#endif

#endif
