//
//  UIImage+Image.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/8.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIImage+Image.h"
#import <Photos/Photos.h>

@implementation UIImage (Image)


/**
 快速生成不被渲染的图片

 @param imageNamed 图片名称

 @return 不被渲染的图片
 */
+ (UIImage *)imageOriginalWithNamed:(NSString *)imageNamed {
    
    UIImage *image = [UIImage imageNamed:imageNamed];
    
    return [image imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
}

/**
 根据颜色生成图片
 
 @param color 颜色
 
 @return 图片
 */
+ (UIImage *)imageWithColor:(UIColor *)color {
    
    CGRect rect = CGRectMake(0.0f, 0.0f, 1.0f, 1.0f);
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return theImage;
}

/**
 裁剪圆角图片

 @param image 需要裁剪的图片
 @param cornerRadius 圆角大小
 @return 返回裁剪后的圆角图片
 */
+ (UIImage *)clipImageWithImage:(UIImage *)image cornerRadius:(CGFloat)cornerRadius {
    
    if (cornerRadius == 0) {
        return image;
    }
    int w = image.size.width * image.scale;
    int h = image.size.height * image.scale;
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(w, h), false, 0);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextMoveToPoint(context, 0, cornerRadius);
    CGContextAddArcToPoint(context, 0, 0, cornerRadius, 0, cornerRadius);
    CGContextAddLineToPoint(context, w-cornerRadius, 0);
    CGContextAddArcToPoint(context, w, 0, w, cornerRadius, cornerRadius);
    CGContextAddLineToPoint(context, w, h-cornerRadius);
    CGContextAddArcToPoint(context, w, h, w-cornerRadius, h, cornerRadius);
    CGContextAddLineToPoint(context, cornerRadius, h);
    CGContextAddArcToPoint(context, 0, h, 0, h-cornerRadius, cornerRadius);
    CGContextAddLineToPoint(context, 0, cornerRadius);
    CGContextClosePath(context);
    
    CGContextClip(context);     // 先裁剪 context，再画图，就会在裁剪后的 path 中画
    [image drawInRect:CGRectMake(0, 0, w, h)];       // 画图
    CGContextDrawPath(context, kCGPathFill);
    
    UIImage *ret = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return ret;
}

/**
 裁剪圆形图片

 @param image 需要裁剪的图片

 @return 返回裁剪后的圆形图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image {
    
    // 获取图片的实际像素大小
    CGSize imageSize = [self getImageRealPixelWithImage:image];

    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;
    
    // 最后一个参数scale：比例因数，点与像素的比例，0会自适配
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    // 描述裁剪区域
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithOvalInRect:CGRectMake(0, 0, imageW,  imageH)];
    // 设置裁剪区域
    [bezierPath addClip];
    // 画图片
    [image drawInRect:CGRectMake(0, 0, imageW, imageH)];
    // 获取裁剪后的图片
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
}


/**
 裁剪圆形图片（带边框）

 @param image       需要裁剪的图片
 @param borderWidth 边框宽度
 @param borderColor 边框颜色

 @return 裁剪后的图片
 */
+ (UIImage *)circleImageWithImage:(UIImage *)image borderWidth:(CGFloat)borderWidth borderColor:(UIColor *)borderColor {
    
    // 获取图片的实际像素大小
    CGSize imageSize = [self getImageRealPixelWithImage:image];
    
    CGFloat imageW = imageSize.width;
    CGFloat imageH = imageSize.height;

    imageW = ((imageW > imageH) ? imageH : imageW) + 2 * borderWidth;
    imageH = ((imageW > imageH) ? imageH : imageW) + 2 * borderWidth;
    imageSize = CGSizeMake(imageW, imageH);
    
    UIGraphicsBeginImageContextWithOptions(imageSize, NO, 0);
    
    // 取的当前的上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画边框（大圆）
    [borderColor set];
    CGFloat bigRadious = imageW * 0.5;
    CGFloat centerX = bigRadious;
    CGFloat centerY = bigRadious;
    
    CGContextAddArc(ctx, centerX, centerY, bigRadious, 0, M_PI * 2, 0);
    
    CGContextFillPath(ctx);
    
    // 小圆
    CGFloat smallRadious = bigRadious - borderWidth;
    CGContextAddArc(ctx, centerX, centerY, smallRadious, 0, M_PI * 2, 0);
    // 裁剪
    CGContextClip(ctx);
    
    // 画图
    [image drawInRect:CGRectMake(borderWidth, borderWidth, (imageSize.width > imageSize.height) ? imageSize.height : imageSize.width, (imageSize.width > imageSize.height) ? imageSize.height : imageSize.width)];
    
    UIImage *circleImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    
    return circleImage;
}

