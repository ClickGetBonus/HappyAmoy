//
//  WYPhotoLibraryManager.m
//  DianDian
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 com.chinajieyin.www. All rights reserved.
//

#import "WYPhotoLibraryManager.h"
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>

@implementation WYPhotoLibraryManager

/**
 保存图片
 
 @param image 待保存的图片
 @param completionBlock 保存图片的回调
 */
+ (void)wy_savePhotoImage:(UIImage *)image completion:(void(^)(UIImage *image, NSError *error))completionBlock {

    /*
     PHAuthorizationStatusNotDetermined,     用户还没有做出选择
     PHAuthorizationStatusDenied,            用户拒绝当前应用访问相册(用户当初点击了"不允许")
     PHAuthorizationStatusAuthorized         用户允许当前应用访问相册(用户当初点击了"好")
     PHAuthorizationStatusRestricted,        因为家长控制, 导致应用无法方法相册(跟用户的选择没有关系)
     */
    
    // 判断授权状态
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted) {
        WYLog(@"无法访问相簿--PHAuthorizationStatusRestricted");
    } else if (status == PHAuthorizationStatusDenied) {
        WYLog(@"无法访问相簿--PHAuthorizationStatusDenied");
    } else if (status == PHAuthorizationStatusAuthorized) {
        WYLog(@"可以访问相簿--PHAuthorizationStatusAuthorized");
        [self saveImage:image completion:completionBlock];
    } else if (status == PHAuthorizationStatusNotDetermined) {
        // 弹框请求用户授权
        WYLog(@"第一次访问--PHAuthorizationStatusNotDetermined");
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            if (status == PHAuthorizationStatusAuthorized) { // 用户点击了好
                [self saveImage:image completion:completionBlock];
            }
        }];
    }
}


/**
 保存图片
 
 @param image 待保存的图片
 @param completionBlock 保存图片的回调
 */
