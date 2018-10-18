//
//  GlobalSearchListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

//@class TaoBaoSearchItem;
@class SearchGoodsItem;

@class GlobalSearchListCell;

@protocol GlobalSearchListCellDelegate <NSObject>

@optional

//- (void)globalSearchListCell:(GlobalSearchListCell *)globalSearchListCell didClickShareButton:(TaoBaoSearchItem *)item;
//- (void)globalSearchListCell:(GlobalSearchListCell *)globalSearchListCell didClickBuyButton:(TaoBaoSearchItem *)item;
- (void)globalSearchListCell:(GlobalSearchListCell *)globalSearchListCell didClickShareButton:(SearchGoodsItem *)item;
- (void)globalSearchListCell:(GlobalSearchListCell *)globalSearchListCell didClickBuyButton:(SearchGoodsItem *)item;
@end

@interface GlobalSearchListCell : UICollectionViewCell

/**    淘宝客全局搜索的数据模型    */
//@property(nonatomic,strong) TaoBaoSearchItem *searchItem;
@property(nonatomic,strong) SearchGoodsItem *searchItem;

/**    代理    */
@property(nonatomic,weak) id<GlobalSearchListCellDelegate> delegate;

@end