/**
 压缩个人头像为 具体 的尺寸

 @param size 尺寸大小
 @return 压缩后的头像
 */
- (UIImage *)imageWithHeadImage:(CGFloat)size {
    
    return [self imageWithImage:self scaledToSize:CGSizeMake(size, size)];
    
}


/**
 把图片压缩为对应的尺寸

 @param image   需要压缩的图片
 @param newSize 压缩的尺寸

 @return 压缩后的图片
 */
- (UIImage *)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize {
    
    UIGraphicsBeginImageContext(newSize);
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return newImage;
//    return UIImageJPEGRepresentation(newImage, 0.8);
}


/**
 把图片转为指定大小的二进制，然后二进制再经过base64编码

 @param image 需要转换的图片

 @return 返回字符串
 */
+ (NSString *)imageStreamWithImage:(UIImage *)image fileSize:(CGFloat)fileSize{
    
    // 经过压缩后的二进制数据
//    NSData *fileData = UIImageJPEGRepresentation(image, 0.1);
    
    NSData *fileData = [self compressImage:image fileSize:fileSize];
    if (fileData == nil) {
        WYLog(@"压缩的二进制不为空");
    }
    // 上传图片的大小
    NSInteger length = [fileData length]/1000;
    WYLog(@"图片的大小:%ldKB",(long)length);
    
    // 原图的大小
    //        NSInteger originLength = [UIImagePNGRepresentation(orignalImage) length]/1000;
    //        WYLog(@"原来图片的大小length:%ld",(long)originLength);
    
    // 把二进制数据经过base64转码变成字符串，因为二进制数据直接放在字典里面会有问题
    NSString *base64DataStr = [fileData base64EncodedStringWithOptions:0];
    
    // 将json字符串进行处理，否则上传到服务器后特殊字符会被过滤，因为包含有特殊字符
    NSString*  baseString=(__bridge NSString*)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, (CFStringRef) base64DataStr, NULL, CFSTR(":/?#[]@!$&’()*+,;="), kCFStringEncodingUTF8);
    
    return baseString;
}

/**
 把二进制字符串转为图片

 @param dataString 二进制字符串

 @return 图片
 */
+ (UIImage *)imageWithDataString:(NSString *)dataString {
    
    if (dataString == nil) {
        return [[UIImage alloc] init];
    }
    
    // 把请求回来的二进制字符串先中文空格字符解码stringByRemovingPercentEncoding
    NSString *imageDataStr = [dataString stringByRemovingPercentEncoding];
    
    // 把二进制字符串用base64解码，因为上传的时候是经过了base64加密的
    NSData *imageData = [[NSData alloc] initWithBase64EncodedString:imageDataStr options:0];
    
    return [UIImage imageWithData:imageData];
    
}


/**
 压图片质量
 
 @param image image
 @return Data
 */
