//
//  MineHeaderView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSUInteger, BtnType) {
    shareMaisui = 0,
    consumeMaisui,
    maili,
    myWallet,
    waitPay,
    handOut,
    receive,
    reCommand,
    afterSale,
    moreOrder,
    header,
};
@class MineHeaderView;

@protocol MineheaderViewDelegate <NSObject>

@optional

- (void)mineHeaderView:(MineHeaderView *)mineHeaderView editPersonalInfo:(NSString *)info;
- (void)mineHeaderView:(MineHeaderView *)mineHeaderView checkMyCollect:(NSString *)info;
- (void)mineHeaderView:(MineHeaderView *)mineHeaderView checkRecentlyBrowse:(NSString *)info;

@end

@interface MineHeaderView : UIView

/**    代理    */
@property (weak, nonatomic) id<MineheaderViewDelegate> delegate;

/**    余额数组    */
@property (strong, nonatomic) NSMutableArray *balanceArray;

@end
