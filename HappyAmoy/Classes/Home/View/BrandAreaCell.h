//
//  BrandAreaCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandAreaCell;
@class CommodityListItem;

@protocol BrandAreaCellDelegate <NSObject>

@optional

- (void)brandAreaCell:(BrandAreaCell *)brandAreaCell didSelectItem:(CommodityListItem *)item;

@end

@interface BrandAreaCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<BrandAreaCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end
