//
//  BrandBanerCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BrandBanerCell;
@class BannerItem;

@protocol BrandBanerCellDelegate <NSObject>

@optional

- (void)brandBanerCell:(BrandBanerCell *)brandBanerCell didClickBanner:(BannerItem *)item;

@end

@interface BrandBanerCell : UITableViewCell

/**    代理    */
@property(nonatomic,weak) id<BrandBanerCellDelegate> delegate;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end
