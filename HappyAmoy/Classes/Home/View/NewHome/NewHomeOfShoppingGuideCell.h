//
//  NewHomeOfShoppingGuideCell.h
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewHomeOfShoppingGuideCell;

@protocol NewHomeOfShoppingGuideCellDelegate <NSObject>

@optional

// 购物攻略
- (void)newHomeOfShoppingGuideCell:(NewHomeOfShoppingGuideCell *)newHomeOfShoppingGuideCell didClickShoppingGuideButton:(UIButton *)sender;
// 邀请好友
- (void)newHomeOfShoppingGuideCell:(NewHomeOfShoppingGuideCell *)newHomeOfShoppingGuideCell didClickShareButton:(UIButton *)sender;

@end

@interface NewHomeOfShoppingGuideCell : UICollectionViewCell

/**    代理    */
@property(nonatomic,weak) id<NewHomeOfShoppingGuideCellDelegate> delegate;

@end

