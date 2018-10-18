//
//  WYCameraController.m
//  DianDian
//
//  Created by apple on 2018/1/9.
//  Copyright © 2018年 com.chinajieyin.www. All rights reserved.
//

#import "WYCameraController.h"
#import <AVFoundation/AVFoundation.h>
#import <Photos/Photos.h>
#import <AssetsLibrary/AssetsLibrary.h>
#import "WYPhotoLibraryManager.h"
#import <CoreMotion/CoreMotion.h>
#import "WYCameraButton.h"

// 定时器记录视频间隔
#define TimerInterval 0.01f
// 录制视频前的动画时间
#define StartRecordingAnimationDuration 0.3f

@interface WYCameraController () <AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate>

/**    队列    */
@property (strong, nonatomic) dispatch_queue_t videoQueue;

/**    捕获设备，通常是前置摄像头，后置摄像头，麦克风（音频输入）    */
@property (strong, nonatomic) AVCaptureDevice *device;

/**    AVCaptureDeviceInput 代表输入设备，使用 AVCaptureDevice 来初始化   */
@property (strong, nonatomic) AVCaptureDeviceInput *input;
/**    声音输入    */
@property (strong, nonatomic) AVCaptureDeviceInput *audioInput;

/**    照片输出流，负责从 AVCaptureDevice 获得数据   */
@property (strong, nonatomic) AVCaptureStillImageOutput *imageOutput;

/**    用于对媒体资源进行编码并将其写入到容器文件中    */
@property (strong, nonatomic) AVAssetWriter *assetWriter;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterVideoInput;
@property (strong, nonatomic) AVAssetWriterInput *assetWriterAudioInput;
@property (assign, nonatomic) BOOL canWrite;

/**    视频输出流    */
@property (strong, nonatomic) AVCaptureVideoDataOutput *videoOutput;
/**    声音输出流    */
@property (strong, nonatomic) AVCaptureAudioDataOutput *audioOutput;

/**    seesion:由他把输入输出结合在一起，并开始启动捕获设备（摄像头）    */
@property (strong, nonatomic) AVCaptureSession *seesion;

/**    图像预览层，实时显示捕获的图像    */
@property (strong, nonatomic) AVCaptureVideoPreviewLayer *previewLayer;

/**    重拍按钮    */
@property (strong, nonatomic) UIButton *retakeButton;

/**    确定按钮    */
@property (strong, nonatomic) UIButton *confirmButton;

/**    预览图片的背景视图    */
@property (strong, nonatomic) UIView *previewContainerView;

/**    预览图片    */
@property (strong, nonatomic) UIImageView *previewImageView;

/**    聚焦光标位置    */
@property (strong, nonatomic) UIImageView *focusImageView;

/**    切换按钮    */
@property (strong, nonatomic) UIButton *switchCameraButton;

/**    拍摄按钮    */
@property (strong, nonatomic) WYCameraButton *cameraButton;

/**    提示语label    */
@property (strong, nonatomic) UILabel *tipLabel;

/**    镜头正在聚焦    */
@property (assign, nonatomic) Boolean isFocusing;
/**    正在拍摄    */
@property (assign, nonatomic) Boolean isShooting;
/**    正在旋转摄像头    */
@property (assign, nonatomic) Boolean isRotatingCamera;

// 捏合缩放摄像头
/**    记录开始的缩放比例    */
@property (assign, nonatomic) CGFloat beginScale;
/**    最后的缩放比例    */
@property (assign, nonatomic) CGFloat effectiveScale;

/**    拍摄的手机方向    */
@property (assign, nonatomic) UIDeviceOrientation deviceOrientation;
/**    重力感应    */
@property (strong, nonatomic) CMMotionManager *motionManager;
/**    定时器，用来倒数拍摄时间    */
@property (strong, nonatomic) NSTimer *timer;
/**    录制时长    */
@property (assign, nonatomic) CGFloat timeLength;

/**    视频文件地址    */
@property (strong, nonatomic) NSURL *videoURL;
/**    当前小视频总时长    */
@property (assign, nonatomic) CGFloat currentVideoTimeLength;

@property (strong, nonatomic) AVPlayerLayer *playerLayer;
@property (strong, nonatomic) AVPlayer *player;
@property (strong, nonatomic) AVPlayerItem *playerItem;


@end

//
/**    最后的缩放比例    */
static CGFloat const imageMaxScaleAndCropFactor = 4.5;

@implementation WYCameraController

#pragma mark - 构造方法
+ (instancetype)defaultCamera {
    
    WYCameraController *cameraVc = [[WYCameraController alloc] init];
    
    cameraVc.isFocusing = NO;
    cameraVc.isShooting = NO;
    cameraVc.isRotatingCamera = NO;
    cameraVc.canWrite = NO;
    
    cameraVc.cameraType = PhotoAndVideoCamera;
    cameraVc.videoQuality = MediumQuality;
    cameraVc.isPositionFront = NO;
    
    // 默认缩放比例
    cameraVc.beginScale = 1.0f;
    cameraVc.effectiveScale = 1.0f;
    
    return cameraVc;
}

#pragma mark - 初始化
- (void)viewDidLoad {
    [super viewDidLoad];

    // 隐藏状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationNone];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:animated];
    
    // 判断用户是否允许访问相机
    [self requestAuthorizationForCamera];
    
    // 判断用户是否允许访问麦克风权限
    [self requestAuthorizationForAudio];
    
    // 判断用户是否允许访问相册
    [self requestAuthorizationForLibrary];
    
    // 初始化AVCapture会话
    [self initAVCaptureSeesion];
    
    // 设置界面
    [self setupUI];
    // 默认比例为1.0
    [self setPreviewLayerTransformWithScale:1.0f];
    
    // 开启屏幕监听方向
    [self startMonitorTheScreenOrientation];
    
    // 添加捏合手势
    [self addPinchGestureForCamera];
    
}

- (void)viewDidAppear:(BOOL)animated {
    
    [super viewDidAppear:animated];
    
    // 开启会话
    [self startSeesion];
    
    // 第一次聚焦
    [self setFocusCursorWithPoint:self.view.center];
    
    // 开启提示语动画
    [self tipLabelAnimation];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [super viewWillDisappear:animated];
    // 相机消失前要把缩放比例回到最小，否则消失的时候会看到延迟
    // 重新设置缩放比例
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(1.0f, 1.0f)];

    // 显示状态栏
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:UIStatusBarAnimationNone];
    
}

- (void)viewDidDisappear:(BOOL)animated {
    
    [super viewDidDisappear:animated];
    
    [self stopSeesion];
    // 停止监听屏幕方向
    [self stopMonitorTheScreenOrientation];
}

#pragma mark - 懒加载

