//
//  WYPackagePhotoBrowser.m
//  QianHong
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "WYPackagePhotoBrowser.h"

@implementation WYPackagePhotoBrowser

/**
 显示图片
 
 @param imageArray 图片数组
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithImageArray:(NSMutableArray *)imageArray currentIndex:(NSInteger)currentIndex {
    
    [self showPhotoWithImageArray:imageArray sourceImageView:nil currentIndex:currentIndex];
}

/**
 显示图片

 @param imageArray 图片数组
 @param sourceImageView 来源imageView
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithImageArray:(NSMutableArray *)imageArray sourceImageView:(NSMutableArray *)sourceImageView currentIndex:(NSInteger)currentIndex {
    
    // 查看图片
    NSMutableArray *photos = [NSMutableArray new];
    [imageArray enumerateObjectsUsingBlock:^(UIImage * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GKPhoto *photo = [GKPhoto new];
        photo.image = obj;
        if (sourceImageView) {
            photo.sourceImageView = sourceImageView[idx];
        }
        
        [photos addObject:photo];
    }];
    
    [self showPhotoWithPhotos:photos sourceImageView:sourceImageView currentIndex:currentIndex];
}


/**
 显示图片
 
 @param urlArray 图片url数组
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithUrlArray:(NSMutableArray *)urlArray currentIndex:(NSInteger)currentIndex {
    
    [self showPhotoWithUrlArray:urlArray sourceImageView:nil currentIndex:currentIndex];
}

/**
 显示图片
 
 @param urlArray 图片url数组
 @param sourceImageView 来源imageView
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithUrlArray:(NSMutableArray *)urlArray sourceImageView:(NSMutableArray *)sourceImageView currentIndex:(NSInteger)currentIndex {
    
    // 查看图片
    NSMutableArray *photos = [NSMutableArray new];
    [urlArray enumerateObjectsUsingBlock:^(NSString * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        GKPhoto *photo = [GKPhoto new];
        photo.url = [NSURL URLWithString:obj];
        if (sourceImageView) {
            photo.sourceImageView = sourceImageView[idx];
        }
        
        [photos addObject:photo];
    }];
    
    [self showPhotoWithPhotos:photos sourceImageView:sourceImageView currentIndex:currentIndex];
}


/**
 显示图片
 
 @param photos 图片数组
 @param sourceImageView 来源imageView
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithPhotos:(NSMutableArray *)photos sourceImageView:(NSMutableArray *)sourceImageView currentIndex:(NSInteger)currentIndex {
    
    GKPhotoBrowser *browser = [GKPhotoBrowser photoBrowserWithPhotos:photos currentIndex:currentIndex];
    browser.showStyle           = GKPhotoBrowserShowStyleNone;
    browser.hideStyle           = GKPhotoBrowserHideStyleZoom;
    browser.loadStyle           = GKPhotoBrowserLoadStyleDeterminate;
    browser.isResumePhotoZoom   = YES;
    [browser showFromVC:[WYUtils currentViewController]];

    
}

@end