+ (NSData *)compressImage:(UIImage *)image fileSize:(CGFloat)fileSize
{
    if (!image) {
        return nil;
    }
    // 把图片大小控制在100kb
    CGFloat maxFileSize = fileSize * 1024;
    
    NSData *compressedData = UIImageJPEGRepresentation(image, 1);
    
    WYLog(@"图片的原始大小:%ldKB",(long)[compressedData length]/1000);

    if (compressedData.length < maxFileSize) { // 如果原图已经符合条件了，就不压缩质量了
        return compressedData;
    }
    
    CGFloat compression = 0.5f;
    // 压缩图片质量
    compressedData = UIImageJPEGRepresentation(image, compression);
    
    if (compressedData.length < maxFileSize) { // 如果已经压缩到符合条件了，就不继续压缩尺寸了，
        return compressedData;
    }
    
    UIImage *resultImage = [UIImage imageWithData:compressedData];

    compression = 0.5f;
    
    // Compress by size
    NSUInteger lastDataLength = 0;
    // 压缩图片尺寸
    while (compressedData.length > maxFileSize && compressedData.length != lastDataLength) {
        lastDataLength = compressedData.length;
        CGFloat ratio = (CGFloat)maxFileSize / compressedData.length;
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        compressedData = UIImageJPEGRepresentation(resultImage, compression);
    }
    
    return compressedData;
    
//    while ([compressedData length] > maxFileSize) {
//        compression *= 0.9;
//        compressedData = UIImageJPEGRepresentation([[self class] compressImage:image newWidth:image.size.width*compression], compression);
    
//    }
    
    
//    return compressedData;
}

/**
 *  等比缩放本图片大小
 *
 *  @param newImageWidth 缩放后图片宽度，像素为单位
 *
 *  @return self-->(image)
 */
+ (UIImage *)compressImage:(UIImage *)image newWidth:(CGFloat)newImageWidth
{
    if (!image) return nil;
    float imageWidth = image.size.width;
    float imageHeight = image.size.height;
    float width = newImageWidth;
    float height = image.size.height/(image.size.width/width);
    
    float widthScale = imageWidth /width;
    float heightScale = imageHeight /height;
    
    // 创建一个bitmap的context
    // 并把它设置成为当前正在使用的context
    UIGraphicsBeginImageContext(CGSizeMake(width, height));
    
    if (widthScale > heightScale) {
        [image drawInRect:CGRectMake(0, 0, imageWidth /heightScale , height)];
    }
    else {
        [image drawInRect:CGRectMake(0, 0, width , imageHeight /widthScale)];
    }
    
    // 从当前context中创建一个改变大小后的图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return newImage;
}

/**
 返回正常角度的图片

 @param aImage 被旋转处理过了的图片

 @return 返回正常角度的图片
 */
+ (UIImage *)fixOrientation:(UIImage *)aImage {
    
    // No-op if the orientation is already correct
    if (aImage.imageOrientation ==UIImageOrientationUp)
        return aImage;
    
    // We need to calculate the proper transformation to make the image upright.
    // We do it in 2 steps: Rotate if Left/Right/Down, and then flip if Mirrored.
    CGAffineTransform transform =CGAffineTransformIdentity;
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width, aImage.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, aImage.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        default:
            break;
    }
    
    switch (aImage.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.width,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, aImage.size.height,0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        default:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx =CGBitmapContextCreate(NULL, aImage.size.width, aImage.size.height,
                                            CGImageGetBitsPerComponent(aImage.CGImage),0,
                                            CGImageGetColorSpace(aImage.CGImage),
                                            CGImageGetBitmapInfo(aImage.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (aImage.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.height,aImage.size.width), aImage.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx,CGRectMake(0,0,aImage.size.width,aImage.size.height), aImage.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg =CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
}

#pragma mark - 保存图片到自定义相册
- (void)savePhotoToCustomAlbum {
    // 保存图片在相机胶卷，也就是系统默认的相册
    PHAsset *asset = [self savePhotoToSystemAlbum];
    
    if (asset == nil) {
        WYLog(@"保存图片失败");
        return;
    }
    
    // 自定义相册，把图片放在我们自定义的相册，以便寻找，为了用户体验
    PHAssetCollection *assetCollection = [self createPhotoCollection];
    
    if (assetCollection == nil) {// 创建相册失败
        WYLog(@"创建项目相册失败");
        return;
    }
    
    NSError *error = nil;
    
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        
        PHAssetCollectionChangeRequest *request = [PHAssetCollectionChangeRequest changeRequestForAssetCollection:assetCollection];
        // 把图片插在一个位置，这样相册封面就会显示最新的图片
        [request insertAssets:@[asset] atIndexes:[NSIndexSet indexSetWithIndex:0]];
        
    } error:&error];
    
    if (!error) {
        WYLog(@"保存图片在项目相册成功");
    }
}

