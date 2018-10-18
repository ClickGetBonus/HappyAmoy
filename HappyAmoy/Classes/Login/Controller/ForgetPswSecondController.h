//
//  ForgetPswSecondController.h
//  HappyAmoy
//
//  Created by apple on 2018/5/1.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@interface ForgetPswSecondController : BaseViewControll

/**    手机号    */
@property (copy, nonatomic) NSString *mobile;
/**    验证码    */
@property (copy, nonatomic) NSString *smsCode;

@end
