//
//  GoodsClassifiCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class GoodsClassifiCell;
@class CommodityCategoriesItem;

@protocol GoodsClassifiCellDelegate <NSObject>

@optional

- (void)goodsClassifiCell:(GoodsClassifiCell *)goodsClassifiCell didSelectItem:(CommodityCategoriesItem *)item;

@end

@interface GoodsClassifiCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<GoodsClassifiCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end
