//
//  UIImageView+WYWebImage.m
//  ChikeCommerCial
//
//  Created by apple on 2018/3/8.
//  Copyright © 2018年 LL. All rights reserved.
//

#import "UIImageView+WYWebImage.h"

@implementation UIImageView (WYWebImage)

/********************* 普通加载 ************************/

- (void)wy_setImageWithUrlString:(NSString *)urlString {
    [self wy_setImageWithUrlString:urlString placeholderImage:nil radious:0];
}

- (void)wy_setImageWithUrlString:(NSString *)urlString radious:(CGFloat)radious {
    [self wy_setImageWithUrlString:urlString placeholderImage:nil radious:radious];
}

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder {
    NSString * imageUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self wy_setImageWithUrl:[NSURL URLWithString:imageUrl] placeholderImage:placeholder radious:0];
}

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholder radious:(CGFloat)radious {
    NSString * imageUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [self wy_setImageWithUrl:[NSURL URLWithString:imageUrl] placeholderImage:placeholder radious:radious];
}

- (void)wy_setImageWithUrl:(NSURL *)url {
    [self wy_setImageWithUrl:url placeholderImage:nil radious:0];
}

- (void)wy_setImageWithUrl:(NSURL *)url radious:(CGFloat)radious {
    [self wy_setImageWithUrl:url placeholderImage:nil radious:radious];
}

- (void)wy_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [self wy_setImageWithUrl:url placeholderImage:placeholderImage radious:0];
}

/**
 加载图片，是否需要圆角
 
 @param url 图片url
 @param placeholderImage 占位图
 @param radious 圆角
 */
- (void)wy_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage radious:(CGFloat)radious {
    if (url) {
        [self sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
            if (!error) {
                self.image = [UIImage clipImageWithImage:image cornerRadius:radious];
            } else {
                self.image = [UIImage clipImageWithImage:placeholderImage cornerRadius:radious];
            }
        }];
    } else {
        self.image = [UIImage clipImageWithImage:placeholderImage cornerRadius:radious];
    }
}


/********************* 图片自适应 ************************/

- (void)wy_setImageWithUrlString:(NSString *)urlString scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize {
    [self wy_setImageWithUrlString:urlString placeholderImage:nil scaleAspectFit:scaleAspectFit imageViewSize:imageViewSize radious:0];
}

- (void)wy_setImageWithUrlString:(NSString *)urlString scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious {
    [self wy_setImageWithUrlString:urlString placeholderImage:nil scaleAspectFit:scaleAspectFit imageViewSize:imageViewSize radious:radious];
}

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize {
    NSString * imageUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self wy_setImageWithUrl:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage scaleAspectFit:scaleAspectFit imageViewSize:imageViewSize radious:0];
}

- (void)wy_setImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious {
    NSString * imageUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self wy_setImageWithUrl:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage scaleAspectFit:scaleAspectFit imageViewSize:imageViewSize radious:radious];
}

- (void)wy_setImageWithUrl:(NSURL *)url scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize {
    [self wy_setImageWithUrl:url placeholderImage:nil scaleAspectFit:scaleAspectFit imageViewSize:imageViewSize radious:0];
}

- (void)wy_setImageWithUrl:(NSURL *)url scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious {
    [self wy_setImageWithUrl:url placeholderImage:nil scaleAspectFit:scaleAspectFit imageViewSize:imageViewSize radious:radious];
}

/**
 加载图片，是否不变形加载，设置图片圆角
 
 @param url 图片url
 @param placeholderImage 占位图
 @param scaleAspectFit 是否不变形
 @param radious 图片圆角
 */
