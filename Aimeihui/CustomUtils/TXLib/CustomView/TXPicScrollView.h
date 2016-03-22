//
//  TXAutoPicScrollView.h
//  HorizontalScrollViewDemo
//
//  Created by tingxie on 14-9-19.
//  Copyright (c) 2014年 Reese. All rights reserved.
//


#import <UIKit/UIKit.h>
@protocol TXPicScrollViewDelegate;


@interface TXPicScrollView : UIScrollView

@property (nonatomic, weak) id<TXPicScrollViewDelegate> o_txDelegate;

/*
 * 当前图片数量
 */
@property (nonatomic,assign,readonly) NSInteger o_imageCount;

/*
 * 限制图片数量 （为0时：不限制）
 */
@property (nonatomic,assign) int o_maxLimitoAmount;

/*
 * 图片的最大宽度、限制图片的宽度 （为0时，不做处理）
 */
@property (nonatomic, assign) CGFloat o_imageMaxWidth;
/*
 * 图片的最大文件字节 (单位KB)  （为0时，不做处理）
 */
@property (nonatomic, assign) NSInteger o_imageMaxKByte;

/*
 * 截取图片的界面尺寸  （width 或 height 为0时，默认取原图）
 */
@property (nonatomic, assign) CGSize o_imageSize;

/*
 * 是否支持多选 （默认：NO）
 */
@property (nonatomic, assign) BOOL o_multiSelect;

/*
 * 是否支持预览 （默认：NO）
 */
@property (nonatomic, assign) BOOL o_preview;


/*
 * 是否支持删除 （默认：YES）
 */
@property (nonatomic, assign) BOOL o_supportDelete;

/*
 * 是否是简单的预览 （默认：NO）
 * 当 o_onlyPreview 为 YES 时，o_preview同步为YES，o_supportDelete同步为NO
 */
@property (nonatomic, assign) BOOL o_onlyPreview;

/*
 * images 数组里 可以是 NSURL 、NSString 或 UIImage
 */
-(void)addMoreImages:(NSArray *)images;

/*
 * image 可以是 NSURL、NSString 或 UIImage
 * 视图的位置调至最右
 */
-(void)addImage:(id)image;

/*
 * 删除第几张图片
 */
-(void)deleteImageWithIndex:(NSInteger )index;

/*
 * 清空图片
 */
- (void)clearAllImage;
@end


@protocol TXPicScrollViewDelegate <NSObject>

@optional
/*
 * 点击选择图片
 */
-(void)picScrollViewShouldChoosePic:(TXPicScrollView *)scrollView;

/*
 添加完图片返回
 */
-(void)picScrollView:(TXPicScrollView *)scrollView didFinishedImages:(NSArray *)imageDatas;

/*
 删除完一张图片返回
 */
-(void)picScrollView:(TXPicScrollView *)scrollView deleteImageForIndex:(NSInteger)index;


@end