- (AVCaptureSession *)seesion {
    
    if (_seesion == nil) {
        
        _seesion = [[AVCaptureSession alloc] init];
        // 判断是否支持高清画质
        if ([_seesion canSetSessionPreset:AVCaptureSessionPresetHigh]) {
            _seesion.sessionPreset = AVCaptureSessionPresetHigh;
        }
        
    }
    return _seesion;
}

- (CMMotionManager *)motionManager {
    
    if (_motionManager == nil) {
        _motionManager = [[CMMotionManager alloc] init];
    }
    return _motionManager;
}

- (dispatch_queue_t)videoQueue {
    
    if (!_videoQueue) {
        _videoQueue = dispatch_get_main_queue();
    }
    return _videoQueue;
    
}

#pragma mark - 私有方法

/**
 *  @brief  初始化AVCapture会话
 */
- (void)initAVCaptureSeesion {
    
    // 设置视频输入
    [self setupVideo];
    
    // 设置音频录入
    [self setupAudio];
    
    // 设置图片输出
    [self setupImageOutput];
    
    // 创建视频预览层，用于实时展示摄像头状态
    [self setupCaptureVideoPreviewLayer];
    
    // 设置静音状态也可播放声音
    AVAudioSession *audioSeesion = [AVAudioSession sharedInstance];
    [audioSeesion setCategory:AVAudioSessionCategoryPlayback error:nil];
}

/**
 *  @brief  设置视频输入
 */
- (void)setupVideo {
    // 设置摄像头
    AVCaptureDevice *captureDevice = [self getCameraDeviceWithPosition:_isPositionFront ? AVCaptureDevicePositionFront :  AVCaptureDevicePositionBack];
    
    if (!captureDevice) {
        
        WYLog(@"无法获取后置摄像头");
        return;
    }
    
    NSError *error = nil;
    
    self.input = [[AVCaptureDeviceInput alloc] initWithDevice:captureDevice error:&error];

    if (error) {
        
        WYLog(@"无法获取输入设备，错误原因：%@",error);
        return;
    }
    
    // 将输入设备添加到会话中
    if ([self.seesion canAddInput:self.input]) {
        [self.seesion addInput:self.input];
    }
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    // 当此属性的值为YES时，接收方将立即丢弃在处理现有帧的分派队列在captureOutput：didOutputSampleBuffer：fromConnection：delegate方法中被阻止时捕获的帧。 当这个属性的值为NO时，代表将被允许更多的时间来处理旧的帧，然后丢弃新的帧，但是应用程序内存的使用可能会因此而大大增加。 默认值是YES。
    self.videoOutput.alwaysDiscardsLateVideoFrames = YES;
    
    [self.videoOutput setSampleBufferDelegate:self queue:self.videoQueue];
    
    if ([self.seesion canAddOutput:self.videoOutput]) {
        [self.seesion addOutput:self.videoOutput];
    }
}

/**
 *  @brief  设置音频录入和输出
 */
- (void)setupAudio {
    
    NSError *error = nil;
    self.audioInput = [[AVCaptureDeviceInput alloc] initWithDevice:[AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeAudio] error:&error];
    
    if (error) {
        WYLog(@"取得设备输入audioInput对象时出错，错误原因：%@",error);
        
        return;
    }
    // 将输入设备添加到会话中
    if ([self.seesion canAddInput:self.audioInput]) {
        [self.seesion addInput:self.audioInput];
    }
    
    self.audioOutput = [[AVCaptureAudioDataOutput alloc] init];
    // 获取实时录像的声音流
    [self.audioOutput setSampleBufferDelegate:self queue:self.videoQueue];
    
    // 将输入设备添加到会话中
    if ([self.seesion canAddOutput:self.audioOutput]) {
        [self.seesion addOutput:self.audioOutput];
    }
}

/**
 *  @brief  设置图片输出
 */
- (void)setupImageOutput {
    
    self.imageOutput = [[AVCaptureStillImageOutput alloc] init];
    //这是输出流的设置参数AVVideoCodecJPEG参数表示以JPEG的图片格式输出图片
    NSDictionary *outputSettings = @{
                                     AVVideoCodecKey:AVVideoCodecJPEG
                                     };
    
    [_imageOutput setOutputSettings:outputSettings];
    
    if ( [self.seesion canAddOutput:_imageOutput]) {
        [self.seesion addOutput:_imageOutput];
    }
}

/**
 *  @brief  创建视频预览层，用于实时展示摄像头状态
 */
- (void)setupCaptureVideoPreviewLayer {
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.seesion];
    
    _previewLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    // 填充模式
    _previewLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    [self.view.layer addSublayer:_previewLayer];
}

/**
 根据摄像头位置获取对应的摄像头设备

 @param position 摄像头位置
 @return 摄像头设备
 */
- (AVCaptureDevice *)getCameraDeviceWithPosition:(AVCaptureDevicePosition)position {
    
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for (AVCaptureDevice *camera in cameras) {
        if ([camera position] == position) {
            return camera;
        }
    }
    return nil;
}

/**
 *  @brief  开启会话
 */
- (void)startSeesion {
    
    if (![self.seesion isRunning]) {
        [self.seesion startRunning];
    }
}

/**
 *  @brief  停止会话
 */
- (void)stopSeesion {
    
    if ([self.seesion isRunning]) {
        [self.seesion stopRunning];
    }
}

/**
 *  @brief  设置界面
 */