#pragma mark - 保存图片到相机胶卷
- (PHAsset *)savePhotoToSystemAlbum {
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusRestricted ||
        status == PHAuthorizationStatusDenied) {
        // 无权限操作相册
        return nil;
    }
    
    __block PHAsset *asset = nil;
    
    __block NSString *identifier = nil;
    
    // 使用PHPhoto框架保存图片到相机胶卷有两种方法，一个异步操作，一个同步操作
    
    // 同步操作
    NSError *error = nil;
    [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
        // 图片的占位标识
        identifier = [PHAssetChangeRequest creationRequestForAssetFromImage:self].placeholderForCreatedAsset.localIdentifier;
    } error:&error];
    
    if (!error) {
        // 根据图片标识得到相应的图片
        asset = [PHAsset fetchAssetsWithLocalIdentifiers:@[identifier] options:nil].firstObject;
    }
    return asset;
    
    // 异步操作
    
    //    [[PHPhotoLibrary sharedPhotoLibrary] performChanges:^{
    //        // 保存图片的操作必须在这里或者下面的同步方法执行
    //        identifier = [PHAssetChangeRequest creationRequestForAssetFromImage:self.imageView.image].placeholderForCreatedAsset.localIdentifier;
    //
    //    } completionHandler:^(BOOL success, NSError * _Nullable error) {
    //
    //        if (success) {
    //            asset = [PHAsset fetchAssetsWithBurstIdentifier:identifier options:nil].firstObject;
    //        }
    //
    //    }];
    
}

#pragma mark - 创建自定义相册
- (PHAssetCollection *)createPhotoCollection {
    
    // 获取当前项目名称
    NSString *appName = [NSBundle mainBundle].infoDictionary[(NSString *)kCFBundleNameKey];
    
    WYLog(@"项目名称 = %@",appName);
    
    // 获取所有的自定义相册
    PHFetchResult<PHAssetCollection *> * fetchResult = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    
    PHAssetCollection *myAssetCollection = nil;
    
    // 遍历所有的自定义相册，查看当前项目之前是否已经创建过相册
    for (PHAssetCollection *collection in fetchResult) {
        
        if ([collection.localizedTitle isEqualToString:appName]) {
            myAssetCollection = collection;
            return myAssetCollection;
        }
    }
    
    if (myAssetCollection == nil) { // 如果之前没有创建过，则现在新建一个
        
        NSError *error = nil;
        
        __block NSString *identifier = nil;
        
        [[PHPhotoLibrary sharedPhotoLibrary] performChangesAndWait:^{
            // 这里其实还没创建好相册，调用下面的方法创建只是告诉系统我准备创建相册，并会为你生成一个占位标识，创建完相册之后，你可以根据占位标志找到对应的相册
            identifier = [PHAssetCollectionChangeRequest creationRequestForAssetCollectionWithTitle:appName].placeholderForCreatedAssetCollection.localIdentifier;
            
        } error:&error];
        
        if (!error) { // 创建相册失败
            // 根据占位标志找到对应的相册
            myAssetCollection = [PHAssetCollection fetchAssetCollectionsWithLocalIdentifiers:@[identifier] options:nil].firstObject;
            
            return myAssetCollection;
            
        }
    }
    WYLog(@"项目相册：%@",myAssetCollection);
    return myAssetCollection;
    
}

//获取视频的第一帧截图, 返回UIImage
//需要导入AVFoundation.h
//- (UIImage*)getVideoPreViewImageWithPath:(NSURL *)videoPath
//{
//    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoPath options:nil];
//    
//    AVAssetImageGenerator *gen         = [[AVAssetImageGenerator alloc] initWithAsset:asset];
//    gen.appliesPreferredTrackTransform = YES;
//    
//    CMTime time      = CMTimeMakeWithSeconds(0.0, 600);
//    NSError *error   = nil;
//    
//    CMTime actualTime;
//    CGImageRef image = [gen copyCGImageAtTime:time actualTime:&actualTime error:&error];
//    UIImage *img     = [[UIImage alloc] initWithCGImage:image];
//    
//    return img;
//}


