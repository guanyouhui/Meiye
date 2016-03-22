//
//  TXAutoPicScrollView.m
//  HorizontalScrollViewDemo
//
//  Created by tingxie on 14-9-19.
//  Copyright (c) 2014年 Reese. All rights reserved.
//

#import "TXPicScrollView.h"
#import <QuartzCore/QuartzCore.h>
#import <AVFoundation/AVFoundation.h>
#import "EGOImageView.h"
#import "TXImageCropperViewController.h"
//#import "ZPhotoGroupViewController.h"
//#import "ZPreScrollViewController.h"

//#define  self.height 80
//#define  self.height 80

#define  INSETS 10

#define Image_Pression_Scale  0.6f

#define ALERT_DELETE_TAG 100

@interface TXPicScrollView ()<UIImagePickerControllerDelegate,UINavigationControllerDelegate,UIActionSheetDelegate,UIAlertViewDelegate,TXImageCropperDelegate/*,ZPhotoGroupImageDelegate,ZPreScrollViewDelegate*/>{
    
//    ZPhotoGroupViewController * o_selectGroupVC;//选择多张图 或者 拍照单张图
    NSMutableArray * o_allImageViews;
    NSInteger o_selectIndex;
}
@property (retain, nonatomic) UIButton *plusButton;

@property (nonatomic, weak) UIViewController * o_txController; // 控制器对象


@property (nonatomic, assign) CGFloat constantWH;

@end

@implementation TXPicScrollView

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Initialization code
        [self initControl];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self initControl];
    }
    return self;
}
-(void)layoutSubviews{
    [super layoutSubviews];
//    [self refreshScrollView];
}
-(void)initControl{
    self.o_supportDelete = YES;
    o_allImageViews =[[NSMutableArray alloc]init];
    
    self.showsVerticalScrollIndicator=NO;
    self.showsHorizontalScrollIndicator=NO;
    
    _plusButton=[UIButton buttonWithType:UIButtonTypeCustom];
    _plusButton.frame=CGRectMake(INSETS, INSETS, self.constantWH, self.constantWH);
    [_plusButton addTarget:self action:@selector(plusImageAction:) forControlEvents:UIControlEventTouchUpInside];
    [_plusButton setBackgroundImage:[UIImage imageNamed:@"tx_add_image.png"] forState:UIControlStateNormal];
    [self addSubview:_plusButton];
    
}

#pragma mark - set methods
-(void)setO_txDelegate:(id<TXPicScrollViewDelegate>)o_txDelegate{
    if (o_txDelegate) {
        _o_txController = (UIViewController *)o_txDelegate;
        _o_txDelegate=o_txDelegate;
    }
}

- (void)setO_onlyPreview:(BOOL)o_onlyPreview{
    _o_onlyPreview = o_onlyPreview;
    if (o_onlyPreview) {
        self.o_preview = YES;
        self.o_supportDelete = NO;
        _plusButton.hidden = YES;
    }
}

#pragma mark - get methods
-(NSInteger)o_imageCount{
    return o_allImageViews.count;
}

- (CGFloat )constantWH{
    return self.height - INSETS*2;
}
#pragma mark - Action

//- (IBAction)clearPics:(id)sender {
//    [sender clearAllImage];
//}