- (void)setupUI {
    
    self.view.backgroundColor = [UIColor blackColor];
    
    // 切换摄像头按钮
    UIButton *switchCameraButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    switchCameraButton.frame = CGRectMake(SCREEN_WIDTH - 60, 15, 50, 50);
    [switchCameraButton setImage:[UIImage imageNamed:@"icon_change"] forState:UIControlStateNormal];

    [switchCameraButton addTarget:self action:@selector(switchCameraButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:switchCameraButton];
    
    self.switchCameraButton = switchCameraButton;
    
    // 取消按钮
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    cancelButton.frame = CGRectMake(50, SCREEN_HEIGHT - 100, 30, 30);
    cancelButton.centerX = SCREEN_WIDTH / 4 - 10;
    
    [cancelButton setImage:[UIImage imageNamed:@"down"] forState:UIControlStateNormal];
    [cancelButton addTarget:self action:@selector(cancelButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    [self.view addSubview:cancelButton];
    
    WeakSelf
    
    // 拍照按钮
    WYCameraButton *cameraButton = [WYCameraButton cameraButton];
    // 距离底部50
    cameraButton.frame = CGRectMake((SCREEN_WIDTH - cameraButton.width) * 0.5, SCREEN_HEIGHT - cameraButton.height - 50, cameraButton.width, cameraButton.height);
    if (self.cameraType != VideoCamera) {
        // 点击事件
        [cameraButton configureTapCameraButtonEventWithBlock:^{
            // 拍照
            [weakSelf takePhoto];
            
        }];
    }
    if (self.cameraType != PhotoCamera) {
        // 长按拍摄事件
        [cameraButton configureLongPressCameraButtonEventWithBlock:^(UILongPressGestureRecognizer *longPressGestureRecognizer) {
            // 拍摄视频
            [weakSelf takeVideo:longPressGestureRecognizer];
        }];
    }
    
    [self.view addSubview:cameraButton];
    
    self.cameraButton = cameraButton;
    
    // 重拍按钮
    UIButton *retakeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    retakeButton.frame = CGRectMake(SCREEN_WIDTH / 8, SCREEN_HEIGHT - SCREEN_WIDTH / 4 * 1.8, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
    [retakeButton setImage:[UIImage imageNamed:@"icon_return_n"] forState:UIControlStateNormal];

    [retakeButton addTarget:self action:@selector(retakeButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    retakeButton.hidden = YES;
    
    [self.view addSubview:retakeButton];
    
    self.retakeButton = retakeButton;
    
    // 确定按钮
    UIButton *confirmButton = [UIButton buttonWithType:UIButtonTypeCustom];
    
    confirmButton.frame = CGRectMake(SCREEN_WIDTH / 8 * 5, SCREEN_HEIGHT - SCREEN_WIDTH / 4 * 1.8, SCREEN_WIDTH / 4, SCREEN_WIDTH / 4);
    [confirmButton setImage:[UIImage imageNamed:@"icon_finish_p"] forState:UIControlStateNormal];

    [confirmButton addTarget:self action:@selector(confirmButtonDidClick) forControlEvents:UIControlEventTouchUpInside];
    
    confirmButton.hidden = YES;
    
    [self.view addSubview:confirmButton];
    
    self.confirmButton = confirmButton;
    
    cancelButton.centerY = retakeButton.centerY = confirmButton.centerY = cameraButton.centerY;
    
    // 聚焦框
    UIImageView *focusImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"sight_video_focus"]];
    
    focusImageView.center = self.view.center;
    focusImageView.alpha = 0;
    
    [self.view addSubview:focusImageView];
    
    self.focusImageView = focusImageView;
    
    NSString *tipText = @"点击拍照，长按录像";
    switch (_cameraType) {
        case PhotoCamera:
            tipText = @"点击拍照";
            break;
        case VideoCamera:
            tipText = @"长按录像";
            break;
        default:
            break;
    }
    
    // 提示语
    UILabel *tipLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, confirmButton.top_WY - 40, SCREEN_WIDTH, 30)];
    
    tipLabel.centerX = SCREEN_WIDTH * 0.5;
    tipLabel.text = tipText;
    tipLabel.textAlignment = NSTextAlignmentCenter;
    tipLabel.textColor = [UIColor whiteColor];
    tipLabel.font = TextFont(15);
    // 默认不显示
    tipLabel.alpha = 0;
    
    [self.view addSubview:tipLabel];
    
    self.tipLabel = tipLabel;
}

/**
 *  @brief  点击切换按钮
 */
- (void)switchCameraButtonDidClick {
    
    _isRotatingCamera = YES;
    
    // 给摄像头的切换添加翻转动画
    CATransition *animation = [CATransition animation];
    
    animation.duration = .5f;
    animation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseOut];
    animation.type = @"oglFlip";
    
    AVCaptureDevice *currentDevice = [self.input device];
    
    AVCaptureDevicePosition currentPosition = [currentDevice position];
    
    AVCaptureDevice *toChangeDevice;
    AVCaptureDevicePosition toChangePosition =AVCaptureDevicePositionFront;
    
    // 动画翻转方向
    animation.subtype = kCATransitionFromRight;
    
    if (currentPosition == AVCaptureDevicePositionFront || currentPosition == AVCaptureDevicePositionUnspecified) {
        toChangePosition = AVCaptureDevicePositionBack;
        // 动画翻转方向
        animation.subtype = kCATransitionFromLeft;
    }
    
    toChangeDevice = [self getCameraDeviceWithPosition:toChangePosition];
    // 切换动画
//    [self.previewLayer addAnimation:animation forKey:nil];
    
    // 获得要调整的设备输入对象
    AVCaptureDeviceInput *toChangeDeviceInput = [[AVCaptureDeviceInput alloc] initWithDevice:toChangeDevice error:nil];
    
    // 改变会话的配置一定要先开启配置，配置完成后提交配置改变
    [self.seesion beginConfiguration];
    // 移除原有输入对象
    [self.seesion removeInput:self.input];
    // 添加新的输入对象
    if ([self.seesion canAddInput:toChangeDeviceInput]) {
        [self.seesion addInput:toChangeDeviceInput];
        self.input = toChangeDeviceInput;
    }
    
    // 提交会话配置
    [self.seesion commitConfiguration];
    
    // 切换摄像头需要重新设置缩放比例
    [self setPreviewLayerTransformWithScale:1.0f];
    
    _isRotatingCamera = NO;
}

/**
 *  @brief  点击取消按钮
 */
- (void)cancelButtonDidClick {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if (_cameraDidCancelHandle) {
        
        _cameraDidCancelHandle();
    }
}

/**
 *  @brief  点击拍照按钮
 */
- (void)takePhoto {
    
    WYFunc
    
    WeakSelf
    
    // 根据输出设备获得连接
    AVCaptureConnection *captureConnection = [self.imageOutput connectionWithMediaType:AVMediaTypeVideo];
    WYLog(@"缩放比例 = %f",self.effectiveScale);
    // 缩放比例
    [captureConnection setVideoScaleAndCropFactor:self.effectiveScale];
    
    // 根据连接取得设备输出的数据
    [self.imageOutput captureStillImageAsynchronouslyFromConnection:captureConnection completionHandler:^(CMSampleBufferRef  _Nullable imageDataSampleBuffer, NSError * _Nullable error) {
        
        if (imageDataSampleBuffer) {
            
            AVCaptureDevice *currentDevice = [self.input device];
            AVCaptureDevicePosition currentPosition = [currentDevice position];
            
            NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
            UIImage *image = [UIImage imageWithData:imageData];

            if (currentPosition == AVCaptureDevicePositionFront) { // 前置摄像头
                // 前置摄像头图像方向 UIImageOrientationLeftMirrored
                // IOS前置摄像头左右成像
//                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                UIImage *t_image = [UIImage imageWithData:imageData];
//                image = [[UIImage alloc]initWithCGImage:t_image.CGImage scale:1.0f orientation:UIImageOrientationLeftMirrored];
                
                // 预览图片
                [weakSelf previewPhotoWithImage:image isPositionFront:YES];
                
            } else { // 后置摄像头
//                NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageDataSampleBuffer];
//                image = [UIImage imageWithData:imageData];
                
                // 预览图片
                [weakSelf previewPhotoWithImage:image isPositionFront:NO];
                
            }
        }
    }];
}

/**
 预览图片

 @param image 图片
 @param isPositionFront 是否是前置拍照
 */
- (void)previewPhotoWithImage:(UIImage *)image isPositionFront:(BOOL)isPositionFront {
    
    // 停止监听屏幕方向
    [self stopMonitorTheScreenOrientation];
    
    UIImage *finalImage = nil;

    if (self.deviceOrientation == UIDeviceOrientationLandscapeRight) {
        WYLog(@"UIDeviceOrientationLandscapeRight");
        if (isPositionFront) { // 前置拍照
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationUp];
        } else {
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationDown];
        }
    } else if (self.deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        WYLog(@"UIDeviceOrientationLandscapeLeft");
        if (isPositionFront) { // 前置拍照
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationDown];
        } else {
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationUp];
        }
    } else if (self.deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        WYLog(@"UIDeviceOrientationPortraitUpsideDown");
        if (isPositionFront) { // 前置拍照
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationLeft];
        } else {
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationLeft];
        }
    } else {
        WYLog(@"UIDeviceOrientationPortrait");
        if (isPositionFront) { // 前置拍照
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationRight];
        } else {
            finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationRight];
        }
    }
    
    if (isPositionFront) { // 前置摄像头解决镜像的方法
        
        finalImage = [[UIImage alloc]initWithCGImage:finalImage.CGImage scale:1.0f orientation:UIImageOrientationUpMirrored];
    }

    self.previewImageView = [[UIImageView alloc] init];
    
    WYLog(@"finalImage.size = %@",NSStringFromCGSize(finalImage.size));
    
    if (self.deviceOrientation == UIDeviceOrientationLandscapeLeft || self.deviceOrientation == UIDeviceOrientationLandscapeRight) {
        
        CGFloat height = SCREEN_WIDTH * finalImage.size.width / finalImage.size.height;
        
        self.previewImageView.frame = CGRectMake(0, (SCREEN_HEIGHT - height) * 0.5, SCREEN_WIDTH, height);
        
    } else {
        
        self.previewImageView.frame = SCREEN_FRAME;
        
    }
    self.previewImageView.image = finalImage;

    self.previewContainerView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    self.previewContainerView.backgroundColor = [UIColor blackColor];
    [self.previewContainerView addSubview:self.previewImageView];
    
    [self.view addSubview:self.previewContainerView];
    
    self.retakeButton.hidden = NO;
    self.confirmButton.hidden = NO;
    [self.view bringSubviewToFront:self.retakeButton];
    [self.view bringSubviewToFront:self.confirmButton];
    
}

