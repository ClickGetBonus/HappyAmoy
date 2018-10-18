//
//  QHConst.m
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

/**    云通信的appId  */
NSString *const TimAppId = @"1400078168";

/**    标题栏被重复点击的通知名称  */
NSString *const TabbarTitleButtonDidRepeatClickNotificationName = @"TabbarTitleButtonDidRepeatClickNotificationName";

/**    列表每次请求的条数  */
NSInteger const PageSize = 10;

/**    默认日期格式  */
NSString *const wy_dateFormatter = @"yyyy-MM-dd HH:mm:ss";

/**    个人资料改变的通知  */
NSString *const PersonalDataDidChangeNotification = @"PersonalDataDidChangeNotification";

/**    编辑个人资料的通知  */
NSString *const PersonalDataDidEditedNotification = @"PersonalDataDidEditedNotification";

/**    七牛样式分隔符  */
NSString *const QiNiuImageStyleSeparator = @"-";
/**    七牛 image 正方形的缩略图图片样式  */
NSString *const QiNiuImageThumbSquareStyle = @"imageThumb";
/**    七牛 image 长方形的缩略图图片样式（宽度比高度长）  */
NSString *const QiNiuImageThumbHorizontalStyle = @"imageThumbHorizontal";
/**    七牛 image 长方形的缩略图图片样式（高度比宽度长）  */
NSString *const QiNiuImageThumbVerticalStyle = @"imageThumbVertical";
/**    七牛 video 正方形的缩略图图片样式  */
NSString *const QiNiuVideoThumbSquareStyle = @"videoThumbSquare";
/**    七牛 video 长方形的缩略图图片样式（宽度比高度长）  */
NSString *const QiNiuVideoThumbHorizontalStyle = @"videoThumbHorizontal";
/**    七牛 video 长方形的缩略图图片样式（高度比宽度长）  */
NSString *const QiNiuVideoThumbVerticalStyle = @"videoThumbVertical";

/**    取消收藏的通知名称  */
NSString *const MyCollectDidCancelNotificationName = @"MyCollectDidCancelNotificationName";

/**    支付成功的通知  */
NSString *const PaySuccessNotificationName = @"PaySuccessNotificationName";

/**    钱包变动的通知  */
NSString *const WalletDidChangeNotificationName = @"WalletDidChangeNotificationName";

/**    微信登录后绑定手机号码的通知  */
NSString *const BindMobileAfterWeChatLoginNotificationName = @"BindMobileAfterWeChatLoginNotificationName";

/**    收货地址发生变化的通知  */
NSString *const AddressHaveChangedNotificationName = @"AddressHaveChangedNotificationName";

