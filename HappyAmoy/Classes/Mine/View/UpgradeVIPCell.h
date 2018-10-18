//
//  UpgradeVIPCell.h
//  HappyAmoy
//
//  Created by apple on 2018/5/7.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class UpgradeVIPCell;

@protocol UpgradeVIPCellDelegate <NSObject>

@optional

- (void)upgradeVIPCell:(UpgradeVIPCell *)upgradeVIPCell didSelectedPayWay:(NSInteger)payWay;

- (void)upgradeVIPCell:(UpgradeVIPCell *)upgradeVIPCell didClickBack:(UIButton *)sender;

@end

@interface UpgradeVIPCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<UpgradeVIPCellDelegate> delegate;

@end
