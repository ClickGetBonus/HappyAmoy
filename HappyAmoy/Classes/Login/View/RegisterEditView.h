//
//  RegisterEditView.h
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RegisterEditView : UIView

/**    账号    */
@property (copy, nonatomic) NSString *account;
/**    密码    */
@property (copy, nonatomic) NSString *password;
/**    邀请码    */
@property (copy, nonatomic) NSString *invitatedCode;
/**    用户输入的验证码    */
@property (copy, nonatomic) NSString *msgCode;
/**    服务器返回的验证码    */
@property (copy, nonatomic) NSString *msgCodeOfRequest;

@end
