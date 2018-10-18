//
//  WYHud.h
//  GridBaseApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 strongit.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYHud : UIView


/**
 显示提示框

 @param message 提示消息，默认1.0秒后消失
 */
+ (void)showMessage:(NSString *)message;


/**
 显示提示框

 @param message 提示消息
 @param duration 显示框的显示时间
 */
+ (void)showMessage:(NSString *)message duration:(NSInteger)duration;

@end