/**
 *  @brief  重拍图片
 */
- (void)retakeButtonDidClick {
    
    [self.previewImageView removeFromSuperview];
    [self.previewContainerView removeFromSuperview];
    self.previewImageView = nil;
    self.previewContainerView = nil;

    if (self.player) {
        [self.player pause];
        self.player = nil;
        self.playerItem = nil;
        [self.playerLayer removeFromSuperlayer];
        self.playerLayer = nil;
        [[NSFileManager defaultManager] removeItemAtURL:self.videoURL error:nil];
        self.videoURL = nil;
    }

    // 重新设置缩放比例
    [self setPreviewLayerTransformWithScale:1.0f];
    // 重新聚焦
    [self setFocusCursorWithPoint:self.view.center];
    
    self.retakeButton.hidden = YES;
    self.confirmButton.hidden = YES;
    
    // 开始监听屏幕方向
    [self startMonitorTheScreenOrientation];

    // 提示语动画
    [self tipLabelAnimation];

}

/**
 *  @brief  确定选择图片或视频
 */
- (void)confirmButtonDidClick {
    
//    [self.previewImageView removeFromSuperview];
//
//    self.retakeButton.hidden = YES;
//    self.confirmButton.hidden = YES;
    
//    UIImage *image1 = self.previewImageView.image;
    
    WeakSelf
    
    if (self.player) { // 视频
        
        [self.player pause];

        if (self.videoURL == nil) {
            WYLog(@"没有视频");
            return;
        }
        [WYProgress show];
        // 截取前的视频流
        NSData *videoData = [NSData dataWithContentsOfURL:self.videoURL];
        
        WYLog(@"截取前的视频大小:%f",[videoData length] / 1024.0 / 1024.0);
        
        // 截取视频
        [self cropWithVideoUrl:self.videoURL completion:^(NSURL *outputURL, Float64 videoDuration, BOOL isSuccess) {
            NSURL *url = weakSelf.videoURL;
            Float64 duration = weakSelf.currentVideoTimeLength;
            if (isSuccess) { // 截取视频成功
                url = outputURL;
                duration = videoDuration;
                // 移除截取前的视频，只需要截取后的视频即可
                [[NSFileManager defaultManager] removeItemAtURL:weakSelf.videoURL error:nil];

            } else { // 截取视频失败
                // 移除截取失败的视频
                [[NSFileManager defaultManager] removeItemAtURL:outputURL error:nil];
            }
            // 保存视频
            [WYPhotoLibraryManager saveVideoWithURL:url assetCollectionName:nil completion:^(NSURL *videoUrl, NSError *error) {
                if (weakSelf.didFinishTakeVideoHandle) {
                    // 获取视频的第一帧图片
                    UIImage *image = [weakSelf thumbnailImageRequestWithVideoUrl:videoUrl duration:0.01];
                    
                    weakSelf.didFinishTakeVideoHandle(videoUrl, duration, image, nil);
                }
                
                [WYProgress dismiss];
                
                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }];
        }];
    } else {
        // 使用截屏的图片
        UIImage *snapImage = [UIImage snapImageWithView:self.previewImageView];
        
        //    WYLog(@"image1 = %@ , image1.size = %@ , image1.length = %.1f",image1,NSStringFromCGSize(image1.size),UIImagePNGRepresentation(image1).length / 1000.0);
        //    WYLog(@"image2 = %@ , image2.size = %@ , image2.length = %.1f",image2,NSStringFromCGSize(image2.size),UIImagePNGRepresentation(image2).length / 1000.0);
        
        // 保存图片
        [WYPhotoLibraryManager savePhotoImage:snapImage assetCollectionName:nil completion:^(UIImage *image, NSError *error) {
            
            if (weakSelf.didFinishTakePhotosHandle) {
                // 保存图片失败也要把图片返回出去
                weakSelf.didFinishTakePhotosHandle((error == nil) ? image : snapImage,error);

                [weakSelf dismissViewControllerAnimated:YES completion:nil];
            }
        }];
    }
}

/**
 *  @brief  截取视频
 */