/**
 获取视频的第一帧截图

 @param videoPath 视频路径

 @return 视频的第一帧截图
 */
+ (UIImage *)getVideoPreViewImageWithVideoPath:(NSString *)videoPath {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];

    NSParameterAssert(asset);
    
    AVAssetImageGenerator *assetImageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:asset];
    
    assetImageGenerator.appliesPreferredTrackTransform = YES;
    assetImageGenerator.apertureMode = AVAssetImageGeneratorApertureModeEncodedPixels;
    
    CGImageRef thumbnailImageRef = NULL;
    
    CFTimeInterval thumbnailImageTime = 0;
    
    NSError *thumbnailImageGenerationError = nil;
    
    thumbnailImageRef = [assetImageGenerator copyCGImageAtTime:CMTimeMake(thumbnailImageTime, 60) actualTime:NULL error:&thumbnailImageGenerationError];
    
    if (!thumbnailImageRef) {
        return nil;
    }
    UIImage *thumbnailImage = thumbnailImageRef ? [[UIImage alloc] initWithCGImage:thumbnailImageRef] : nil;
    
    CGImageRelease(thumbnailImageRef);
    
    return thumbnailImage;
}

// 腾讯云SDK 使用的视频截图
- (UIImage *)snapVideoImageWithVideoPath:(NSString *)videoPath {
    //视频截图
    AVURLAsset *urlAsset = [[AVURLAsset alloc] initWithURL:[NSURL fileURLWithPath:videoPath] options:nil];
    AVAssetImageGenerator *imageGenerator = [[AVAssetImageGenerator alloc] initWithAsset:urlAsset];
    imageGenerator.appliesPreferredTrackTransform = YES;    // 截图的时候调整到正确的方向
    CMTime time = CMTimeMakeWithSeconds(1.0, 30);   // 1.0为截取视频1.0秒处的图片，30为每秒30帧
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:time actualTime:nil error:nil];
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    
    UIGraphicsBeginImageContext(CGSizeMake(240, 320));
    // 绘制改变大小的图片
    [image drawInRect:CGRectMake(0,0, 240, 320)];
    // 从当前context中创建一个改变大小后的图片
    UIImage* scaledImage =UIGraphicsGetImageFromCurrentImageContext();
    // 使当前的context出堆栈
    UIGraphicsEndImageContext();
    
    return scaledImage;
}

/**
 从图片中按默认的位置大小截取图片的一部分，默认截取中间部分的图片，截取出来的图片是正方形
 
 @param image 原始的图片
 @return 截取后的图片
 */
+ (UIImage *)cropSquareImageWithImage:(UIImage *)image {
    
    if (image) {
        // 获取图片的实际像素大小
        CGSize imageSize = [self getImageRealPixelWithImage:image];

        // 需要裁剪图片，以防被压缩变形
        if (imageSize.width != imageSize.height) { // 宽高一样的不用裁剪
            if (image.size.width > image.size.height) {
                image = [self cropImageWithImage:image cropRect:CGRectMake((imageSize.width -  imageSize.height) / 2, 0, imageSize.height, imageSize.height)];
            } else if (imageSize.height > imageSize.width) {
                image = [self cropImageWithImage:image cropRect:CGRectMake(0, (imageSize.height -  imageSize.width) / 2, imageSize.width, imageSize.width)];
            }
        }
    } else {
        image = [[UIImage alloc] init];
    }
    
    return image;
}

/**
 根据imageView的尺寸截取不变形压缩的图片
 
 @param image 原图
 @param imageView imageView
 @return 不变形的图片
 */
+ (UIImage *)scaleAcceptFitWithImage:(UIImage *)image imageView:(UIImageView *)imageView {
   
    return [self scaleAcceptFitWithImage:image imageViewSize:imageView.size];
}