//选择图片添加
- (void)plusImageAction:(UIButton *)sender {
    
    if (_o_txDelegate && [_o_txDelegate respondsToSelector:@selector(picScrollViewShouldChoosePic:)]) {
        [_o_txDelegate picScrollViewShouldChoosePic:self];
    }
    
    //是否支持多选
    if (self.o_multiSelect) {
        [self pushMultiSelectPhotoViewController];
    }else{
        UIActionSheet * as=[[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"相册",@"拍照", nil];
        [as showInView:self];
    }
}

//点击图片
-(void)tapImageAction:(UITapGestureRecognizer *)sender{
    
    if (self.o_preview) {
        [self showPreView:[self getAllImages] withIndex:sender.view.tag];
    }

}

//点击图片删除
-(void)deleteImageAction:(UIButton *)sender{
    
    o_selectIndex = sender.superview.tag;
    
    UIAlertView * av=[[UIAlertView alloc]initWithTitle:@"确认删除该图片？" message:@"" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"删除", nil];
    av.tag = ALERT_DELETE_TAG;
    [av show];
    
}


#pragma mark -- 实例方法
/*
 * images 数组里 可以是 NSURL 或 UIImage
 */
-(void)addMoreImages:(NSArray *)images{
    
    for (id image in images) {
        [self simpleAddImage:image];
    }
    
    //移动添加按钮
    [self animationPlusButton];
    
    [self refreshScrollView:NO];
}

-(void)addImage:(id)image{
    
    [self simpleAddImage:image];
    
    //移动添加按钮
    [self animationPlusButton];
    
    [self refreshScrollView:YES];
}

-(void)deleteImageWithIndex:(NSInteger)index{
    
    if (index < 0 || index >= o_allImageViews.count)
        return;
    
    if (_o_txDelegate && [_o_txDelegate respondsToSelector:@selector(picScrollView:deleteImageForIndex:)]) {
        [_o_txDelegate picScrollView:self deleteImageForIndex:index];
    }
    
    UIImageView * aImageView = [o_allImageViews objectAtIndex:index];
    [aImageView removeFromSuperview];
    [o_allImageViews removeObject:aImageView];
    
    for (NSInteger i = 0; i<o_allImageViews.count; i++) {
        UIView *img =o_allImageViews[i];
        img.tag=i;
        [UIView animateWithDuration:0.25f animations:^{
            img.frame=CGRectMake(INSETS+i*(_plusButton.width+INSETS), img.frame.origin.y, img.frame.size.width, img.frame.size.height);
        }];
        
    }
    
    _plusButton.hidden = NO;
    
    //移动添加按钮
    [self animationPlusButton];
    
    [self refreshScrollView:YES];
}


#pragma mark - 逻辑方法

-(void)simpleAddImage:(id)image{
    
    if (!image) return;
    
    //添加图片
    EGOImageView *aImageView=[[EGOImageView alloc]init];
    aImageView.userInteractionEnabled=YES;
    if ([image isKindOfClass:[UIImage class]]) {
        aImageView.image=image;
    }
    else if ([image isKindOfClass:[NSURL class]]) {
        aImageView.imageURL=image;
    }
    else if ([image isKindOfClass:[NSString class]]) {
        aImageView.imageURL=[NSURL URLWithString:image];
    }
    
    [aImageView setContentMode:UIViewContentModeScaleAspectFill];
    CGFloat imageX = INSETS+((INSETS+self.constantWH) * o_allImageViews.count);
    [aImageView setFrame:CGRectMake(imageX, _plusButton.y, self.constantWH, self.constantWH)];
    aImageView.tag = o_allImageViews.count;
    aImageView.layer.borderWidth = 1.0;
    aImageView.layer.borderColor = RGB(212, 212, 212).CGColor;
    aImageView.layer.masksToBounds = YES;
    
    if (!self.o_onlyPreview) {
        //添加图片删除按钮
        UIButton *deleteBtn=[UIButton buttonWithType:UIButtonTypeCustom];
        [deleteBtn setImage:[UIImage imageNamed:@"tx_delete_image.png"] forState:UIControlStateNormal];
        [deleteBtn addTarget:self action:@selector(deleteImageAction:) forControlEvents:UIControlEventTouchUpInside];
        [deleteBtn setFrame:CGRectMake(aImageView.width-24, 0, 24, 24)];
        [deleteBtn setImageEdgeInsets:UIEdgeInsetsMake(-3, 0, 0, -3)];
        [aImageView addSubview:deleteBtn];
    }
    
    
    //添加点击事件
    UITapGestureRecognizer * imageTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(tapImageAction:)];
    [aImageView addGestureRecognizer:imageTap];
    
    [o_allImageViews addObject:aImageView];
    
    [self addSubview:aImageView];
    
    
    
    //判断选的照片是否超过限制的数量
    if (_o_maxLimitoAmount > 0 && o_allImageViews.count >= _o_maxLimitoAmount) {
        _plusButton.hidden = YES;
    }
    
}

//最终 选择完 单张图片
-(void)selectedImage:(UIImage *)image{
    NSData * subImageData=[self compressionWithImage:image];
    
    
    if (_o_txDelegate && [_o_txDelegate respondsToSelector:@selector(picScrollView:didFinishedImages:)]) {
        [_o_txDelegate picScrollView:self didFinishedImages:[NSArray arrayWithObject:subImageData]];
    }
}

//最终 选择完 多张图片
-(void)multipleImages:(NSArray *)images{
    NSMutableArray * subImageDatas = [NSMutableArray array];
    for (int i = 0; i < images.count; i++) {
        NSData * subImageData=[self compressionWithImage:images [i]];
        [subImageDatas addObject:subImageData];
    }
    
    if (_o_txDelegate && [_o_txDelegate respondsToSelector:@selector(picScrollView:didFinishedImages:)]) {
        [_o_txDelegate picScrollView:self didFinishedImages:subImageDatas];
    }
}