+ (void)saveImage:(UIImage *)image completion:(void(^)(UIImage *image, NSError *error))completionBlock {
    
    __block UIImage *blockImage = image;
    __block NSString *assetId = nil;
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    NSError *error = nil;
    /**
     *
     * iOS 8.0 必须用 performChangesAndWait 同步方法，用 performChanges 异步方法会导致
     * [PHAssetChangeRequest creationRequestForAssetFromImage:blockImage] 创建出来的 PHAssetChangeRequest 为nil
     */
    [library performChangesAndWait:^{
        // 图片的占位标识
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:blockImage].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (error) {
        WYLog(@"保存图片在相机胶卷失败，错误信息：error = %@",error);
        if (completionBlock) {
            completionBlock(blockImage,error);
        }
        return;
    }
    WYLog(@"图片成功保存到相机胶卷");
    if (completionBlock) {
        completionBlock(blockImage,error);
    }
}


/**
 保存图片

 @param image 待保存的图片
 @param assetCollectionName 相册名字，默认为APP名字
 @param completionBlock 保存图片的回调
 */
+ (void)savePhotoImage:(UIImage *)image assetCollectionName:(NSString *)assetCollectionName completion:(void(^)(UIImage *image, NSError *error))completionBlock {
    
    if (assetCollectionName == nil) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        assetCollectionName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if (assetCollectionName == nil) {
            assetCollectionName = @"图片相册";
        }
    }
    
    __block NSString *blockAssetCollectionName = assetCollectionName;
    __block UIImage *blockImage = image;
    __block NSString *assetId = nil;
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    NSError *error = nil;
    /**
     *
     * iOS 8.0 必须用 performChangesAndWait 同步方法，用 performChanges 异步方法会导致
     * [PHAssetChangeRequest creationRequestForAssetFromImage:blockImage] 创建出来的 PHAssetChangeRequest 为nil
     */
    [library performChangesAndWait:^{
        
        // 图片的占位标识
        assetId = [PHAssetChangeRequest creationRequestForAssetFromImage:blockImage].placeholderForCreatedAsset.localIdentifier;
        
    } error:&error];
    
    if (error) {
        WYLog(@"保存图片在相机胶卷失败，错误信息：error = %@",error);
        if (completionBlock) {
            completionBlock(blockImage,error);
        }
        return;
    }
    
    WYLog(@"图片成功保存到相机胶卷");
    
    // 获得相册对象
    // 获取曾经创建过的自定义相册
    PHAssetCollection *createdAssetCollection = nil;
    
    PHFetchResult <PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    for (PHAssetCollection *assetCollection in assetCollections) {
        
        if ([assetCollection.localizedTitle isEqualToString:blockAssetCollectionName]) {
            createdAssetCollection = assetCollection;
            break;
        }
    }
    
    if (createdAssetCollection == nil) { // 之前没有创建过
        // 创建新的相册
        [library performChangesAndWait:^{
            // 这里其实还没创建好相册，调用下面的方法创建只是告诉系统我准备创建相册，并会为你生成一个占位标识，创建完相册之后，你可以根据占位标志找到对应的相册
            assetId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:blockAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
            
        } error:&error];
        
        if (error) {
            WYLog(@"创建自定义相册失败,错误信息：error = %@",error);
            if (completionBlock) {
                completionBlock(blockImage,error);
            }
            return;
        }
    }
    
    // 将图片保存到自定义的相册中
    [library performChangesAndWait:^{
        
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
        
        // 把图片插在第一个位置，这样相册封面就会显示最新的图片
        [request insertAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        // 这句代码只会把图片加在最后
//        [request addAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil]];
        
    } error:&error];
    
    if (error) {
        WYLog(@"图片保存在自定义相册中失败，错误信息：error = %@",error);
    } else {
        WYLog(@"图片保存在自定义相册中成功");
    }
    
    if (completionBlock) {
        completionBlock(blockImage,error);
    }
}


/**
 保存视频

 @param videoUrl 视频路径
 @param assetCollectionName 相册名字，默认为APP名字
 @param completionBlock 保存视频完成后的回调
 */
+ (void)saveVideoWithURL:(NSURL *)videoUrl assetCollectionName:(NSString *)assetCollectionName completion:(void(^)(NSURL *videoUrl, NSError *error))completionBlock {
    
    if (assetCollectionName == nil) {
        
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        assetCollectionName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if (assetCollectionName == nil) {
            assetCollectionName = @"视频相册";
        }
    }
    
    __block NSString *blockAssetCollectionName = assetCollectionName;
    __block NSURL *blockVideoUrl = videoUrl;
    
    PHPhotoLibrary *library = [PHPhotoLibrary sharedPhotoLibrary];
    
    dispatch_async(dispatch_get_main_queue(), ^{
       
        NSError *error = nil;
        __block NSString *assetId = nil;
        __block NSString *assetCollectionId = nil;
        
        // 保存视频到相机胶卷
        [library performChangesAndWait:^{
            assetId = [PHAssetChangeRequest creationRequestForAssetFromVideoAtFileURL:blockVideoUrl].placeholderForCreatedAsset.localIdentifier;
        } error:&error];
        
        if (error) {
            WYLog(@"保存视频失败，错误信息为:%@",error);
            
            if (completionBlock) {
                completionBlock(blockVideoUrl,error);
            }
            
            return ;
        }
        
        // 检查是否已创建过视频相册
        PHAssetCollection *createdAssetCollection = nil;
        PHFetchResult <PHAssetCollection *> *assetCollections = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
        
        for (PHAssetCollection *assetCollection in assetCollections) {
            if ([assetCollection.localizedTitle isEqualToString:blockAssetCollectionName]) {
                createdAssetCollection = assetCollection;
                break;
            }
        }
        
        // 如果没有创建过，就重新创建
        if (createdAssetCollection == nil) {
            
            // 创建自定义相册
            [library performChangesAndWait:^{
                assetCollectionId = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:blockAssetCollectionName].placeholderForCreatedAssetCollection.localIdentifier;
            } error:&error];
            
            if (error) {
                WYLog(@"创建自定义相册失败，错误信息为：%@",error);

                if (completionBlock) {
                    completionBlock(blockVideoUrl,error);
                }
                
                return ;
            }
            
            // 获取刚创建的相册
            createdAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[assetCollectionId] options:nil].firstObject;
        }
        
        // 将视频添加到自定义的相册中
        [library performChangesAndWait:^{
            PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:createdAssetCollection];
            
            // 把视频插在第一个位置，这样相册封面就会显示最新拍摄的视频
            [request insertAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil] atIndexes:[NSIndexSet indexSetWithIndex:0]];
            // 这句代码只会把图片加在最后
//            [request addAssets:[PHAsset fetchAssetsWithLocalIdentifiers:@[assetId] options:nil]];
        } error:&error];
        
        if (error) {
            WYLog(@"视频保存在自定义相册中失败，错误信息：error = %@",error);
        } else {
            WYLog(@"保存视频成功");
        }
        
        if (completionBlock) {
            completionBlock(blockVideoUrl,error);
        }
    });
}



@end
