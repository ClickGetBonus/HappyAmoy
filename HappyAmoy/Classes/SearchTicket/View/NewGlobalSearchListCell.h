//
//  NewGlobalSearchListCell.h
//  HappyAmoy
//
//  Created by VictoryLam on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchGoodsItem;
@class NewGlobalSearchListCell;
NS_ASSUME_NONNULL_BEGIN

@protocol NewGlobalSearchListCellDelegate <NSObject>

@optional

- (void)newGlobalSearchListCell:(NewGlobalSearchListCell *)newGlobalSearchListCell didClickShareButton:(SearchGoodsItem *)item;
- (void)newGlobalSearchListCell:(NewGlobalSearchListCell *)newGlobalSearchListCell didClickBuyButton:(SearchGoodsItem *)item;
@end
@interface NewGlobalSearchListCell : UICollectionViewCell
/**    数据模型    */
@property (strong, nonatomic) SearchGoodsItem *searchGoodsItem;
/**    代理    */
@property (weak, nonatomic) id<NewGlobalSearchListCellDelegate> delegate;


@end

NS_ASSUME_NONNULL_END