/**
 根据imageView的尺寸截取不变形压缩的图片
 
 @param image 原图
 @param imageViewSize 容器的尺寸
 @return 不变形的图片
 */
+ (UIImage *)scaleAcceptFitWithImage:(UIImage *)image imageViewSize:(CGSize)imageViewSize {
    
    // 获取图片的实际像素大小
    CGSize imageSize = [self getImageRealPixelWithImage:image];
    
    CGFloat imageW = imageViewSize.width;
    CGFloat imageH = imageViewSize.height;
    
    if (imageW == 0) { // 如果imageView的宽高为0，则设置默认值
        imageW = SCREEN_WIDTH / 2.5;
        imageH = imageW * 4 / 5;
    }
    
    CGFloat xScale = imageSize.width / imageW;
    CGFloat yScale = imageSize.height / imageH;
    
    if (xScale > yScale) {
        image = [UIImage cropImageWithImage:image cropRect:CGRectMake((imageSize.width - yScale * imageW) * 0.5, 0, yScale * imageW, imageSize.height)];
    } else if (xScale < yScale) {
        image = [UIImage cropImageWithImage:image cropRect:CGRectMake(0 , (imageSize.height - xScale * imageH) * 0.5, imageSize.width, xScale * imageH)];
    }
    return image;
}

/**
 *从图片中按指定的位置大小截取图片的一部分
 * UIImage image 原始的图片
 * CGRect rect 要截取的区域
 */
+ (UIImage *)cropImageWithImage:(UIImage *)image cropRect:(CGRect)rect {
    
    //将UIImage转换成CGImageRef
    CGImageRef sourceImageRef = [image CGImage];
    
    //按照给定的矩形区域进行剪裁
    CGImageRef newImageRef = CGImageCreateWithImageInRect(sourceImageRef, rect);
    
    //将CGImageRef转换成UIImage
    UIImage *newImage = [UIImage imageWithCGImage:newImageRef];
    
    //返回剪裁后的图片
    return newImage;
}


/**
 取图片的实际像素大小

 @param image 图片
 @return 图片的实际像素大小
 */
+ (CGSize)getImageRealPixelWithImage:(UIImage *)image {
   
    CGImageRef imageRef = [image CGImage];
    //这个size就是实际图片的像素大小
    CGSize imageSize = CGSizeMake(CGImageGetWidth(imageRef), CGImageGetHeight(imageRef));

    return imageSize;
}

/**
 保存图片

 @param image 图片
 @param fileName 图片名称
 @param pathComponent 图片缓存路径
 */
+ (void)saveImage:(UIImage *)image fileName:(NSString *)fileName pathComponent:(NSString *)pathComponent {
    
    if (!image) {
        return;
    }
    
//    NSData *fileData = UIImagePNGRepresentation(image);
    NSData *fileData = UIImageJPEGRepresentation(image, 1.0);

    // 图片名称
    fileName = [NSString stringWithFormat:@"%@%@",fileName,CacheImageType];
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [chachePath stringByAppendingPathComponent:pathComponent];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            WYLog(@"create folder failed");
            return ;
        }
    }
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    BOOL success = [fileData writeToFile:filePath atomically:NO];
    
    if (success) {
        WYLog(@"保存图片成功");
    } else {
        WYLog(@"保存图片失败");
    }
}

/**
 根据图片名称和图片路径获取缓存的图片
 
 @param pathComponent 图片缓存路径
 @param fileName 图片名称
 @return 图片
 */
+ (UIImage *)getImageWithPathComponent:(NSString *)pathComponent fileName:(NSString *)fileName {
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [chachePath stringByAppendingPathComponent:pathComponent];

    // 图片名称
    fileName = [NSString stringWithFormat:@"%@%@",fileName,CacheImageType];
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    UIImage *cacheImage;
    
    BOOL isDirExist = [fileManager fileExistsAtPath:filePath];
    if (isDirExist) { // 如果存在说明有缓存
        cacheImage = [[UIImage alloc] initWithContentsOfFile:filePath];
    }
    
    return cacheImage;
}

/**
 根据图片名称获取聊天记录的位置图片

 @param fileName 图片名称
 @return 图片
 */
