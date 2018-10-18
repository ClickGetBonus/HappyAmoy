//
//  QHConst.h
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**    云通信的appId  */
UIKIT_EXTERN NSString *const TimAppId;

/**    标题栏被重复点击的通知名称  */
UIKIT_EXTERN NSString *const TabbarTitleButtonDidRepeatClickNotificationName;

/**    列表每次请求的条数  */
UIKIT_EXTERN NSInteger const PageSize;

/**    默认日期格式  */
UIKIT_EXTERN NSString *const wy_dateFormatter;

/**    个人资料变化的通知  */
UIKIT_EXTERN NSString *const PersonalDataDidChangeNotification;

/**    编辑个人资料的通知  */
UIKIT_EXTERN NSString *const PersonalDataDidEditedNotification;

/**    七牛样式分隔符  */
UIKIT_EXTERN NSString *const QiNiuImageStyleSeparator;
/**    七牛 image 正方形的缩略图图片样式  */
UIKIT_EXTERN NSString *const QiNiuImageThumbSquareStyle;
/**    七牛 image 长方形的缩略图图片样式（宽度比高度长）  */
UIKIT_EXTERN NSString *const QiNiuImageThumbHorizontalStyle;
/**    七牛 image 长方形的缩略图图片样式（高度比宽度长）  */
UIKIT_EXTERN NSString *const QiNiuImageThumbVerticalStyle;
/**    七牛 video 正方形的缩略图图片样式  */
UIKIT_EXTERN NSString *const QiNiuVideoThumbSquareStyle;
/**    七牛 video 长方形的缩略图图片样式（宽度比高度长）  */
UIKIT_EXTERN NSString *const QiNiuVideoThumbHorizontalStyle;
/**    七牛 video 长方形的缩略图图片样式（高度比宽度长）  */
UIKIT_EXTERN NSString *const QiNiuVideoThumbVerticalStyle;

/**    取消收藏的通知名称  */
UIKIT_EXTERN NSString *const MyCollectDidCancelNotificationName;

/**    支付成功的通知  */
UIKIT_EXTERN NSString *const PaySuccessNotificationName;

/**    钱包变动的通知  */
UIKIT_EXTERN NSString *const WalletDidChangeNotificationName;

/**    微信登录后绑定手机号码的通知  */
UIKIT_EXTERN NSString *const BindMobileAfterWeChatLoginNotificationName;

/**    收货地址发生变化的通知  */
UIKIT_EXTERN NSString *const AddressHaveChangedNotificationName;
