//
//  ZLog.h
//  PaixieMall
//
//  Created by zhwx on 15/1/8.
//  Copyright (c) 2015年 拍鞋网. All rights reserved.
//

#ifndef PaixieMall_ZLog_h
#define PaixieMall_ZLog_h

#define NEED_OUTPUT_LOG                     1

#if NEED_OUTPUT_LOG

//普通答应
#define SLog(format, ...)   NSLog(format, ##__VA_ARGS__)
//打印 行号 函数
#define SLLog(format, ...)  NSLog(@"line:%d fun:%s\n" format, __LINE__,__PRETTY_FUNCTION__,  ##__VA_ARGS__)

//打印出 调用的文件名 行号 函数
#define SFLLog(format, ...)  NSLog(@"%@ line:%d fun:%s\n" format,[[NSString stringWithUTF8String:__FILE__] lastPathComponent], __LINE__,__PRETTY_FUNCTION__,  ##__VA_ARGS__)


#define SLLogRect(rect) \
SLLog(@"%s x=%f, y=%f, w=%f, h=%f", #rect, rect.origin.x, rect.origin.y, \
rect.size.width, rect.size.height)


#define SLLogPoint(pt) \
SLLog(@"%s x=%f, y=%f", #pt, pt.x, pt.y)


#define SLLogSize(size) \
SLLog(@"%s w=%f, h=%f", #size, size.width, size.height)


#define SLLogColor(_COLOR) \
SLLog(@"%s h=%f, s=%f, v=%f", #_COLOR, _COLOR.hue, _COLOR.saturation, _COLOR.value)


#define SLLogSuperViews(_VIEW) \
{ for (UIView* view = _VIEW; view; view = view.superview) { SLLog(@"%@", view); } }


#define SLLogSubViews(_VIEW) \
{ for (UIView* view in [_VIEW subviews]) { SLLog(@"%@", view); } }


#else


#define SLog(format, ...)  ((void)0)
#define SLLog(format, ...)  ((void)0)
#define SFLLog(format, ...) ((void)0)

#endif



#endif