- (void)cropWithVideoUrl:(NSURL *)videoUrl completion:(void(^)(NSURL *outputURL,Float64 videoDuration,BOOL isSuccess))completionHandle {
    
    AVURLAsset *asset = [[AVURLAsset alloc] initWithURL:videoUrl options:nil];
    
    // 获取视频总时长
    Float64 duration = CMTimeGetSeconds(asset.duration);
    
    if (duration > VIDEO_RECORDER_MAX_TIME) {
        duration = VIDEO_RECORDER_MAX_TIME;
    }
    
    CGFloat startTime = 0;
    CGFloat endTime = duration;
    
    NSString *outputFilePath = [self createVideoPath];
    
    NSURL *outputURL = [NSURL fileURLWithPath:outputFilePath];
    
    NSArray *compatiblePresets = [AVAssetExportSession exportPresetsCompatibleWithAsset:asset];
    
    NSString *quality = AVAssetExportPresetHighestQuality;
    
    switch (_videoQuality) {
        case LowQuality:
            quality = AVAssetExportPresetLowQuality;
            break;
        case MediumQuality:
            quality = AVAssetExportPresetMediumQuality;
            break;
        case HighestQuality:
            quality = AVAssetExportPresetHighestQuality;
            break;
        default:
            break;
    }
    
    if ([compatiblePresets containsObject:quality]) {
        
        AVAssetExportSession *exportSeesion = [[AVAssetExportSession alloc] initWithAsset:asset presetName:quality];
        
        exportSeesion.outputURL = outputURL;
        exportSeesion.outputFileType = AVFileTypeMPEG4;
        exportSeesion.shouldOptimizeForNetworkUse = YES;
        
        CMTime start = CMTimeMakeWithSeconds(startTime, asset.duration.timescale);
        CMTime duration = CMTimeMakeWithSeconds(endTime - startTime, asset.duration.timescale);
        CMTimeRange range = CMTimeRangeMake(start, duration);
        exportSeesion.timeRange = range;
        
        [exportSeesion exportAsynchronouslyWithCompletionHandler:^{
            switch ([exportSeesion status]) {
                case AVAssetExportSessionStatusFailed: {
                    WYLog(@"合成视频失败: %@",[[exportSeesion error] description]);
                    completionHandle(outputURL,endTime,NO);
                }
                    break;
                case AVAssetExportSessionStatusCancelled: {
                    WYLog(@"取消视频合成");
                    completionHandle(outputURL,endTime,NO);
                }
                    break;
                case AVAssetExportSessionStatusCompleted: {
                    WYLog(@"合成视频成功");
                    completionHandle(outputURL,endTime,YES);
                }
                    break;
                default: {
                    completionHandle(outputURL,endTime,NO);
                }
                    break;
            }
        }];
    } else {
        WYLog(@"无法截取视频");
        completionHandle(outputURL,endTime,NO);
    }
}

/**
 截取指定时间的视频缩略图

 @param videoUrl 视频路径
 @param duration 指定时间
 @return 缩略图
 */
- (UIImage *)thumbnailImageRequestWithVideoUrl:(NSURL *)videoUrl duration:(CGFloat)duration {
    
    if (videoUrl == nil) {
        return nil;
    }
    
    AVURLAsset *urlAsset = [AVURLAsset assetWithURL:videoUrl];
    
    // 根据AVURLAsset创建AVAssetImageGenerator
    AVAssetImageGenerator *imageGenerator = [AVAssetImageGenerator assetImageGeneratorWithAsset:urlAsset];
    
    NSError *error = nil;
    
    // CMTime是表示电影时间信息的结构体，第一个参数表示是视频第几秒，第二个参数表示每秒帧数.(如果要活的某一秒的第几帧可以使用CMTimeMake方法)
    CMTime requestTime = CMTimeMakeWithSeconds(duration, 10);
    
    CMTime actualTime;
    CGImageRef cgImage = [imageGenerator copyCGImageAtTime:requestTime actualTime:&actualTime error:&error];
    
    if (error) {
        WYLog(@"截取视频缩略图错误，错误信息：%@",error.localizedDescription);
        return nil;
    }
    
    CMTimeShow(actualTime);
    UIImage *image = [UIImage imageWithCGImage:cgImage];
    CGImageRelease(cgImage);
    
    UIImage *finalImage = nil;
    if (self.deviceOrientation == UIDeviceOrientationLandscapeRight) {
        finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationDown];
    } else if (self.deviceOrientation == UIDeviceOrientationLandscapeLeft) {
        finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationUp];
    } else if (self.deviceOrientation == UIDeviceOrientationPortraitUpsideDown) {
        finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationLeft];
    } else {
        finalImage = [UIImage rotateImage:image withOrientation:UIImageOrientationRight];
    }
    return finalImage;
    
}

#pragma mark - 拍摄视频
/**
 *  @brief  拍摄视频
 */
- (void)takeVideo:(UILongPressGestureRecognizer *)sender {
    
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    // 判断用户是否允许访问摄像头
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return;
    }
    
    // 判断用户是否允许访问麦克风权限
    authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
        return;
    }
    
    switch (sender.state) {
        case UIGestureRecognizerStateBegan:
            WYLog(@"开始拍摄");
            [self startRecordingVideo];
            break;
        case UIGestureRecognizerStateEnded:
            WYLog(@"结束拍摄");
            [self stopRecordingVideo];
            break;
        case UIGestureRecognizerStateCancelled:
            WYLog(@"取消拍摄");
            [self stopRecordingVideo];
            break;
        case UIGestureRecognizerStateFailed:
            WYLog(@"拍摄失败");
            [self stopRecordingVideo];
            break;
        default:
            break;
    }
}

/**
 *  @brief  开始录制视频
 */
- (void)startRecordingVideo {
    
    _isShooting = YES;
    
    // 停止监听屏幕方向
    [self stopMonitorTheScreenOrientation];
    
    // 拍摄按钮的动画
    [self.cameraButton startRecordingAnimationWithDuration:StartRecordingAnimationDuration];

    WeakSelf
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(StartRecordingAnimationDuration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
        NSURL *url = [NSURL fileURLWithPath:[weakSelf createVideoPath]];
        
        self.videoURL = url;
        
        [self setupWriter];
        
        // 开启定时器
        [weakSelf startTimer];
        
    });
}

/**
 *  @brief  结束录制视频
 */
- (void)stopRecordingVideo {
    
    WYLog(@"停止拍摄");
    
    if (_isShooting) {
        
        _isShooting = NO;
        
        self.cameraButton.progress = 0;
        
        [self.cameraButton stopRecordingAnimation];
        // 停止定时器
        [self timerStop];
        
        WeakSelf
        
        if (self.assetWriter && self.assetWriter.status == AVAssetWriterStatusWriting) {
            
            [self.assetWriter finishWritingWithCompletionHandler:^{
                weakSelf.canWrite = NO;
                weakSelf.assetWriter = nil;
                weakSelf.assetWriterAudioInput = nil;
                weakSelf.assetWriterVideoInput = nil;
            }];
        }
        
        if (_timeLength < VIDEO_RECORDER_MIN_TIME) {
            return;
        }
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf previewVideo];
        });
    }
}

