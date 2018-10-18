//
//  WYFileTool.h
//  DianDian
//
//  Created by apple on 17/11/14.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYFileTool : NSObject

/**
 根据文件夹路径计算文件尺寸
 
 @param directory  文件夹路径
 @param completion 计算完成后的回调
 */
+ (void)getFileSize:(NSString *)directory completion:(void(^)(NSInteger totalSize))completion;

#pragma mark - 删除文件夹下的全部文件

/**
 删除文件夹下的全部文件
 
 @param directoryPath 文件夹路径
 */
+ (void)removeDirectoryPath:(NSString *)directoryPath;


+ (NSString *)cacheDirectory;

// 根据子路径创建路径
+ (NSString *)createPathWithChildPath:(NSString *)childPath;

// 是否存在该路径
+ (BOOL)fileExistsAtPath:(NSString *)path;

// 删除路径下的文件
+ (BOOL)removeFileAtPath:(NSString *)path;

// 文件路径
+ (NSString *)filePathWithName:(NSString *)fileKey
                       orgName:(NSString *)name
                          type:(NSString *)type;

// 文件主目录
+ (NSString *)fileMainPath;

// 文件大小
+ (CGFloat)fileSizeWithPath:(NSString *)path;

// 小于1024显示KB，否则显示MB
+ (NSString *)filesize:(NSString *)path;
+ (NSString *)fileSizeWithInteger:(NSUInteger)integer;

// 清除NSUserDefaults
+ (void)clearUserDefaults;

// copy file
+ (BOOL)copyFileAtPath:(NSString *)path
                toPath:(NSString *)toPath;

/**
 缓存图片文件的路径
 
 @param fileName 文件名称
 
 @return 图片路径
 */
+ (NSString *)imageCachePath:(NSString *)fileName;

@end
