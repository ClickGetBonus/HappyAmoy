//
//  WYCameraButton.h
//  DianDian
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 com.chinajieyin.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYCameraButton : UIView

/**
*  @brief  录制视频的进度条百分比
*/
@property (assign, nonatomic) CGFloat progress;

/**
 *  @brief  构造方法
 */
+ (instancetype)cameraButton;

/**
 *  @brief  添加点击事件
 */
- (void)configureTapCameraButtonEventWithBlock:(void(^)())tapEventBlock;

/**
 *  @brief  添加长按拍摄事件
 */
- (void)configureLongPressCameraButtonEventWithBlock:(void(^)(UILongPressGestureRecognizer *longPressGestureRecognizer))longPressEventBlock;

/**
 开始录制前的准备动画
 
 @param duration 动画时间
 */
- (void)startRecordingAnimationWithDuration:(NSTimeInterval)duration;

/**
 *  @brief  结束录制视频动画
 */
- (void)stopRecordingAnimation;

@end