/**
 *  @brief  创建视频保存路径
 */
- (NSString *)createVideoPath {
    
    NSString *chachePath = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];

    NSString *path = [chachePath stringByAppendingPathComponent:TakeVideoPath];

    NSFileManager *fileManager = [NSFileManager defaultManager];

    BOOL isDirExist = [fileManager fileExistsAtPath:path];
    if (!isDirExist) {
        BOOL isCreateDir = [fileManager createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:nil];
        if (!isCreateDir) {
            WYLog(@"create folder failed");
            return nil;
        }
    }
    
    // 视频名称
    NSString *fileName = [NSString stringWithFormat:@"%@%@",[self getVideoFileName],TakeVideoType];

    NSString *filePath = [path stringByAppendingPathComponent:fileName];

    return filePath;
}

/**
 *  @brief  创建视频文件名
 */
- (NSString *)getVideoFileName {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    
    [dateFormatter setDateFormat:@"yyyy-MM-dd-HH-mm-ss"];
    
    NSString *fileName = [dateFormatter stringFromDate:[NSDate date]];
    
    WYLog(@"视频名称：%@",fileName);
    
    return fileName;
    
}

/**
 *  @brief  设置写入视频属性
 */
- (void)setupWriter {
    
    if (self.videoURL == nil) {
        return;
    }
    
    self.assetWriter = [AVAssetWriter assetWriterWithURL:self.videoURL fileType:AVFileTypeMPEG4 error:nil];
    
    // 写入视频大小
    NSInteger numPerPixel = SCREEN_WIDTH * SCREEN_HEIGHT;
    // 每像素比特
    CGFloat bitsPerPixel = 12.0;
    NSInteger bitsPerSecond = numPerPixel * bitsPerPixel;
    
    // 码率和帧率设置
    NSDictionary *compressionProperties = @{ AVVideoAverageBitRateKey : @(bitsPerSecond),
                                             AVVideoExpectedSourceFrameRateKey : @(15),
                                             AVVideoMaxKeyFrameIntervalKey : @(15),
                                             AVVideoProfileLevelKey : AVVideoProfileLevelH264BaselineAutoLevel
                                             };
    
    // 视频属性
    NSDictionary *videoCompressionSettings = @{ AVVideoCodecKey : AVVideoCodecH264,
                                                AVVideoScalingModeKey : AVVideoScalingModeResizeAspectFill,
                                                AVVideoWidthKey : @(SCREEN_HEIGHT * 2),
                                                AVVideoHeightKey : @(SCREEN_WIDTH * 2),
                                                AVVideoCompressionPropertiesKey : compressionProperties
                                                };
    
    self.assetWriterVideoInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeVideo outputSettings:videoCompressionSettings];
    // expectsMediaDataInRealTime 必须设置为YES，需要从capture seesion 实时获取数据
    self.assetWriterVideoInput.expectsMediaDataInRealTime = YES;
    
    switch (self.deviceOrientation) {
        case UIDeviceOrientationLandscapeRight:
            self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI);
            break;
        case UIDeviceOrientationLandscapeLeft:
            self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(0);
            break;
        case UIDeviceOrientationPortraitUpsideDown:
            self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI + (M_PI / 2.0));
            break;
        default:
            self.assetWriterVideoInput.transform = CGAffineTransformMakeRotation(M_PI / 2.0);
            break;
    }
    
    // 音频设置
    NSDictionary *audioCompressionSettings = @{ AVEncoderBitRatePerChannelKey : @(28000),
                                                AVFormatIDKey : @(kAudioFormatMPEG4AAC),
                                                AVNumberOfChannelsKey : @(1),
                                                AVSampleRateKey : @(22050)
                                                };
    
    self.assetWriterAudioInput = [AVAssetWriterInput assetWriterInputWithMediaType:AVMediaTypeAudio outputSettings:audioCompressionSettings];
    
    self.assetWriterAudioInput.expectsMediaDataInRealTime = YES;
    
    if ([self.assetWriter canAddInput:self.assetWriterVideoInput]) {
        [self.assetWriter addInput:self.assetWriterVideoInput];
    } else {
        WYLog(@"AssetWriter videoInput append Failed");
    }
    
    if ([self.assetWriter canAddInput:self.assetWriterAudioInput]) {
        [self.assetWriter addInput:self.assetWriterAudioInput];
    } else {
        WYLog(@"AssetWriter audioInput append Failed");
    }
    
    self.canWrite = NO;
}

/**
 *  @brief  开启定时器
 */
- (void)startTimer {
    
    _timeLength = 0;
    
    self.timer = [NSTimer scheduledTimerWithTimeInterval:TimerInterval target:self selector:@selector(timerRecorder) userInfo:nil repeats:YES];
    
}

/**
 *  @brief  定时器倒数
 */
- (void)timerRecorder {
    
    if (!_isShooting) {
        [self timerStop];
        return;
    }
    // 如果录制时间大于最大时间则停止
    if (_timeLength > VIDEO_RECORDER_MAX_TIME) {
        [self stopRecordingVideo];
        return;
    }
    
    _timeLength += TimerInterval;
    
    WYLog(@"正在拍摄:%f秒",_timeLength);
    
    self.cameraButton.progress = _timeLength / VIDEO_RECORDER_MAX_TIME;
}

/**
 *  @brief  停止定时器
 */
- (void)timerStop {
    
    if ([self.timer isValid]) {
        [self.timer invalidate];
        self.timer = nil;
    }
}

/**
 *  @brief  预览拍摄的视频
 */
- (void)previewVideo {
    
    WYLog(@"self.videoURL = %@",self.videoURL);

    if (self.videoURL == nil) {
        return;
    }
    
    AVURLAsset *asset = [AVURLAsset assetWithURL:self.videoURL];
    
    WYLog(@"asset = %@",asset);
    
    // 获取视频总时长
    Float64 duration = CMTimeGetSeconds(asset.duration);
    
    self.currentVideoTimeLength = duration;
    
    WYLog(@"视频时长: %f",self.currentVideoTimeLength);
    
    // 初始化AVPlayer
    self.playerItem = [AVPlayerItem playerItemWithAsset:asset];
    
    self.player = [[AVPlayer alloc] initWithPlayerItem:self.playerItem];
    
    self.playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
    
    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    
    self.playerLayer.videoGravity = AVLayerVideoGravityResizeAspect;
    
    self.previewContainerView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    self.previewContainerView.backgroundColor = [UIColor blackColor];
    [self.previewContainerView.layer addSublayer:self.playerLayer];
    
    [self.view addSubview:self.previewContainerView];
    
    self.retakeButton.hidden = NO;
    self.confirmButton.hidden = NO;
    [self.view bringSubviewToFront:self.retakeButton];
    [self.view bringSubviewToFront:self.confirmButton];
    
    // 添加播放器通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playVideoFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:self.playerItem];
    
    [self.player play];
    
}

