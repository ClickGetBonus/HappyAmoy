//
//  BindPhoneView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface BindPhoneView : UIView

/**    手机号    */
@property (copy, nonatomic) NSString *phoneNumber;
/**    验证码    */
@property (copy, nonatomic) NSString *msgCode;
/**    服务器返回的验证码    */
@property (copy, nonatomic) NSString *msgCodeOfRequest;


@end
