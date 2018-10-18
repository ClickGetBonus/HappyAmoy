//
//  WYPhotoLibraryManager.h
//  DianDian
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPhotoLibraryManager : NSObject

/**
 保存图片
 
 @param image 待保存的图片
 @param completionBlock 保存图片的回调
 */
+ (void)wy_savePhotoImage:(UIImage *)image completion:(void(^)(UIImage *image, NSError *error))completionBlock;

/**
 保存图片
 
 @param image 待保存的图片
 @param assetCollectionName 相册名字，默认为APP名字
 @param completionBlock 保存图片的回调
 */
+ (void)savePhotoImage:(UIImage *)image assetCollectionName:(NSString *)assetCollectionName completion:(void(^)(UIImage *image, NSError *error))completionBlock;


/**
 保存视频
 
 @param videoUrl 视频路径
 @param assetCollectionName 相册名字，默认为APP名字
 @param completionBlock 保存视频完成后的回调
 */
+ (void)saveVideoWithURL:(NSURL *)videoUrl assetCollectionName:(NSString *)assetCollectionName completion:(void(^)(NSURL *videoUrl, NSError *error))completionBlock;


@end
