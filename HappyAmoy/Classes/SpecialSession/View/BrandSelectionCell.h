//
//  BrandSelectionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandSelectionCell;
@class CommodityListItem;

@protocol BrandSelectionCellDelegate <NSObject>

@optional

- (void)brandSelectionCell:(BrandSelectionCell *)brandSelectionCell didSelectItem:(CommodityListItem *)item;

@end

@interface BrandSelectionCell : UITableViewCell

/**    代理    */
@property(nonatomic,weak) id<BrandSelectionCellDelegate> delegate;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end
