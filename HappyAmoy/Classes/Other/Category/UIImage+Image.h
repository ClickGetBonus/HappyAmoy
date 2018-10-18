//
//  UIImage+Image.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Image)

/**
 快速生成不被渲染的图片
 
 @param imageNamed 图片名称
 
 @return 不被渲染的图片
 */
+ (UIImage *)imageOriginalWithNamed:(NSString *)imageNamed;

/**
 根据颜色生成图片
 
 @param color 颜色
 
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color;

/**
 裁剪圆角图片
 
 @param image 需要裁剪的图片
 @param cornerRadius 圆角大小
 @return 返回裁剪后的圆角图片
 */
+ (UIImage *)clipImageWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius;

/**
 裁剪圆形图片
 
 @param image 需要裁剪的图片
 
 @return 返回裁剪后的圆形图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image;

/**
 裁剪圆形图片（带边框）
 
 @param image       需要裁剪的图片
 @param borderWidth 边框宽度
 @param borderColor 边框颜色
 
 @return 裁剪后的图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor;

/**
 压图片质量
 
 @param image image
 @return Data
 */
+ (NSData *)compressImage:(UIImage *)image fileSize:(CGFloat)fileSize;

/**
 压缩个人头像为 具体 的尺寸
 
 @param size 尺寸大小
 @return 压缩后的头像
 */
- (UIImage *)imageWithHeadImage:(CGFloat)size;

/**
 把图片压缩为对应的尺寸
 
 @param image   需要压缩的图片
 @param newSize 压缩的尺寸
 
 @return 压缩后的图片
 */
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize;

/**
 把图片转为指定大小的二进制，然后二进制再经过base64编码
 
 @param image 需要转换的图片
 
 @return 返回字符串
 */
+ (NSString *)imageStreamWithImage:(UIImage *)image fileSize:(CGFloat)fileSize;

/**
 把二进制字符串转为图片
 
 @param dataString 二进制字符串
 
 @return 图片
 */
+ (UIImage *)imageWithDataString:(NSString *)dataString;

/**
 返回正常角度的图片
 
 @param aImage 被旋转处理过了的图片
 
 @return 返回正常角度的图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage;

/**
 保存图片到项目自定义相册
 */
- (void)savePhotoToCustomAlbum;

/**
 获取视频的第一帧截图
 
 @param videoPath 视频路径
 
 @return 视频的第一帧截图
 */
+ (UIImage *)getVideoPreViewImageWithVideoPath:(NSString *)videoPath;

//+ (UIImage*) thumbnailImageForVideo:(NSURL *)videoURL atTime:(NSTimeInterval)time;

/**
 从图片中按默认的位置大小截取图片的一部分，默认截取中间部分的图片
 
 @param image 原始的图片
 @return 截取后的图片
 */
+ (UIImage *)cropSquareImageWithImage:(UIImage *)image;

/**
 根据imageView的尺寸截取不变形压缩的图片
 
 @param image 原图
 @param imageView imageView
 @return 不变形的图片
 */
+ (UIImage *)scaleAcceptFitWithImage:(UIImage *)image imageView:(UIImageView *)imageView;

/**
 根据imageView的尺寸截取不变形压缩的图片
 
 @param image 原图
 @param imageViewSize 容器的尺寸
 @return 不变形的图片
 */
+ (UIImage *)scaleAcceptFitWithImage:(UIImage *)image imageViewSize:(CGSize)imageViewSize;

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)cropImageWithImage:(UIImage *)image cropRect:(CGRect)rect;

/**
 保存图片
 
 @param image 图片
 @param fileName 图片名称
 @param pathComponent 图片缓存路径
 */
+ (void)saveImage:(UIImage *)image fileName:(NSString *)fileName pathComponent:(NSString *)pathComponent;

/**
 根据图片名称和图片路径获取缓存的图片
 
 @param fileName 图片名称
 @return 图片
 */
+ (UIImage *)getImageWithPathComponent:(NSString *)pathComponent fileName:(NSString *)fileName;

/**
 根据图片名称获取聊天记录的位置图片
 
 @param fileName 图片名称
 @return 图片
 */
+ (UIImage *)getLocationImageWithFileName:(NSString *)fileName;

/**
 截屏
 
 @param view 待截屏的view
 @return 截屏后的图片
 */
+ (UIImage *)snapImageWithView:(UIView *)view;

/**
 *  图片旋转
 */
+ (UIImage *)rotateImage:(UIImage *)image withOrientation:(UIImageOrientation)orientation;


/****************** 芊泓新增方法 ******************/


/**
 获取图片缩略图
 
 @param image 原图
 @param fileSize 缩略图大小
 @return 缩略图
 */
+ (UIImage *)thumbImageWithImage:(UIImage *)image fileSize:(CGFloat)fileSize;

@end
