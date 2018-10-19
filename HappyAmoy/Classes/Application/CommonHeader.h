//
//  CommonHeader.h
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#ifndef CommonHeader_h
#define CommonHeader_h

/********************* 公共 *********************/
/** 声明weakSelf */
#define WeakSelf __weak typeof(self) weakSelf = self;
/** 系统版本号 */
#define SystemVersion [[UIDevice currentDevice].systemVersion floatValue]
/** 获取APP名称 */
#define APP_NAME ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleDisplayName"])
/** 程序版本号 */
#define APP_VERSION [[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleShortVersionString"]
/** 获取APP build版本 */
#define APP_BUILD ([[[NSBundle mainBundle] infoDictionary] objectForKey:@"CFBundleVersion"])
// 判断设备型号
#define UI_IS_LANDSCAPE         ([UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeLeft || [UIDevice currentDevice].orientation == UIDeviceOrientationLandscapeRight)
#define UI_IS_IPAD              ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPad)
#define UI_IS_IPHONE            ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
#define UI_IS_IPHONE4           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define UI_IS_IPHONE5           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 568.0)
#define UI_IS_IPHONE6           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 667.0)
#define UI_IS_IPHONE6PLUS       (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 736.0 || [[UIScreen mainScreen] bounds].size.width == 736.0) // Both orientations
#define UI_IS_IPHONEX           (UI_IS_IPHONE && [[UIScreen mainScreen] bounds].size.height == 812.0)

// 版本 1.0.0 的 APP 密钥
#define AppSecret @"yO4PhXt8n4WLEGU4MdxL9TPjgH42ICe7"
//默认动画时间，单位秒
#define DEFAULT_DURATION 0.25

/********************* 公共 *********************/


/********************* Frame *********************/
#define SCREEN_WIDTH [UIScreen mainScreen].bounds.size.width
#define SCREEN_HEIGHT [UIScreen mainScreen].bounds.size.height
#define SCREEN_FRAME [UIScreen mainScreen].bounds
#define AUTOSIZESCALEX(x) (x * [UIScreen mainScreen].bounds.size.width / 375.f)
#define AUTOSIZESCALEY(y) (y * [UIScreen mainScreen].bounds.size.height / 667.f)
/** Tabbar的高度 */
#define kTabbar_Bottum_Height 49.f
/** 状态栏高度 */
#define kStatus_Height (SCREEN_HEIGHT == 812.0 ? 44 : 20)
/** 导航栏高度 */
#define kNavHeight (SCREEN_HEIGHT == 812.0 ? 88 : 64)
/** iPhone X 底部的安全区域 */
#define SafeAreaBottomHeight (SCREEN_HEIGHT == 812.0 ? 34 : 0)
// 分割线的高度
#define SeparatorLineHeight 0.5
// section 的高度
#define SectionHeight 5
// 发布图片 item 的宽高
#define PublishItemWH ((SCREEN_WIDTH - AUTOSIZESCALEX(15) * 2 - AUTOSIZESCALEX(15) * 2 - AUTOSIZESCALEX(10) * 3) / 4)
// 发布的 item 的 minimumInteritemSpacing
#define PublishItemMinimumInteritemSpacing AUTOSIZESCALEX(5)
// 发布的 item 的 minimumLineSpacing
#define PublishItemMinimumLineSpacing AUTOSIZESCALEX(6.5)
// 动态-内容的左间距
#define DynamicContentLeftSpace AUTOSIZESCALEX(24)
// 动态-图片的高度
#define DynamicImageItemWH ((SCREEN_WIDTH - DynamicContentLeftSpace * 2 - AUTOSIZESCALEX(5) * 2) / 3)
// 动态-只有一张图片的长边
#define DynamicOneImageLongWH ((SCREEN_WIDTH - 2 * DynamicContentLeftSpace) * 3 / 5)
// 动态-只有一张图片的短边
#define DynamicOneImageShortWH ((SCREEN_WIDTH - 2 * DynamicContentLeftSpace) * 3 / 5 * 3 / 5)

// 动态-图片的间距
#define DynamicImageItemSpace AUTOSIZESCALEX(5)
// 文字内容的行间距
#define TextLineSpacing AUTOSIZESCALEX(5)
// 一般的间距
#define NormalMargin AUTOSIZESCALEX(10)
// 爱好标签的宽度
#define HobbyTagViewWidth (SCREEN_WIDTH * 0.65)

/********************* Frame *********************/


/********************* 字体 *********************/

