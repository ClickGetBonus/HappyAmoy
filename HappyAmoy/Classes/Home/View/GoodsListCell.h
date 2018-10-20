//
//  GoodsListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityListItem;
@class GoodsListCell;
@class TaoBaoSearchItem;
@class SearchGoodsItem;

@protocol GoodsListCellDelegate <NSObject>

@optional

- (void)goodsListCell:(GoodsListCell *)goodsListCell didPlayVideo:(CommodityListItem *)item;
- (void)goodsListCell:(GoodsListCell *)goodsListCell didCancelCollected:(CommodityListItem *)item;
- (void)goodsListCell:(GoodsListCell *)goodsListCell didCancelSearchGoodsCollected:(SearchGoodsItem *)item;

@end

@interface GoodsListCell : UICollectionViewCell

/**    券类型    */
@property (copy, nonatomic) NSString *type;
/**    数据模型    */
@property (strong, nonatomic) CommodityListItem *item;
/**    标记是否是券类型    */
@property (assign, nonatomic) BOOL isCollected;
/**    标记是否是视频类型    */
@property(nonatomic,assign) BOOL isVideoType;
/**    代理    */
@property (weak, nonatomic) id<GoodsListCellDelegate> delegate;

/**    淘宝客全局搜索的数据模型    */
@property(nonatomic,strong) TaoBaoSearchItem *searchItem;

/**    搜索商品的数据模型    */
@property(nonatomic,strong) SearchGoodsItem *searchGoodsItem;


@end
