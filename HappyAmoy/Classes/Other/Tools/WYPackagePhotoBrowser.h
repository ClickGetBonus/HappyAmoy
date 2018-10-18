//
//  WYPackagePhotoBrowser.h
//  QianHong
//
//  Created by apple on 2018/4/11.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPackagePhotoBrowser : NSObject

/**
 显示图片
 
 @param imageArray 图片数组
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithImageArray:(NSMutableArray *)imageArray currentIndex:(NSInteger)currentIndex;

/**
 显示图片
 
 @param imageArray 图片数组
 @param sourceImageView 来源imageView
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithImageArray:(NSMutableArray *)imageArray sourceImageView:(NSMutableArray *)sourceImageView currentIndex:(NSInteger)currentIndex;

/**
 显示图片
 
 @param urlArray 图片url数组
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithUrlArray:(NSMutableArray *)urlArray currentIndex:(NSInteger)currentIndex;

/**
 显示图片
 
 @param urlArray 图片url数组
 @param sourceImageView 来源imageView
 @param currentIndex 当前索引
 */
+ (void)showPhotoWithUrlArray:(NSMutableArray *)urlArray sourceImageView:(NSMutableArray *)sourceImageView currentIndex:(NSInteger)currentIndex;

@end
