//
//  GoodsDetailInfoCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityDetailItem;
@class GoodsDetailInfoCell;
@class TaoBaoSearchItem;

@protocol GoodsDetailInfoCellDelegate <NSObject>

@optional

- (void)goodsDetailInfoCell:(GoodsDetailInfoCell *)goodsDetailInfoCell takeTicket:(CommodityDetailItem *)item;

@end

@interface GoodsDetailInfoCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<GoodsDetailInfoCellDelegate> delegate;
/**    数据模型    */
@property (strong, nonatomic) CommodityDetailItem *item;
/**    全网搜索的数据模型    */
@property(nonatomic,strong) TaoBaoSearchItem *searchItem;

@end
