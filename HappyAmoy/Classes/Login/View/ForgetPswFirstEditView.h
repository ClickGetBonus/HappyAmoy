//
//  ForgetPswFirstEditView.h
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ForgetPswFirstEditView : UIView

/**    账号    */
@property (copy, nonatomic) NSString *account;
/**    验证码    */
@property (copy, nonatomic) NSString *msgCode;
/**    服务器返回的验证码    */
@property (copy, nonatomic) NSString *msgCodeOfRequest;

@end