/**
 *  @brief  播放完成通知
 */
- (void)playVideoFinished:(NSNotification *)note {
    
    // 播放完成后重复播放
    // 跳到最新的时间点开始播放
    [self.player seekToTime:CMTimeMake(0, 1)];
    [self.player play];
    
}

#pragma mark - 判断用户是否允许访问相机
- (void)requestAuthorizationForCamera {
    
    // 获取相机权限
    AVAuthorizationStatus cameraAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (cameraAuthStatus == AVAuthorizationStatusNotDetermined) { // 用户还没决定
        
    } else if (cameraAuthStatus != AVAuthorizationStatusAuthorized) { // 用户拒绝授权
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if (!appName) {
            appName = @"APP";
        }
        
        NSString *message = [NSString stringWithFormat:@"允许%@访问您的相机?",appName];
        
        [WYUtils showConfirmAlertWithTitle:nil message:message yesTitle:@"确定" yesAction:^{
            // 跳到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } cancelTitle:@"取消" cancelAction:^{
            
        }];
    }
}

#pragma mark - AVCaptureVideoDataOutputSampleBufferDelegate,AVCaptureAudioDataOutputSampleBufferDelegate

- (void)captureOutput:(AVCaptureOutput *)output didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer fromConnection:(AVCaptureConnection *)connection {
    
    if (_isRotatingCamera) {
        return;
    }
    
    @autoreleasepool {
        // 视频
        if (connection == [self.videoOutput connectionWithMediaType:AVMediaTypeVideo]) {
            @synchronized(self) {
                if (_isShooting) {
                    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeVideo];
                }
            }
        }
        
        // 音频
        if (connection == [self.audioOutput connectionWithMediaType:AVMediaTypeAudio]) {
            @synchronized(self) {
                if (_isShooting) {
                    [self appendSampleBuffer:sampleBuffer ofMediaType:AVMediaTypeAudio];
                }
            }
        }
    }
}

/**
 *  @brief  开始写入数据
 */
- (void)appendSampleBuffer:(CMSampleBufferRef)sampleBuffer ofMediaType:(NSString *)mediaType {
    
    if (sampleBuffer == NULL) {
        WYLog(@"empty sampleBuffer");
        return;
    }
    
    @autoreleasepool {
        
        if (!self.canWrite && mediaType == AVMediaTypeVideo) {
            [self.assetWriter startWriting];
            [self.assetWriter startSessionAtSourceTime:CMSampleBufferGetPresentationTimeStamp(sampleBuffer)];
            self.canWrite = YES;
        }
        // 写入视频数据
        if (mediaType == AVMediaTypeVideo) {
            
            if (self.assetWriterVideoInput.readyForMoreMediaData) {
                
                BOOL success = [self.assetWriterVideoInput appendSampleBuffer:sampleBuffer];
                if (!success) {
                    @synchronized (self) {
                        [self stopRecordingVideo];
                    }
                }
            }
        }
        
        // 写入音频数据
        if (mediaType == AVMediaTypeAudio) {
            if (self.assetWriterAudioInput.readyForMoreMediaData) {
                BOOL success = [self.assetWriterAudioInput appendSampleBuffer:sampleBuffer];
                if (!success) {
                    @synchronized (self) {
                        [self stopRecordingVideo];
                    }
                }
            }
        }
    }
}

/**
 *  @brief  添加捏合手势
 */
- (void)addPinchGestureForCamera {
    
    UIPinchGestureRecognizer *pinchGesture = [[UIPinchGestureRecognizer alloc] initWithTarget:self action:@selector(handlePinchGesture:)];

    [self.view addGestureRecognizer:pinchGesture];
    
}

#pragma mark - handlePinchGesture
- (void)handlePinchGesture:(UIPinchGestureRecognizer *)recognizer {
    
    if (_isShooting) {
        return;
    }
    if (recognizer.state == UIGestureRecognizerStateBegan) {
        self.beginScale = self.effectiveScale;
    } else {
        BOOL allTouchesAreOnTheCaptureVideoPreviewLayer = YES;
        
        NSInteger numTouches = [recognizer numberOfTouches];
        
        for (int i = 0; i < numTouches; i++) {
            
            CGPoint location = [recognizer locationOfTouch:i inView:self.view];
            
            CGPoint convertedLocation = [self.previewLayer convertPoint:location fromLayer:self.previewLayer.superlayer];
            
            if (![self.previewLayer containsPoint:convertedLocation]) {
                allTouchesAreOnTheCaptureVideoPreviewLayer = NO;
                break;
            }
        }
        
        if (allTouchesAreOnTheCaptureVideoPreviewLayer) {
            
            self.effectiveScale = self.beginScale * recognizer.scale;
            
            if (self.effectiveScale < 1.0f) {
                self.effectiveScale = 1.0f;
            }
            
//            CGFloat imageMaxScaleAndCropFactor = [[self.imageOutput connectionWithMediaType:AVMediaTypeVideo] videoMaxScaleAndCropFactor];
            
            if (self.effectiveScale > imageMaxScaleAndCropFactor) {
                self.effectiveScale = imageMaxScaleAndCropFactor;
            }
            WYLog(@"self.effectiveScale = %f",self.effectiveScale);
            [self setPreviewLayerTransformWithScale:self.effectiveScale];
        }
    }
}

/**
 *  @brief  设置预览图层的放大缩小比例
 */
- (void)setPreviewLayerTransformWithScale:(CGFloat)scale {
    
    self.effectiveScale = scale;
    [CATransaction begin];
    [CATransaction setAnimationDuration:0.25f];
    [self.previewLayer setAffineTransform:CGAffineTransformMakeScale(scale, scale)];
    [CATransaction commit];
}

/**
 *  @brief  点击屏幕，聚焦
 */
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    // 不需要聚焦的情况：聚焦中，旋转摄像头中，查看视频或者图片的时候
    if (_isFocusing || touches.count == 0 || _isRotatingCamera || _previewContainerView) {
        return;
    }
    
    UITouch *touch = nil;
    
    for (UITouch *t in touches) {
        touch = t;
        break;
    }
    
    CGPoint point = [touch locationInView:self.view];
    
    if (point.y > self.tipLabel.bottom_WY || point.y < 70) {
        return;
    }
    
    [self setFocusCursorWithPoint:point];
}

/**
 设置聚焦光标位置

 @param point 光标位置
 */
