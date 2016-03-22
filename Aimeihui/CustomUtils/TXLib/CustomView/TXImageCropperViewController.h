//
//  VPImageCropperViewController.h
//  VPolor
//
//  Created by Vinson.D.Warm on 12/30/13.
//  Copyright (c) 2013 Huang Vinson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TXImageCropperViewController;

@protocol TXImageCropperDelegate <NSObject>

- (void)imageCropper:(TXImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage;
- (void)imageCropperDidCancel:(TXImageCropperViewController *)cropperViewController;

@end

@interface TXImageCropperViewController : TXViewController


@property (nonatomic,assign)UIImagePickerControllerSourceType o_entryType;
@property (nonatomic, assign) NSInteger tag;
@property (nonatomic, assign) id<TXImageCropperDelegate> delegate;

- (id)initWithImage:(UIImage *)originalImage cropSize:(CGSize)cropSize limitScaleRatio:(NSInteger)limitRatio;

@end
