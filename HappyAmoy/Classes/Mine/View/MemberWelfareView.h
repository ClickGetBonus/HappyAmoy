//
//  MemberWelfareView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberWelfareView;

@protocol MemberWelfareViewDelegate <NSObject>

@optional
// 转入钱包余额
- (void)memberWelfareView:(MemberWelfareView *)memberWelfareView toWallet:(NSInteger)currentScore;

@end


@interface MemberWelfareView : UIView

/**    当前福利余额    */
@property (copy, nonatomic) NSString *balance;
/**    累计的福利    */
@property (copy, nonatomic) NSString *totalBalance;
/**    在路上的福利    */
@property (copy, nonatomic) NSString *goingBalance;


/**    代理    */
@property (weak, nonatomic) id<MemberWelfareViewDelegate> delegate;

@end
