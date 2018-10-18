//
//  BrandTypeCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandTypeCell;
@class CommodityCategoriesItem;

@protocol BrandTypeCellDelegate <NSObject>

@optional

- (void)brandTypeCell:(BrandTypeCell *)brandTypeCell didSelectItem:(CommodityCategoriesItem *)item;

@end

@interface BrandTypeCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<BrandTypeCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end
