//
//  WYCameraButton.m
//  DianDian
//
//  Created by apple on 2018/1/23.
//  Copyright © 2018年 com.chinajieyin.www. All rights reserved.
//

#import "WYCameraButton.h"

// 默认控件大小
#define CameraButtonWidth 75
// 点击视图大小
#define TouchViewWidth 55

// 录制视频时背景view的放大比例
#define CameraBackViewScaleOfRecording 1.3f
// 录制视频时点击按钮的缩小比例
#define CameraButtonScaleOfRecording 0.6f

// 进度条宽度
#define ProgressWidth 3.0f



@interface WYCameraButton ()

/**    点击的view    */
@property (strong, nonatomic) UIView *touchView;

/**    进度条    */
@property (strong, nonatomic) CAShapeLayer *progressLayer;

/**    点击事件    */
@property (copy, nonatomic) void(^tapEventBlock)();

/**    长按拍摄事件    */
@property (copy, nonatomic) void(^longPressEventBlock)(UILongPressGestureRecognizer *longPressGestureRecognizer);

@end

@implementation WYCameraButton

/**
 *  @brief  构造方法
 */
+ (instancetype)cameraButton {
    
    WYCameraButton *cameraButton = [[WYCameraButton alloc] initWithFrame:CGRectMake(0, 0, CameraButtonWidth, CameraButtonWidth)];
    
    cameraButton.layer.cornerRadius = CameraButtonWidth * 0.5;
    cameraButton.backgroundColor = RGB(225, 225, 230);
    
    UIView *touchView = [[UIView alloc] initWithFrame:CGRectMake((CameraButtonWidth - TouchViewWidth) * 0.5, (CameraButtonWidth - TouchViewWidth) * 0.5, TouchViewWidth, TouchViewWidth)];
    
    touchView.layer.cornerRadius = TouchViewWidth * 0.5;
    touchView.backgroundColor = [UIColor whiteColor];
    
    [cameraButton addSubview:touchView];
    
    cameraButton.touchView = touchView;
    // 添加进度条
    [cameraButton addProgressAnimationLayer];

    return cameraButton;
}

#pragma mark - 点击与长按事件

/**
 *  @brief  添加点击事件
 */
- (void)configureTapCameraButtonEventWithBlock:(void(^)())tapEventBlock {
    
    self.tapEventBlock = tapEventBlock;
    // 添加点击事件
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapCameraButtonEvent:)];
    
    [self.touchView addGestureRecognizer:tap];
    
}

- (void)tapCameraButtonEvent:(UITapGestureRecognizer *)tapGestureRecognizer {
    
    if (self.tapEventBlock) {
        self.tapEventBlock();
    }
    
}

/**
 *  @brief  添加长按拍摄事件
 */
- (void)configureLongPressCameraButtonEventWithBlock:(void(^)(UILongPressGestureRecognizer *longPressGestureRecognizer))longPressEventBlock {
    
    self.longPressEventBlock = longPressEventBlock;
    
    UILongPressGestureRecognizer *longPressGestureRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressCameraButtonEvent:)];
    
    [self.touchView addGestureRecognizer:longPressGestureRecognizer];
}

- (void)longPressCameraButtonEvent:(UILongPressGestureRecognizer *)longPressGestureRecognizer {
    
    if (self.longPressEventBlock) {
        self.longPressEventBlock(longPressGestureRecognizer);
    }
    
}

/**
 开始录制前的准备动画

 @param duration 动画时间
 */
- (void)startRecordingAnimationWithDuration:(NSTimeInterval)duration {
    
    WeakSelf
    
    [UIView animateWithDuration:duration animations:^{
        
        weakSelf.transform = CGAffineTransformMakeScale(CameraBackViewScaleOfRecording, CameraBackViewScaleOfRecording);
        weakSelf.touchView.transform = CGAffineTransformMakeScale(CameraButtonScaleOfRecording, CameraButtonScaleOfRecording);
        
    }];
    
}

/**
 *  @brief  结束录制视频动画
 */
- (void)stopRecordingAnimation {
    
    self.transform = CGAffineTransformIdentity;
    self.touchView.transform = CGAffineTransformIdentity;
    
}

#pragma mark - 添加录制视频进度条
/**
 *  @brief  添加进度条动画
 */
- (void)addProgressAnimationLayer {
    
    float centerX = self.width * 0.5;
    float centerY = self.height * 0.5;
    // 半径
    float radious = (self.width - ProgressWidth) * 0.5;
    
    // 创建贝塞尔路径
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radious startAngle:(- M_PI / 2) endAngle:(M_PI * 3 / 2) clockwise:YES];
    
    // 添加背景圆环
    CAShapeLayer *backLayer = [CAShapeLayer layer];
    backLayer.frame = self.bounds;
    backLayer.fillColor = [UIColor clearColor].CGColor;
    backLayer.strokeColor = RGB(225, 225, 230).CGColor;
    backLayer.lineWidth = ProgressWidth;
    backLayer.path = [path CGPath];
    backLayer.strokeEnd = 1;
    [self.layer addSublayer:backLayer];
    
    // 创建进度layer
    CAShapeLayer *progressLayer = [CAShapeLayer layer];
    progressLayer.frame = self.bounds;
    progressLayer.fillColor = [UIColor clearColor].CGColor;
    // 指定path的渲染颜色
    progressLayer.strokeColor = [UIColor blackColor].CGColor;
    // 边缘线的类型
    progressLayer.lineCap = kCALineCapSquare;
    progressLayer.lineWidth = ProgressWidth;
    progressLayer.path = path.CGPath;
    progressLayer.strokeEnd = 0;
    
    self.progressLayer = progressLayer;
    
    // 设置渐变颜色
    CAGradientLayer *gradientLayer = [CAGradientLayer layer];
    gradientLayer.frame = self.bounds;
    
    // 渐变颜色
    [gradientLayer setColors:[NSArray arrayWithObjects:(id)RGB(76, 192, 29).CGColor,(id)RGB(76, 192, 29).CGColor, nil]];
    gradientLayer.startPoint = CGPointMake(0, 0);
    gradientLayer.endPoint = CGPointMake(0, 1);
    // 用progressLayer来截取渐变层
    [gradientLayer setMask:progressLayer];
    
    [self.layer addSublayer:gradientLayer];
    
}

/**
 *  @brief  设置进度条
 */
- (void)setProgress:(CGFloat)progress {
    
    _progress = progress;

    self.progressLayer.strokeEnd = _progress;
    [self.progressLayer removeAllAnimations];
}


@end
