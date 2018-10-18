//
//  GoodBullClassChildCell.h
//  HappyAmoy
//
//  Created by lb on 2018/9/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@class CommodityBullItem;
@class GoodBullClassChildCell;
@class TaoBaoSearchItem;

@protocol GoodBullClassChildCellDelegate <NSObject>

@optional

- (void)GoodBullClassChildCell:(GoodBullClassChildCell *)goodsListCell didPlayVideo:(CommodityBullItem *)item;
- (void)GoodBullClassChildCell:(GoodBullClassChildCell *)goodsListCell didCancelCollected:(CommodityBullItem *)item;

@end

@interface GoodBullClassChildCell : UICollectionViewCell

/**    券类型    */
@property (copy, nonatomic) NSString *type;
/**    数据模型    */
@property (strong, nonatomic) CommodityBullItem *item;
/**    标记是否是券类型    */
@property (assign, nonatomic) BOOL isCollected;
/**    标记是否是视频类型    */
@property(nonatomic,assign) BOOL isVideoType;
/**    代理    */
@property (weak, nonatomic) id<GoodBullClassChildCellDelegate> delegate;

/**    淘宝客全局搜索的数据模型    */
@property(nonatomic,strong) TaoBaoSearchItem *searchItem;

@end