//清空图片
-(void)clearAllImage{
    for (EGOImageView *img in o_allImageViews)
    {
        [img removeFromSuperview];
    }
    [o_allImageViews removeAllObjects];
    
//    _plusButton.hidden = NO;
//    
//    [self animationPlusButton];
//    [self refreshScrollView:YES];
}


//重置ScollView的内容区
- (void)animationPlusButton
{
    CGPoint toPoint = CGPointMake(INSETS + self.o_imageCount * (_plusButton.width + INSETS) + _plusButton.width/2, _plusButton.centerY);
    
    CABasicAnimation *positionAnim=[CABasicAnimation animationWithKeyPath:@"position"];
    [positionAnim setFromValue:[NSValue valueWithCGPoint:CGPointMake(_plusButton.center.x, _plusButton.center.y)]];
    [positionAnim setToValue:[NSValue valueWithCGPoint:toPoint]];
    [positionAnim setDelegate:self];
    [positionAnim setTimingFunction:[CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseInEaseOut]];
    [positionAnim setDuration:0.25f];
    [_plusButton.layer addAnimation:positionAnim forKey:nil];
    [_plusButton setCenter:toPoint];
    
    
}

//重新设置 内容区 并判断是否将视图的位置调至最右

- (void)refreshScrollView:(BOOL)offset{
    CGFloat width = _plusButton.hidden ? _plusButton.left:(_plusButton.right+INSETS);
    
    CGSize contentSize=CGSizeMake(width, self.frame.size.height);
    [self setContentSize:contentSize];
    
    if (offset) {
        [self setContentOffset:CGPointMake(width<self.width?0:width-self.width, 0) animated:YES];
    }
}

#pragma mark - UIUIAlertViewDelegate

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == ALERT_DELETE_TAG) {
        if (buttonIndex==1) {
            
            [self deleteImageWithIndex:o_selectIndex];
            
        }
    }
}

#pragma mark - UIActionSheetDelegate

-(void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex==0){
        [self showPickerController:UIImagePickerControllerSourceTypePhotoLibrary];
    } else if (buttonIndex==1) {
        [self showPickerController:UIImagePickerControllerSourceTypeCamera];
    }
}

#pragma mark  - 图片获取 UIImagePickerController
-(void)showPickerController:(UIImagePickerControllerSourceType ) sourceType{
    UIImagePickerController *pickerCamera = [[UIImagePickerController alloc] init];
    pickerCamera.delegate = self;
    
#if (TARGET_IPHONE_SIMULATOR)
    // 在模拟器的情况下
    pickerCamera.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
#else
    // 在真机情况下
    pickerCamera.sourceType = sourceType;
#endif
    
    pickerCamera.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
    //    pickerCamera.allowsEditing = YES;
    if (_o_txController) {
        [_o_txController presentViewController:pickerCamera animated:YES completion:nil];
    }
    
}
-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    NSString *mediaType = [info objectForKey:UIImagePickerControllerMediaType];
    if ([mediaType isEqualToString:@"public.image"]) {
        
        UIImage * pickerImage=[info objectForKey:UIImagePickerControllerOriginalImage];
        
        pickerImage = [ZUtilsImage fixOrientation:pickerImage];
        
        if (_o_imageSize.width == 0.0 || _o_imageSize.height == 0.0) {
            [self selectedImage:pickerImage];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }else {
            [self pushImageCropperViewControllerWithController:picker andPickerImage:pickerImage];
        }
    }
    
}

