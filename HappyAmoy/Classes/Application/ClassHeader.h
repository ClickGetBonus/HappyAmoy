//
//  ClassHeader.h
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#ifndef ClassHeader_h
#define ClassHeader_h

#ifdef __OBJC__     // 判断一下，之后OC文件才会导入下面的头文件

/********************* 分类 *********************/
#import "UIView+Frame.h"
#import "UIImage+Image.h"
#import "UIBarButtonItem+Item.h"
#import "NSString+MD5Addition.h"
#import "UIColor+Hex.h"
#import "UIView+QuickView.h"
#import "NSString+TextHelper.h"
#import "NSString+Time.h"
#import "NSDictionary+extension.h"
#import "NSArray+extension.h"
#import "NSString+TextHelper.h"
#import "UILabel+WYDefine.h"
#import "NSDate+WYCore.h"
#import "UIImageView+WYWebImage.h"
#import "NSString+Json.h"
#import "UINavigationBar+Awesome.h"
#import "NSString+WordMixFace.h"
#import "UIButton+Gradient.h"
#import "UIImage+Gradient.h"
/********************* 分类 *********************/


/********************* 公共类 *********************/
#import "NetworkSingleton.h"
#import "LoginUserDefault.h"
#import "WYUMShareMnager.h"
#import "UserItem.h"
#import "WYCarouselView.h"
/********************* 公共类 *********************/


/********************* 工具类 *********************/
#import "WYUserDefaultManager.h"
#import "WYHud.h"
#import "WYProgress.h"
#import "WYUtils.h"
#import "WYFileTool.h"
#import "WYUploader.h"
#import "WYCameraController.h"
#import "WYPackagePhotoBrowser.h"
#import "YBPopupMenu.h"
#import "LoginUtil.h"
#import "WYPhotoLibraryManager.h"
#import "AliPay.h"
/********************* 工具类 *********************/


/********************* 第三方框架 *********************/
#import <AFNetworking/AFNetworking.h>
#import <MJExtension/MJExtension.h>
#import <MJRefresh/MJRefresh.h>
#import <Masonry/Masonry.h>
#import <YYText/YYText.h>
#import "TZImagePickerController.h"
#import "SDWebImage/UIImageView+WebCache.h"
#import "GKPhotoBrowser.h"
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UIScrollView+EmptyDataSet.h"
#import <SDCycleScrollView/SDCycleScrollView.h>
#import <DTCoreText/DTCoreText.h>
/********************* 第三方框架 *********************/


#endif // OC文件判断结束


#endif /* ClassHeader_h */