// 普通字体
#define TextFont(f) [UIFont systemFontOfSize:(AUTOSIZESCALEX(f))]
// 粗体
#define TextFontBold(f) [UIFont boldSystemFontOfSize:(AUTOSIZESCALEX(f))]
// 字体样式名称
#define FontStyleFamilyName @"ShiShangZhongHeiJianTi"
#define FontStyleName @"TRENDS"
// 设置字体样式
#define AppMainTextFont(f) [UIFont fontWithName:FontStyleName size:(AUTOSIZESCALEX(f))]
// 动态内容的字体大小
#define DynamicContentFont TextFont(14)

/********************* 字体 *********************/


/********************* 颜色 *********************/
#define RGBA(r, g, b, a) [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
#define RGB(r, g, b) RGBA(r, g, b, 1.0)
// 随机颜色
#define RandomColor RGB(arc4random_uniform(255), arc4random_uniform(255), arc4random_uniform(255))
// 线条颜色
#define LineColor RGB(220, 220, 220)
// 控制器的背景颜色
#define ViewControllerBackgroundColor RGB(240, 240, 240)
// 设置16进制颜色
#define ColorWithHexString(c) [UIColor colorWithHexString:c]
// APP的主色调
#define QHMainColor RGB(255, 180, 43)
// 价格色
#define QHPriceColor RGB(215, 83, 79)
// tableFooterView的背景颜色
#define FooterViewBackgroundColor RGB(244, 244, 244)
// 分割线的背景颜色
#define SeparatorLineColor RGB(220, 220, 220)
// APP的黑色
#define QHBlackColor ColorWithHexString(@"#0C0C0D")
// APP的白色
#define QHWhiteColor ColorWithHexString(@"#FFFFFF")
// APP的透明色
#define QHClearColor [UIColor clearColor]
/********************* 颜色 *********************/


/********************* Image *********************/
#define ImageWithNamed(n) [UIImage imageNamed:n]
// 占位头像
#define PlaceHolderImage ImageWithNamed(@"默认头像")
// 占位主图
#define PlaceHolderMainImage ImageWithNamed(@"gray_Placeholder")

/********************* Image *********************/


/********************* 文件目录 *********************/
#define kTempPath                   NSTemporaryDirectory()
#define kDocumentPath               [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0]
#define kCachePath                  [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) objectAtIndex:0]
// 缓存路径
#define CachePath [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) firstObject]
// Crash日志存放路径
#define CrashMessagePath [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"CrashMessage.txt"]

/********************* 文件目录 *********************/


/********************* 上传 *********************/

// 七牛上传成功的状态码
#define QiNiuUploadSuccessCode 200
// 七牛原图的 bucket
#define QiNiuImageBucket @"image"
// 七牛音频的 bucket
#define QiNiuAudioBucket @"audio"
// 七牛文件的 bucket
#define QiNiuFileBucket @"file"
// 七牛缩略图的 bucket
#define QiNiuThumbBucket @"thumb"
// 七牛视频的 bucket
#define QiNiuVideoBucket @"video"

// 缓存的图片格式
#define CacheImageType @".png"
// 缓存的视频格式
#define CacheVideoType @".MOV"
// 拍摄的视频格式
#define TakeVideoType @".mp4"
// 拍摄的视频路径
#define TakeVideoPath @"Video"
// 视频的最大时长
#define VIDEO_RECORDER_MAX_TIME 30.0f                               //视频最大时长 (单位/秒)
#define VIDEO_RECORDER_MIN_TIME 0.5f                                //最短视频时长 (单位/秒)

// 上传图片原图路径
#define UploadOriginalImagePath @"Upload/Image/Original"
// 上传图片缩略图路径
#define UploadThumbImagePath @"Upload/Image/Thumb"
// 聊天语音格式
#define ChatRecoderType @".wav"
// 聊天语音路径
#define ChatRecorderPath @"Chat/Recoder"
// 聊天图片路径
#define ChatImagePath @"Chat/Image"
// 聊天视频路径
#define ChatVideoPath @"Chat/Video"
// 缩略图的大小
#define ThumbImageMaxSize 50.0
// 上传图片的最大数量
#define MaxImageCount 9


/********************* 上传 *********************/


/********************* 打印 *********************/
// 打印调用函数
#define WYFunc WYLog(@"%s",__func__);

#ifdef DEBUG
#define WYLog(FORMAT, ...) fprintf(stderr,"%s:%d\t%s\n",[[[NSString stringWithUTF8String:__FILE__] lastPathComponent] UTF8String], __LINE__, [[NSString stringWithFormat:FORMAT, ##__VA_ARGS__] UTF8String]);
#else
#define WYLog(...)
#endif
/********************* 打印 *********************/

#endif /* CommonHeader_h */
