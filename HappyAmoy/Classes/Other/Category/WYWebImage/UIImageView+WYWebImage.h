//
//  UIImageView+WYWebImage.h
//  ChikeCommerCial
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 LL. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImageView (WYWebImage)

/********************* 普通加载 ************************/

- (void)wy_setImageWithUrlString:(NSString *)urlString;

- (void)wy_setImageWithUrlString:(NSString *)urlString radious:(CGFloat)radious;

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder;

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder radious:(CGFloat)radious;

- (void)wy_setImageWithUrl:(NSURL *)url;

- (void)wy_setImageWithUrl:(NSURL *)url radious:(CGFloat)radious;

- (void)wy_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 加载图片，是否需要圆角
 
 @param url 图片url
 @param placeholderImage 占位图
 @param radious 圆角
 */
- (void)wy_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage radious:(CGFloat)radious;


/********************* 图片自适应 ************************/

- (void)wy_setImageWithUrlString:(NSString *)urlString scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize;

- (void)wy_setImageWithUrlString:(NSString *)urlString scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious;

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize;

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious;

- (void)wy_setImageWithUrl:(NSURL *)url scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize;

- (void)wy_setImageWithUrl:(NSURL *)url scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious;

/**
 加载图片，是否不变形加载，设置图片圆角
 
 @param url 图片url
 @param placeholderImage 占位图
 @param scaleAspectFit 是否不变形
 @param radious 图片圆角
 */
- (void)wy_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious;


/********************* 圆形图片 ************************/

- (void)wy_setCircleImageWithUrlString:(NSString *)urlString;

- (void)wy_setCircleImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage;

- (void)wy_setCircleImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit;

- (void)wy_setCircleImageWithUrl:(NSURL *)url;

- (void)wy_setCircleImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage;

/**
 加载圆形图片
 
 @param url 图片url
 @param placeholderImage 占位图
 @param scaleAspectFit 是否不变形
 */
- (void)wy_setCircleImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit;

@end
