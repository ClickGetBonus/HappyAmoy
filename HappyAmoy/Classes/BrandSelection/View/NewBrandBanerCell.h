//
//  NewBrandBanerCell.h
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewBrandBanerCell;
@class BannerItem;

@protocol NewBrandBanerCellDelegate <NSObject>

@optional

- (void)newBrandBanerCell:(NewBrandBanerCell *)newBrandBanerCell didClickBanner:(BannerItem *)item;

@end

@interface NewBrandBanerCell : UICollectionViewCell

/**    代理    */
@property(nonatomic,weak) id<NewBrandBanerCellDelegate> delegate;
/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;

@end
