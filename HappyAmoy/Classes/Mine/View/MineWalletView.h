//
//  MineWalletView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineWalletView;

@protocol MineWalletViewDelegate <NSObject>

@optional

- (void)mineWalletView:(MineWalletView *)mineWalletView didClickTurnOutButton:(UIButton *)turnOutButton;

@end

@interface MineWalletView : UIView

/**    余额    */
@property (assign, nonatomic) CGFloat balance;
/**    代理    */
@property (weak, nonatomic) id<MineWalletViewDelegate> delegate;

@end
