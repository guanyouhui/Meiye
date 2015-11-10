//
//  ZUtilsImage.h
//  ZUtilsLib
//
//  Created by zhwx on 14-5-8.
//  Copyright (c) 2014年 zhwx. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>


@interface ZUtilsImage : NSObject

/**
 * 通过uicolor 转 uiimage
 */
+ (UIImage*) getImageWithColor: (UIColor*) color;

/**
 * 通过网址得到图片
 */
+ (UIImage *)loadImageOverHttp:(NSString *)url;

/**
 * 根据size.width 为基准， 按照图片等比例缩放 获取适配控件的 size
 */
+ (CGSize)getImageScaledSize:(UIImage *)image toResolution:(CGSize)size;

/**
 * 图片截取
 * @param cropFrame 该参数的Size以实际的图片Size作为参考对象，忽略高清图的Size
 */
+ (UIImage *)getSubImageWithOriginaSimple:(UIImage*)originalImage CropFrame:(CGRect )cropFrame;

/**
 * 图片缩小
 * @param size 该参数以实际的图片Size作为参考对象，忽略高清图的Size
 */
+ (UIImage*)imageWithImageSimple:(UIImage*)image scaledToSize:(CGSize)size;

/**
 * 修复图片方向
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 * 生成模糊图
 * @param blurRadius 该参数是一个模糊度值 （ 0 - 68 ）
 */
+ (UIImage *)applyBlurWithImage:(UIImage *)effectImage Radius:(CGFloat)blurRadius;

@end
