//
//  UpdateVersionView.h
//  HappyAmoy
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UpdateVersionView;

@protocol UpdateVersionViewDelegate <NSObject>

@optional

- (void)updateVersionView:(UpdateVersionView *)updateVersionView didClcikUpdateButton:(UIButton *)sender;

@end

@interface UpdateVersionView : UIView

/**    代理    */
@property (weak, nonatomic) id<UpdateVersionViewDelegate> delegate;
/**    更新说明    */
@property (copy, nonatomic) NSString *updateDesc;

- (void)show;

@end
