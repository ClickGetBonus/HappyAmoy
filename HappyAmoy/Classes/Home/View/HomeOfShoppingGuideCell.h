//
//  HomeOfShoppingGuideCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeOfShoppingGuideCell;

@protocol HomeOfShoppingGuideCellDelegate <NSObject>

@optional

// 购物攻略
- (void)homeOfShoppingGuideCell:(HomeOfShoppingGuideCell *)homeOfShoppingGuideCell didClickShoppingGuideButton:(UIButton *)sender;
// 邀请好友
- (void)homeOfShoppingGuideCell:(HomeOfShoppingGuideCell *)homeOfShoppingGuideCell didClickShareButton:(UIButton *)sender;

@end

@interface HomeOfShoppingGuideCell : UITableViewCell

/**    代理    */
@property(nonatomic,weak) id<HomeOfShoppingGuideCellDelegate> delegate;

@end