+ (UIImage *)getLocationImageWithFileName:(NSString *)fileName {
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
    
    NSString *path = [chachePath stringByAppendingPathComponent:ChatImagePath];

    // 图片名称
    fileName = [NSString stringWithFormat:@"%@%@",fileName,CacheImageType];
    
    NSString *filePath = [path stringByAppendingPathComponent:fileName];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    UIImage *locationImage;
    
    BOOL isDirExist = [fileManager fileExistsAtPath:filePath];
    if (isDirExist) { // 如果存在说明有缓存
        locationImage = [[UIImage alloc] initWithContentsOfFile:filePath];
        
        locationImage = [self thumbnailWithImage:locationImage size:CGSizeMake(locationImage.size.width * 0.5, locationImage.size.height * 0.5)];
    }
    
    return locationImage;
}

+ (UIImage *)thumbnailWithImage:(UIImage *)originalImage size:(CGSize)size {
    UIImage *newimage;
    
    if (nil == originalImage) {
        
        newimage = nil;
    } else {
        
        UIGraphicsBeginImageContext(size);
        
        [originalImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        
        newimage = UIGraphicsGetImageFromCurrentImageContext();
        
        UIGraphicsEndImageContext();
    }
    return newimage;
}

/**
 截屏
 
 @param view 待截屏的view
 @return 截屏后的图片
 */
+ (UIImage *)snapImageWithView:(UIView *)view
{
    UIGraphicsBeginImageContextWithOptions(view.frame.size, NO, 0);
    // 截屏
    if ([view respondsToSelector:@selector(drawViewHierarchyInRect:afterScreenUpdates:)]) {
        [view drawViewHierarchyInRect:view.bounds afterScreenUpdates:NO];
    } else { // renderInContext: 此方法在iOS8上会偶尔崩溃，这是在简书看到别人遇到的坑，我没有遇到，但也预防一下
        [view.layer renderInContext:UIGraphicsGetCurrentContext()];
    }
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

/**
 *  图片旋转
 */
+ (UIImage *)rotateImage:(UIImage *)image withOrientation:(UIImageOrientation)orientation {
    long double rotate = 0.0;
    CGRect rect;
    float translateX = 0;
    float translateY = 0;
    float scaleX = 1.0;
    float scaleY = 1.0;
    
    switch (orientation) {
        case UIImageOrientationLeft:
            rotate = M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = 0;
            translateY = -rect.size.width;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationRight:
            rotate = 3 * M_PI_2;
            rect = CGRectMake(0, 0, image.size.height, image.size.width);
            translateX = -rect.size.height;
            translateY = 0;
            scaleY = rect.size.width/rect.size.height;
            scaleX = rect.size.height/rect.size.width;
            break;
        case UIImageOrientationDown:
            rotate = M_PI;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = -rect.size.width;
            translateY = -rect.size.height;
            break;
        default:
            rotate = 0.0;
            rect = CGRectMake(0, 0, image.size.width, image.size.height);
            translateX = 0;
            translateY = 0;
            break;
    }
    
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    //做CTM变换
    CGContextTranslateCTM(context, 0.0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    CGContextRotateCTM(context, rotate);
    CGContextTranslateCTM(context, translateX, translateY);
    
    CGContextScaleCTM(context, scaleX, scaleY);
    //绘制图片
    CGContextDrawImage(context, CGRectMake(0, 0, rect.size.width, rect.size.height), image.CGImage);
    
    UIImage *newPic = UIGraphicsGetImageFromCurrentImageContext();
    
    return newPic;
}



/****************** 芊泓新增方法 ******************/


/**
 获取图片缩略图

 @param image 原图
 @param fileSize 缩略图大小
 @return 缩略图
 */
+ (UIImage *)thumbImageWithImage:(UIImage *)image fileSize:(CGFloat)fileSize {
    
    NSData *fileData = [self compressImage:image fileSize:fileSize];
    if (fileData == nil) {
        return nil;
    }
    UIImage *thumbImage = [UIImage imageWithData:fileData];

    return thumbImage;
}


@end
