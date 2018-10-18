//
//  WYUploader.h
//  QianHong
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *    上传进度回调函数
 *
 *    @param key     上传时指定的存储key
 *    @param percent 进度百分比
 */
typedef void (^WYUploadProgressHandler)(NSString *key, float percent);


/**
 *    上传完成后的回调函数
 *
 *    @param key  上传时指定的key，原样返回
 *    @param resp 上传成功会返回文件信息，失败为nil; 可以通过此值是否为nil 判断上传结果
 */
typedef void (^WYUploadCompletionHandler)(int statusCode, NSString *key, NSDictionary *resp);


@interface WYUploader : NSObject

/**
 单例构造方法

 @return 上传的管理者
 */
+ (instancetype)uploader;

/**
 上传原图
 
 @param originalImage 原图
 @param progressHandler 上传进度回调函数
 @param complete 上传完成后的回调函数
 */
//- (void)uploadOriginalImage:(UIImage *)originalImage progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete;

/**
 上传缩略图
 
 @param thumbImage 缩略图
 @param progressHandler 上传进度回调函数
 @param complete 上传完成后的回调函数
 */
//- (void)uploadThumbImage:(UIImage *)thumbImage progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete;

/**
 上传视频
 
 @param videoData 视频二进制数据
 @param progressHandler 上传进度回调函数
 @param complete 上传完成后的回调函数
 */
//- (void)uploadVideoWithData:(NSData *)videoData progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete;

/**
 上传视频
 
 @param videoUrl 视频
 @param progressHandler 上传进度回调函数
 @param complete 上传完成后的回调函数
 */
//- (void)uploadVideoWithUrl:(NSString *)videoUrl progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete;

@end
