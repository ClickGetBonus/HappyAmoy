//
//  ConsumPointView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ConsumPointView;

@protocol ConsumPointViewDelegate <NSObject>

@optional
// 转入钱包余额
- (void)consumPointView:(ConsumPointView *)consumPointView scoreToWallet:(NSInteger)currentScore;

@end

@interface ConsumPointView : UIView

/**    累计转换金额    */
@property (assign, nonatomic) CGFloat convertedAmount;
/**    当前积分    */
@property (assign, nonatomic) NSInteger currentScore;
/**    在路上的积分    */
@property (assign, nonatomic) NSInteger goingScore;
/**    积分转换    */
@property (assign, nonatomic) NSInteger changeScore;
/**    代理    */
@property (weak, nonatomic) id<ConsumPointViewDelegate> delegate;

@end
