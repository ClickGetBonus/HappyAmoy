//
//  WYFileTool.m
//  DianDian
//
//  Created by apple on 17/11/14.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYFileTool.h"

#define kChildPath @"Chat/File"

@implementation WYFileTool

#pragma mark - 根据文件路径计算文件尺寸
+ (void)getFileSize:(NSString *)directory completion:(void(^)(NSInteger totalSize))completion {
    
    NSFileManager *fileMgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [fileMgr fileExistsAtPath:directory isDirectory:&isDirectory];
    
    // 如果文件不存在或者不是文件夹要抛出异常
    if (!isExist || !isDirectory) {
        
        NSException *exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        
        [exception raise];
    }
    
    // 开启异步线程计算，防止文件太大计算太久阻塞线程
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        // 获取文件夹下所有的文件路径，包括全部子路径
        NSArray *subPaths = [fileMgr subpathsAtPath:directory];
        
//        WYLog(@"%@",subPaths);
        
        NSInteger totalSize = 0;
        // 遍历所有文件，计算文件大小
        for (NSString *subPath in subPaths) {
            
            // 拼接文件全路径
            NSString *filePath = [directory stringByAppendingPathComponent:subPath];
            
            // 如果包含DS隐藏文件则跳过不计算
            if ([filePath containsString:@".DS"]) continue;
            
            // 判断文件是否是文件夹
            BOOL isDirectory;
            BOOL isExist = [fileMgr fileExistsAtPath:filePath isDirectory:&isDirectory];
            // 如果文件不存在或者是文件夹也要跳过不计算
            if (!isExist || isDirectory) continue;
            // 获取文件属性
            NSDictionary *attr = [fileMgr attributesOfItemAtPath:filePath error:nil];
            
            NSInteger size = [attr fileSize];
            
            totalSize += size;
        }
        
        // 回到主线程刷新UI
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            if (completion) {
                completion(totalSize);
            }
            
        });
        
    });
}

#pragma mark - 删除文件夹下的全部文件
+ (void)removeDirectoryPath:(NSString *)directoryPath {
    
    NSFileManager *mgr = [NSFileManager defaultManager];
    
    BOOL isDirectory;
    BOOL isExist = [mgr fileExistsAtPath:directoryPath isDirectory:&isDirectory];
    
    // 如果文件不存在或者不是文件夹要抛出异常
    if (!isExist || !isDirectory) {
        
        NSException *exception = [NSException exceptionWithName:@"pathError" reason:@"需要传入的是文件夹路径，并且路径要存在！" userInfo:nil];
        
        [exception raise];
    }
    
    // 获取到cache文件夹下面的子文件路径，不包括二级路径
    NSArray *subPaths = [mgr contentsOfDirectoryAtPath:directoryPath error:nil];
    
    for (NSString *subPath in subPaths) {
        // 拼接全路径
        NSString *filePath = [directoryPath stringByAppendingPathComponent:subPath];
        // 删除文件
        [mgr removeItemAtPath:filePath error:nil];
    }
    
}

+ (NSString *)cacheDirectory
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)createPathWithChildPath:(NSString *)childPath
{
    NSString *path = [[self cacheDirectory] stringByAppendingPathComponent:childPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            NSLog(@"create folder failed");
            return nil;
        }
    }
    return path;
}

+ (BOOL)fileExistsAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}

+ (BOOL)removeFileAtPath:(NSString *)path
{
    return [[NSFileManager defaultManager] removeItemAtPath:path error:nil];
}

// 文件路径
+ (NSString *)filePathWithName:(NSString *)fileKey
                       orgName:(NSString *)name
                          type:(NSString *)type
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kChildPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            WYLog(@"create folder failed");
            return nil;
        }
    }
    return [path stringByAppendingPathComponent:[NSString stringWithFormat:@"%@_%@.%@",fileKey,name,type]];
}

// 文件主目录
+ (NSString *)fileMainPath
{
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:kChildPath];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreatDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreatDir) {
            WYLog(@"create folder failed");
            return nil;
        }
    }
    return path;
}


// 返回字节
+ (CGFloat)fileSizeWithPath:(NSString *)path
{
    NSDictionary *outputFileAttributes = [[NSFileManager defaultManager] attributesOfItemAtPath:path error:nil];
    return [outputFileAttributes fileSize]/1024.0;
}

// 小于1024显示KB，否则显示MB
+ (NSString *)filesize:(NSString *)path
{
    CGFloat size = [self fileSizeWithPath:path];
    if ( size > 1000.0) { // 1000kb不好看，所以我就以1000为标准了
        return [NSString stringWithFormat:@"%.1fMB",size/1024.0];
    } else {
        return [NSString stringWithFormat:@"%.1fKB",size];
    }
}

+ (NSString *)fileSizeWithInteger:(NSUInteger)integer
{
    CGFloat size = integer/1024.0;
    if ( size > 1000.0) { // 1000kb不好看，所以我就以1000为标准了
        return [NSString stringWithFormat:@"%.1fMB",size/1024.0];
    } else {
        return [NSString stringWithFormat:@"%.1fKB",size];
    }
}

+ (void)clearUserDefaults
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSDictionary *dic        = [defaults dictionaryRepresentation];
    for (NSString *key in [dic allKeys]) {
        if ([key hasSuffix:@"unread"] || [key hasSuffix:@"current"])
            [defaults removeObjectForKey:key];
        [defaults synchronize];
    }
    [defaults removeObjectForKey:@"chatViewController"];
    [defaults synchronize];
}


// copy file
+ (BOOL)copyFileAtPath:(NSString *)path
                toPath:(NSString *)toPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    BOOL result = [fileManager copyItemAtPath:path toPath:toPath error:&error];
    if (error) {
        WYLog(@"copy file error:%@",error);
    }
    return result;
}


/**
 缓存图片文件的路径

 @param fileName 文件名称

 @return 图片路径
 */
+ (NSString *)imageCachePath:(NSString *)fileName {
    
    NSString *cachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    cachePath = [cachePath stringByAppendingPathComponent:@"Image"];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirExist = [fileManager fileExistsAtPath:cachePath];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            WYLog(@"create folder failed");
            return cachePath;
        }
    }
    
    return [cachePath stringByAppendingPathComponent:fileName];
}

@end
