//
//  BrandImportCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandImportCell;
@class CommodityListItem;

@protocol BrandImportCellDelegate <NSObject>

@optional

- (void)brandImportCell:(BrandImportCell *)brandImportCell didSelectItem:(CommodityListItem *)item;

@end


@interface BrandImportCell : UITableViewCell

/**    代理    */
@property(nonatomic,weak) id<BrandImportCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end
