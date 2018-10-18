//
//  HomePopupsView.h
//  HappyAmoy
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomePopupsView : UIView

/**    点击图片的回调    */
@property(nonatomic,copy) void(^clickIconCallBack)(void);

/**    取消的回调    */
@property(nonatomic,copy) void(^cancelCallBack)(void);

/**
 *  @brief  显示弹框
 */
- (void)show;

/**
 *  @brief  消失弹框
 */
- (void)dismiss;

@end