- (void)wy_setImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit imageViewSize:(CGSize)imageViewSize radious:(CGFloat)radious {
    if (url) {
        if (scaleAspectFit) { // 图片不变形
            [self sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    self.image = [UIImage clipImageWithImage:[UIImage scaleAcceptFitWithImage:image imageViewSize:imageViewSize] cornerRadius:radious];
                } else {
                    self.image = [UIImage clipImageWithImage:placeholderImage cornerRadius:radious];
                }
            }];
        } else { // 图片会变形
            [self sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    self.image = [UIImage clipImageWithImage:image cornerRadius:radious];;
                } else {
                    self.image = [UIImage clipImageWithImage:placeholderImage cornerRadius:radious];
                }
            }];
        }
    } else {
        self.image = [UIImage clipImageWithImage:placeholderImage cornerRadius:radious];
    }
}


/********************* 圆形图片 ************************/

- (void)wy_setCircleImageWithUrlString:(NSString *)urlString {
    [self wy_setCircleImageWithUrlString:urlString placeholderImage:nil];
}

- (void)wy_setCircleImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage {
    NSString * imageUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];

    [self wy_setCircleImageWithUrl:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage scaleAspectFit:NO];
}

- (void)wy_setCircleImageWithUrlString:(NSString *)urlString placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit {
    NSString * imageUrl = [urlString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    [self wy_setCircleImageWithUrl:[NSURL URLWithString:imageUrl] placeholderImage:placeholderImage scaleAspectFit:scaleAspectFit];
}

- (void)wy_setCircleImageWithUrl:(NSURL *)url {
    [self wy_setCircleImageWithUrl:url placeholderImage:nil];
}

- (void)wy_setCircleImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage {
    [self wy_setCircleImageWithUrl:url placeholderImage:placeholderImage scaleAspectFit:NO];
}

/**
 加载圆形图片

 @param url 图片url
 @param placeholderImage 占位图
 @param scaleAspectFit 是否不变形
 */
- (void)wy_setCircleImageWithUrl:(NSURL *)url placeholderImage:(UIImage *)placeholderImage scaleAspectFit:(BOOL)scaleAspectFit {
    if (url) {
        if (scaleAspectFit) {
            [self sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    CGSize size = CGSizeMake(image.size.width, image.size.width);
                    if (image.size.width > image.size.height) {
                        size = CGSizeMake(image.size.height, image.size.height);
                    } else if (image.size.width < image.size.height) {
                        size = CGSizeMake(image.size.width, image.size.width);
                    }
                    self.image = [UIImage circleImageWithImage:[UIImage scaleAcceptFitWithImage:image imageViewSize:size]];
                } else {
                    CGSize size = CGSizeMake(placeholderImage.size.width, placeholderImage.size.width);
                    if (placeholderImage.size.width > placeholderImage.size.height) {
                        size = CGSizeMake(placeholderImage.size.height, placeholderImage.size.height);
                    } else if (placeholderImage.size.width < placeholderImage.size.height) {
                        size = CGSizeMake(placeholderImage.size.width, placeholderImage.size.width);
                    }
                    self.image = [UIImage circleImageWithImage:[UIImage scaleAcceptFitWithImage:placeholderImage imageViewSize:size]];
                }
            }];
        } else {
            [self sd_setImageWithURL:url placeholderImage:placeholderImage options:SDWebImageRetryFailed completed:^(UIImage * _Nullable image, NSError * _Nullable error, SDImageCacheType cacheType, NSURL * _Nullable imageURL) {
                if (!error) {
                    self.image = [UIImage circleImageWithImage:image];
                } else {
                    self.image = [UIImage circleImageWithImage:placeholderImage];
                }
            }];
        }
    } else {
        if (scaleAspectFit) {
            CGSize size = CGSizeMake(placeholderImage.size.width, placeholderImage.size.width);
            if (placeholderImage.size.width > placeholderImage.size.height) {
                size = CGSizeMake(placeholderImage.size.height, placeholderImage.size.height);
            } else if (placeholderImage.size.width < placeholderImage.size.height) {
                size = CGSizeMake(placeholderImage.size.width, placeholderImage.size.width);
            }
            self.image = [UIImage circleImageWithImage:[UIImage scaleAcceptFitWithImage:placeholderImage imageViewSize:size]];
        } else {
            self.image = [UIImage circleImageWithImage:placeholderImage];
        }
    }
}

@end
