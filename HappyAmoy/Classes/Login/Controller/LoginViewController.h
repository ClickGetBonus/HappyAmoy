//
//  LoginViewController.h
//  HappyAmoy
//
//  Created by apple on 2018/4/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@interface LoginViewController : BaseViewControll

/**    标记是否是从退出登录跳转过来的    */
@property (assign, nonatomic) BOOL comeFromLoginOut;
/**    登录的回调    */
@property (copy, nonatomic) void(^loginCallBack)(void);

@end
