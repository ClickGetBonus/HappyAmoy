//
//  WYUploader.m
//  QianHong
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "WYUploader.h"
#import "WYUploaderItem.h"
//#import "QN_GTM_Base64.h"
//#import <Qiniu/QiniuSDK.h>
//#import <Qiniu/QN_GTM_Base64.h>

//#import <GTMBase64/GTMBase64.h>
#import <CommonCrypto/CommonDigest.h>
#import <CommonCrypto/CommonHMAC.h>

@interface WYUploader()

@property (copy, nonatomic) NSString *scope;
@property (copy, nonatomic) NSString *accessKey;
@property (copy, nonatomic) NSString *secretKey;
@property (copy, nonatomic) NSString *uploadToken;

//@property (strong, nonatomic) QNUploadManager *QNManager;
@property (strong, nonatomic) NSMutableDictionary *flagDic;
@property (strong, nonatomic) NSMutableArray *uploadTaskArr;
@property (strong, nonatomic) NSMutableDictionary *uploadingTaskDic;


@end

static WYUploader *_instance = nil;

@implementation WYUploader

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [super allocWithZone:zone];
    });
    return _instance;
}

+ (instancetype)uploader {
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[self alloc] init];
    });
    return _instance;
}

#pragma mark - Lazy load

//- (QNUploadManager *)QNManager {
//    
//    if (!_QNManager) {
//        
//        QNConfiguration *config = [QNConfiguration build:^(QNConfigurationBuilder *builder) {
//            builder.zone = [QNFixedZone zone2];
//        }];
//        
//        QNUploadManager *manager = [[QNUploadManager alloc] initWithConfiguration:config];
//        
//        _QNManager = manager;
//    }
//    return _QNManager;
//    
//}
//
//- (NSMutableDictionary *)flagDic {
//    if (!_flagDic) {
//        _flagDic = [[NSMutableDictionary alloc] init];
//    }
//    return _flagDic;
//}
//
//- (NSMutableArray *)uploadTaskArr {
//    if (!_uploadTaskArr) {
//        _uploadTaskArr = [[NSMutableArray alloc] init];
//    }
//    return _uploadTaskArr;
//}
//
//- (NSMutableDictionary *)uploadingTaskDic {
//    if (!_uploadingTaskDic) {
//        _uploadingTaskDic = [[NSMutableDictionary alloc] init];
//    }
//    return _uploadingTaskDic;
//}
//
//#pragma mark - Public method
//
///**
// 上传原图
// 
// @param originalImage 原图
// @param progressHandler 上传进度回调函数
// @param complete 上传完成后的回调函数
// */
//- (void)uploadOriginalImage:(UIImage *)originalImage progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    NSString *fileName = [self getFileName];
//    
//    // 根据路径上传
//    [self uploadWithFilePath:[self getImagePath:originalImage fileName:fileName isThumbImage:NO] fileName:fileName bucketType:[QHUserManager manager].imageTokenItem.bucketName token:[QHUserManager manager].imageTokenItem.upToken progressHandler:progressHandler complete:complete];
//    // 直接上传二进制文件
////    NSData *data = nil;
////    if (UIImagePNGRepresentation(originalImage) == nil) {
////        data = UIImageJPEGRepresentation(originalImage, 1.0);
////    } else {
////        data = UIImagePNGRepresentation(originalImage);
////    }
////
////    [self uploadData:data key:fileName token:[QHUserManager manager].imageTokenItem.upToken progressHandler:progressHandler complete:complete];
//}
//
///**
// 上传缩略图
// 
// @param thumbImage 缩略图
// @param progressHandler 上传进度回调函数
// @param complete 上传完成后的回调函数
// */
//- (void)uploadThumbImage:(UIImage *)thumbImage progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    NSString *fileName = [self getFileName];
//    // 根据路径上传
//    [self uploadWithFilePath:[self getImagePath:[UIImage thumbImageWithImage:thumbImage fileSize:ThumbImageMaxSize] fileName:fileName isThumbImage:YES] fileName:fileName bucketType:[QHUserManager manager].thumbTokenItem.bucketName token:[QHUserManager manager].thumbTokenItem.upToken progressHandler:progressHandler complete:complete];
//    // 直接上传二进制文件
////    NSData *data = nil;
////    if (UIImagePNGRepresentation(thumbImage) == nil) {
////        data = UIImageJPEGRepresentation(thumbImage, 1.0);
////    } else {
////        data = UIImagePNGRepresentation(thumbImage);
////    }
////
////    [self uploadData:data key:fileName token:[QHUserManager manager].imageTokenItem.upToken progressHandler:progressHandler complete:complete];
//
//}
//
///**
// 上传图片，默认原图和缩略图都会上传，这个方法已经不用了，因为原图和缩略图需要分开上传
//
// @param image 图片
// @param progressHandler 上传进度回调函数
// @param complete 上传完成后的回调函数
// */
//- (void)uploadImage:(UIImage *)image progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    NSString *fileName = [self getFileName];
//
//    [self uploadWithFilePath:[self getImagePath:image fileName:fileName isThumbImage:NO] fileName:fileName bucketType:[QHUserManager manager].imageTokenItem.bucketName token:[QHUserManager manager].imageTokenItem.upToken progressHandler:progressHandler complete:complete];
//    
//    [self uploadWithFilePath:[self getImagePath:[UIImage thumbImageWithImage:image fileSize:ThumbImageMaxSize] fileName:fileName isThumbImage:YES] fileName:fileName bucketType:[QHUserManager manager].thumbTokenItem.bucketName token:[QHUserManager manager].thumbTokenItem.upToken progressHandler:progressHandler complete:complete];
//}
//
///**
// 根据图片路径上传
//
// @param filePath 图片路径
// @param bucketType 上传到七牛的空间
// */
//- (void)uploadWithFilePath:(NSString *)filePath fileName:(NSString *)fileName bucketType:(NSString *)bucketType token:(NSString *)token progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    if ([NSString isEmpty:filePath]) {
//        WYLog(@"图片路径为空");
//        return;
//    }
//    
//    if ([self fileWithPath:filePath]) {
//        // 任务已经存在 继续上传
//        [self continueUploadWithFilePath:filePath progressHandler:progressHandler complete:complete];
//        return;
//    }
//    
//    // 请求 token 、 key
//    WYUploaderItem *item = [[WYUploaderItem alloc] init];
//    item.filePath = filePath;
//    item.key = fileName;
//    item.token = token;
//    [self.uploadTaskArr addObject:item];
//    [self uploadObject:filePath key:fileName token:token progressHandler:progressHandler complete:complete];
//}
//
///**
// 上传视频
// 
// @param videoData 视频二进制数据
// @param progressHandler 上传进度回调函数
// @param complete 上传完成后的回调函数
// */
//- (void)uploadVideoWithData:(NSData *)videoData progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    NSString *fileName = [self getFileName];
//    
//    [self uploadData:videoData key:fileName token:[QHUserManager manager].videoTokenItem.upToken progressHandler:progressHandler complete:complete];
//}
//
///**
// 上传视频
// 
// @param videoUrl 视频
// @param progressHandler 上传进度回调函数
// @param complete 上传完成后的回调函数
// */
//- (void)uploadVideoWithUrl:(NSString *)videoUrl progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    NSString *fileName = [self getFileName];
//    
//    [self uploadObject:videoUrl key:fileName token:[QHUserManager manager].videoTokenItem.upToken progressHandler:progressHandler complete:complete];
//}
//
//
//- (void)uploadObject:(NSString *)filePath key:(NSString *)key token:(NSString *)token  progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    [self.flagDic setValue:@(0) forKey:filePath];
//    
//    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        if (progressHandler) {
//            progressHandler(key, percent);
//        }
//        if (percent >= 1) {
//            WYLog(@"上传完毕");
//            [self removeTaskWithFilePath:filePath];
//        }
//        WYLog(@"qnKey = %@ , qnResp = %f",key,percent);
//        [self.uploadingTaskDic setObject:@(1) forKey:filePath];
//    } params:nil checkCrc:NO cancellationSignal:^BOOL{
//        return NO;
//    }];
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    if ([NSString isEmpty:filePath]) {
//        return;
//    }
//    
//    [self.QNManager putFile:filePath key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        if (complete) {
//            complete(info.statusCode, key, resp);
//        }
//        WYLog(@"qnInfo = %@ , qnKey = %@ , qnResp = %@",info,key,resp);
//    } option:opt];
//    
//}
//
//
//- (void)uploadData:(NSData *)data key:(NSString *)key token:(NSString *)token  progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    QNUploadOption *opt = [[QNUploadOption alloc] initWithMime:nil progressHandler:^(NSString *key, float percent) {
//        if (progressHandler) {
//            progressHandler(key, percent);
//        }
//        WYLog(@"qnKey = %@ , qnResp = %f",key,percent);
//    } params:nil checkCrc:NO cancellationSignal:^BOOL{
//        return NO;
//    }];
//    
//    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
//    
//    if (!data) {
//        return;
//    }
//    
//    [self.QNManager putData:data key:key token:token complete:^(QNResponseInfo *info, NSString *key, NSDictionary *resp) {
//        if (complete) {
//            complete(info.statusCode, key, resp);
//        }
//        WYLog(@"qnInfo = %@ , qnKey = %@ , qnResp = %@",info,key,resp);
//    } option:opt];
//    
//}
//
//
//#pragma mark - Private method
//
//// 获取上传文件名称
//- (NSString *)getFileName {
//    
////    NSString *currentTime = [NSString getCurrentTimeWithDateFormat:@"yyyyMMddHHmm"];
////
////    NSString *randomString = [NSString returnRandomStringWithCount:12 type:1];
//    
//    NSString *fileName = [NSString stringWithFormat:@"%@%@%@%@%@%@",[NSString returnRandomStringWithCount:4 type:1],[NSString getCurrentTimeWithDateFormat:@"yyyy"],[NSString returnRandomStringWithCount:4 type:1],[NSString getCurrentTimeWithDateFormat:@"MMdd"],[NSString returnRandomStringWithCount:4 type:1],[NSString getCurrentTimeWithDateFormat:@"HHmm"]];
//    
//    WYLog(@"fileName = %@",fileName);
//    
//    return fileName;
//}
//
//- (WYUploaderItem *)fileWithPath:(NSString *)filePath {
//    
//    for (WYUploaderItem *item in self.uploadTaskArr) {
//        if ([item.filePath isEqualToString:filePath]) {
//            return item;
//        }
//    }
//    return nil;
//}
//
//// 继续上传
//- (void)continueUploadWithFilePath:(NSString *)filePath progressHandler:(WYUploadProgressHandler)progressHandler complete:(WYUploadCompletionHandler)complete {
//    
//    [self.flagDic setObject:@0 forKey:filePath];
//    WYUploaderItem *item = [self fileWithPath:filePath];
//    if (item == nil) {
//        return;
//    }
//    WYLog(@"继续上传 filePath = %@,token = %@",item.filePath,item.token);
//    [self uploadObject:filePath key:item.key token:item.token progressHandler:progressHandler complete:complete];
//}
//
//// 移除上传任务
//- (void)removeTaskWithFilePath:(NSString *)filePath {
//    
//    WYUploaderItem *item = [self fileWithPath:filePath];
//
//    if (!item) {
//        return;
//    }
//    [self.uploadTaskArr removeObject:item];
//}
//
////照片获取本地路径转换
//- (NSString *)getImagePath:(UIImage *)image fileName:(NSString *)fileName isThumbImage:(BOOL)isThumbImage {
//    
//    if (image == nil) {
//        return @"";
//    }
//    
//    NSString *filePath = nil;
//    NSData *data = nil;
//    if (UIImagePNGRepresentation(image) == nil) {
//        data = UIImageJPEGRepresentation(image, 1.0);
//    } else {
//        data = UIImagePNGRepresentation(image);
//    }
//
//    //图片保存的路径
//    //这里将图片放在沙盒的 caches 文件夹中
//    NSString *cachePath = [kCachePath stringByAppendingPathComponent:UploadOriginalImagePath];
//    
//    if (isThumbImage) {
//        cachePath = [kCachePath stringByAppendingPathComponent:UploadThumbImagePath];
//    }
//    
//    //文件管理器
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    
//    //把刚刚图片转换的data对象拷贝至沙盒中
//    [fileManager createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:nil];
//    NSString *imagePath = [[NSString alloc] initWithFormat:@"%@.png",fileName];
//    
//    [fileManager createFileAtPath:[cachePath stringByAppendingPathComponent:imagePath] contents:data attributes:nil];
//    
//    //得到选择后沙盒中图片的完整路径
//    filePath = [cachePath stringByAppendingPathComponent:imagePath];
//    
//    WYLog(@"文件上传的路径 = %@",filePath);
//    
//    return filePath;
//}
//
//// 生成 Token
//- (NSString *)makeToken:(NSString *)accessKey secretKey:(NSString *)secretKey bucket:(NSString *)bucket key:(NSString *)key
//{
//    const char *secretKeyStr = [secretKey UTF8String];
//    
//    NSString *policy = [self marshal: bucket key:key];
//    
//    NSData *policyData = [policy dataUsingEncoding:NSUTF8StringEncoding];
//
////    [QN_GTM_Base64 stringByWebSafeEncodingData:policyData padded:true];
//    
//    NSString *encodedPolicy = [QN_GTM_Base64 stringByWebSafeEncodingData:policyData padded:TRUE];
//    const char *encodedPolicyStr = [encodedPolicy cStringUsingEncoding:NSUTF8StringEncoding];
//    
//    char digestStr[CC_SHA1_DIGEST_LENGTH];
//    bzero(digestStr, 0);
//    
//    CCHmac(kCCHmacAlgSHA1, secretKeyStr, strlen(secretKeyStr), encodedPolicyStr, strlen(encodedPolicyStr), digestStr);
//    
//    NSString *encodedDigest = [QN_GTM_Base64 stringByWebSafeEncodingBytes:digestStr length:CC_SHA1_DIGEST_LENGTH padded:TRUE];
//    
//    NSString *token = [NSString stringWithFormat:@"%@:%@:%@",  accessKey, encodedDigest, encodedPolicy];
//    
//    WYLog(@"token = %@",token);
//    
//    return token;//得到了token
//}
//
//- (NSString *)marshal:(NSString *)bucket key:(NSString *)key {
//    
//    time_t deadline;
//    
//    time(&deadline);//返回当前系统时间
//    
//    //@property (nonatomic , assign) int expires; 怎么定义随你...
//    
////    deadline += (_expires > 0) ? _expires : 3600; // +3600秒,即默认token保存1小时.
//    
//    deadline += 3600; // +3600秒,即默认token保存1小时.
//    
//    NSNumber *deadlineNumber = [NSNumber numberWithLongLong:deadline];
//    
//    NSMutableDictionary *dic = [NSMutableDictionary dictionary];
//    
//    //images是我开辟的公共空间名（即bucket），aaa是文件的key，
//    
//    //按七牛“上传策略”的描述：    <bucket>:<key>，表示只允许用户上传指定key的文件。在这种格式下文件默认允许“修改”，若已存在同名资源则会被覆盖。如果只希望上传指定key的文件，并且不允许修改，那么可以将下面的 insertOnly 属性值设为 1。
//    
//    //所以如果参数只传users的话，下次上传key还是aaa的文件会提示存在同名文件，不能上传。
//    
//    //传images:aaa的话，可以覆盖更新，但实测延迟较长，我上传同名新文件上去，下载下来的还是老文件。
//    
//    NSString *value = [NSString stringWithFormat:@"%@:%@", bucket, key];
//    
//    [dic setObject:value forKey:@"scope"];//根据
//    
//    [dic setObject:deadlineNumber forKey:@"deadline"];
//    
//    NSString *json = [dic mj_JSONString];
//    
//    return json;
//}

@end