- (void)setFocusCursorWithPoint:(CGPoint)point {
    
    self.isFocusing = YES;
    
    self.focusImageView.center = point;
    self.focusImageView.transform = CGAffineTransformMakeScale(1.5, 1.5);
    self.focusImageView.alpha = 1;
    
    // 将 UI 坐标转换为摄像头坐标
    CGPoint cameraPoint = [self.previewLayer captureDevicePointOfInterestForPoint:point];
    [self focusWithPoint:cameraPoint];
 
    WeakSelf
    
    [UIView animateWithDuration:0.5 animations:^{
        
        weakSelf.focusImageView.transform = CGAffineTransformIdentity;
        
    } completion:^(BOOL finished) {
        
        weakSelf.focusImageView.alpha = 0;
        
        weakSelf.isFocusing = NO;
    }];
}

/**
 设置相机聚焦

 @param point 聚焦点
 */
- (void)focusWithPoint:(CGPoint)point {
    
    AVCaptureDevice *captureDevice = [self.input device];
    
    NSError *error;
    
    // 注意改变设备属性前一定要首先调用lockForConfiguration:
    // 调用完之后使用unlockForConfiguration解锁
    if ([captureDevice lockForConfiguration:&error]) {
        
        // 聚焦
        if ([captureDevice isFocusModeSupported:AVCaptureFocusModeAutoFocus]) {
            [captureDevice setFocusMode:AVCaptureFocusModeAutoFocus];
        }
        if ([captureDevice isFocusPointOfInterestSupported]) {
            [captureDevice setFocusPointOfInterest:point];
        }
        
        // 曝光
        if ([captureDevice isExposureModeSupported:AVCaptureExposureModeAutoExpose]) {
            [captureDevice setExposureMode:AVCaptureExposureModeAutoExpose];
        }
        if ([captureDevice isExposurePointOfInterestSupported]) {
            [captureDevice setExposurePointOfInterest:point];
        }
        
    } else {
        WYLog(@"设置设备属性过程发生错误，错误信息：%@",error.localizedDescription);
    }
}

/**
 *  @brief  提示语动画
 */
- (void)tipLabelAnimation {
    
    [self.view bringSubviewToFront:self.tipLabel];
    
    WeakSelf
    
    [UIView animateWithDuration:1.0f delay:0.5f options:UIViewAnimationOptionCurveEaseInOut animations:^{
        
        [weakSelf.tipLabel setAlpha:1.0];
        
    } completion:^(BOOL finished) {
        
        [UIView animateWithDuration:1.0f delay:3.0f options:UIViewAnimationOptionCurveEaseInOut animations:^{
            
            [weakSelf.tipLabel setAlpha:0];
            
        } completion:nil];
    }];
}

#pragma mark - 重力感应相关

/**
 *  @brief  开始监听屏幕方向
 */
- (void)startMonitorTheScreenOrientation {
    
    if ([self.motionManager isAccelerometerAvailable] == YES) { // 加速度计是否可用
        // 设置采样间隔
        [self.motionManager setAccelerometerUpdateInterval:1.0];
        // 开始采样(采样到数据就会调用handler,handler会在queue中执行)
        [self.motionManager startAccelerometerUpdatesToQueue:[NSOperationQueue currentQueue] withHandler:^(CMAccelerometerData * _Nullable accelerometerData, NSError * _Nullable error) {
            
            // 如果在block中执行较好时的操作，queue最好不是主队列
            // 如果在block中要刷新UI界面，queue最好是主队列
            WYLog(@"%f %f %f", accelerometerData.acceleration.x, accelerometerData.acceleration.y, accelerometerData.acceleration.z);
            
            double x = accelerometerData.acceleration.x;
            double y = accelerometerData.acceleration.y;
            
            if (fabs(y) >= fabs(x)) {
                
                if (y >= 0) {
                    // Home键在上面
                    _deviceOrientation = UIDeviceOrientationPortraitUpsideDown;
                    WYLog(@"Home键在上面");
                    [self rotateSwitchCameraButton:M_PI];
                } else {
                    // Home键在下面
                    _deviceOrientation = UIDeviceOrientationPortrait;
                    WYLog(@"Home键在下面");
                    [self rotateSwitchCameraButton:0];
                }
            } else {
                
                if (x >= 0) {
                    // Home键在左边
                    _deviceOrientation = UIDeviceOrientationLandscapeRight;
                    WYLog(@"Home键在左边");
                    [self rotateSwitchCameraButton:-M_PI / 2];
                } else {
                    // Home键在右边
                    _deviceOrientation = UIDeviceOrientationLandscapeLeft;
                    WYLog(@"Home键在右边");
                    [self rotateSwitchCameraButton:M_PI / 2];
                }
            }
        }];
    }
}

/**
 *  @brief  停止监听屏幕方向
 */
- (void)stopMonitorTheScreenOrientation {
    
    if ([self.motionManager isAccelerometerActive] == YES) {
        
        [self.motionManager stopAccelerometerUpdates];
        _motionManager = nil;
    }
}

/**
 根据屏幕方向旋转切换镜头按钮

 @param angle 旋转角度
 */
- (void)rotateSwitchCameraButton:(CGFloat)angle {
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        [self.switchCameraButton setTransform:CGAffineTransformRotate(CGAffineTransformIdentity, angle)];
    }];
    
}

#pragma mark - 判断用户是否允许访问麦克风
- (void)requestAuthorizationForAudio {
    
    // 获取麦克风权限
    AVAuthorizationStatus audioAuthStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
    
    if (audioAuthStatus == AVAuthorizationStatusNotDetermined) { // 用户还没决定
        
    } else if (audioAuthStatus != AVAuthorizationStatusAuthorized) { // 用户拒绝授权
        NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
        
        NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];
        
        if (!appName) {
            appName = @"APP";
        }
        
        NSString *message = [NSString stringWithFormat:@"允许%@访问您的麦克风?",appName];
        
        [WYUtils showConfirmAlertWithTitle:nil message:message yesTitle:@"确定" yesAction:^{
            // 跳到设置界面
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        } cancelTitle:@"取消" cancelAction:^{
            
        }];
    }}

#pragma mark - 判断用户是否允许访问相册
- (void)requestAuthorizationForLibrary {
    
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];

    if (authStatus != PHAuthorizationStatusAuthorized) { // 未授权或者拒绝授权

        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {

            if (status == PHAuthorizationStatusRestricted || status == PHAuthorizationStatusDenied) { // 拒绝授权
                NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];

                NSString *appName = [infoDictionary objectForKey:@"CFBundleDisplayName"];

                if (!appName) {
                    appName = @"APP";
                }

                NSString *message = [NSString stringWithFormat:@"允许%@访问您的相册?",appName];

                [WYUtils showConfirmAlertWithTitle:nil message:message yesTitle:@"确定" yesAction:^{
                    // 跳到设置界面
                    NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];

                    if ([[UIApplication sharedApplication] canOpenURL:url]) {
                        [[UIApplication sharedApplication] openURL:url];
                    }
                } cancelTitle:@"取消" cancelAction:^{

                }];
            }

        }];
    }
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
