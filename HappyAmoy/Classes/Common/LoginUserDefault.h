//
//  LoginUserDefault.h
//  DianDian
//
//  Created by apple on 17/10/11.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@class UserItem;
@class VersionItem;

@interface LoginUserDefault : NSObject

+ (instancetype)userDefault;

- (void)setDataWithDict:(NSDictionary *)dict;

/**    用户信息    */
@property (strong, nonatomic) UserItem *userItem;
/**    版本模型    */
@property (strong, nonatomic) VersionItem *versionItem;
/**    客服电话    */
@property (copy, nonatomic) NSString *consumerHotline;
/**    推送的消息    */
@property (strong, nonatomic) NSDictionary *pushDict;
/**    地区数组    */
@property (strong, nonatomic) NSArray *areasArray;
/**    标记是否是游客模式    */
@property (assign, nonatomic) BOOL isTouristsMode;
/**    标记个人信息是否发生变化    */
@property (assign, nonatomic) BOOL dataHaveChanged;
/**    分享的图片数组    */
@property (strong, nonatomic) NSMutableArray *shareImageArray;
/**    会员奖励    */
@property (copy, nonatomic) NSString *reward;
/**    消费积分    */
@property (copy, nonatomic) NSString *consumePoint;
/**    会员福利    */
@property (copy, nonatomic) NSString *walfare;
/**    我的钱包    */
@property (copy, nonatomic) NSString *wallet;
/**    标记是否跳转到了登陆界面    */
@property (assign, nonatomic) BOOL isLoginVc;
/**    标记是否更新了版本内容    */
@property (assign, nonatomic) BOOL versionDataHaveChanged;
/**    标记首页是否弹框    */
@property (assign, nonatomic) BOOL isShowPopupOfHome;


@end
