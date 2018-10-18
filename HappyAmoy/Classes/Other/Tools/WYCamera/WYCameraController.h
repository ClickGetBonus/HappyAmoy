//
//  WYCameraController.h
//  DianDian
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 com.chinajieyin.www. All rights reserved.
//

#import <UIKit/UIKit.h>

// 相机类型
typedef NS_ENUM(NSInteger,CameraType){
    // 只支持拍照
    PhotoCamera = 1,
    // 只支持录像
    VideoCamera = 2,
    // 照相和录像都支持
    PhotoAndVideoCamera = 3,
};

// 录像质量
typedef NS_ENUM(NSInteger,VideoQualityType){
    // 低质量
    LowQuality = 1,
    // 中等质量
    MediumQuality = 2,
    // 高质量
    HighestQuality = 3,
};

@interface WYCameraController : UIViewController

/**
 *  @brief  构造方法
 */
+ (instancetype)defaultCamera;

/**    自定义相机类型,默认都支持 PhotoAndVideoCamera    */
@property (assign, nonatomic) CameraType cameraType;

/**    录制视频的质量,默认中等质量 MediumQuality    */
@property (assign, nonatomic) VideoQualityType videoQuality;

/**    前置摄像头,默认为NO    */
@property (assign, nonatomic) BOOL isPositionFront;

/**
 *  @brief  拍照完成后的block回调
 */
@property (copy, nonatomic) void (^didFinishTakePhotosHandle)(UIImage *image,NSError *error);

/**
 *  @brief  拍摄小视频完成后的block回调
 */
@property (copy, nonatomic) void (^didFinishTakeVideoHandle)(NSURL *videoUrl, CGFloat duration, UIImage *thumbnailImage, NSError *error);

/**
 *  @brief  取消拍照的回调
 */
@property (copy, nonatomic) void (^cameraDidCancelHandle)();


@end