-(void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark- MultiSelectPhotoViewController
/**
 *  push添加照片
 */
- (void)pushMultiSelectPhotoViewController
{
    
#warning - 缺模块
    //保存对象  防止 ALSset 对象消失
//    NSInteger maxCount = _o_maxLimitoAmount - self.o_imageCount;
//    o_selectGroupVC = [[ZPhotoGroupViewController alloc] init];
//    o_selectGroupVC.o_handleViewController = _o_txController;
//    o_selectGroupVC.o_delegate = self;
//    o_selectGroupVC.o_maxImagesCount = maxCount;
//    [_o_txController.navigationController pushViewController:o_selectGroupVC animated:YES];
}


#pragma mark- ZPhotoGroupImageDelegate
/**
 * 选择完毕后，代理，返回结果。 images 为 UIImage 数组
 */
-(void) didSelectedImages:(NSArray*)images
{
//    o_reqCount = 0;
//    _o_checkImages = images;
//    o_naviRight.hidden = YES;
//    [self upLoadImageWithIndex:o_reqCount];
    [self multipleImages:images];
    
}

#pragma mark - 图片预览 ZPreScrollViewController

- (void)showPreView:(NSArray *)arr withIndex:(NSInteger)index
{
#warning - 缺模块
//    NSArray *images = [NSMutableArray arrayWithArray:arr];
//    
//    ZPreScrollViewController* preView = [[ZPreScrollViewController alloc] init];
//    preView.o_delegate = self;
//    preView.o_imageArray = images;
//    preView.o_currentPage = index;
//    preView.o_isHaveDelete = self.o_supportDelete;
//    if (_o_txController) {
//        [_o_txController presentViewController:preView animated:YES completion:nil];
//    }else{
//        //在只有纯预览的时候使用到
//#warning - 待填充
//        [[GlobalVC shared].o_mainTabVC presentViewController:preView animated:YES completion:nil];
//    }
    
}

// ZPreScrollViewDelegate
-(void) deleteImageItem:(id)item andIndex:(NSInteger)index{
    if (index < o_allImageViews.count) {
        [self deleteImageWithIndex:index];
    }
}

#pragma mark - 图片截取 TXImageCropperViewController

- (void)pushImageCropperViewControllerWithController:(UIImagePickerController *)pickerController andPickerImage:(UIImage *)pickerImage{
    TXImageCropperViewController *imgEditorVC = [[TXImageCropperViewController alloc] initWithImage:pickerImage cropSize:_o_imageSize limitScaleRatio:3.0f];
    imgEditorVC.o_entryType = pickerController.sourceType;
    imgEditorVC.delegate = self;
    [pickerController pushViewController:imgEditorVC animated:YES];
}

// TXImageCropperDelegate
- (void)imageCropper:(TXImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage{
    [self selectedImage:editedImage];
    [cropperViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)imageCropperDidCancel:(TXImageCropperViewController *)cropperViewController{
    
}

#pragma mark - 图片处理方法

//图片压缩
-(NSData * )compressionWithImage:(UIImage *)image{
    UIImage * aImage =image;
    if (_o_imageMaxWidth>0 && aImage.size.width>_o_imageMaxWidth) {
        aImage=[self imageCompressForWidth:aImage targetWidth:_o_imageMaxWidth];
    }
    
    NSData * aImageData=UIImageJPEGRepresentation(aImage, Image_Pression_Scale);
    
    if (_o_imageMaxKByte<=0) {
        return aImageData;
    }
    
    
    //算出比例差值
    CGFloat maxByte=_o_imageMaxKByte * 1024;
    
    CGFloat multiple=MIN(aImageData.length/maxByte, 10.0) ;
    
    CGFloat compressionQuality=1-multiple/10;
    
    if (aImageData.length>maxByte) {
        aImageData=UIImageJPEGRepresentation(aImage, compressionQuality);
    }
    
    NSLog(@"alength:%lu",(unsigned long)aImageData.length);
    
    return aImageData;
}

//根据图片宽度，等比压缩
-(UIImage *) imageCompressForWidth:(UIImage *)sourceImage targetWidth:(CGFloat)defineWidth{
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = defineWidth;
    CGFloat targetHeight = height / (width / targetWidth);
    CGSize size = CGSizeMake(targetWidth, targetHeight);
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0, 0.0);
    if(CGSizeEqualToSize(imageSize, size) == NO){
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        if(widthFactor > heightFactor){
            scaleFactor = widthFactor;
        }
        else{
            scaleFactor = heightFactor;
        }
        scaledWidth = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        if(widthFactor > heightFactor){
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }else if(widthFactor < heightFactor){
            thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
        }
    }
    UIGraphicsBeginImageContext(size);
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil){
        NSLog(@"scale image fail");
    }
    
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - 遍历方法


-(NSMutableArray *)getAllImages{
    
    NSMutableArray * allImages=[NSMutableArray array];
    for (EGOImageView * imageView in o_allImageViews) {
        if (imageView.imageURL) {
            [allImages addObject:imageView.imageURL];
        }
        else if (imageView.image){
            [allImages addObject:imageView.image];
        }
        else{
             [allImages addObject:@""];
        }
    }
    return allImages;
    
}

@end
