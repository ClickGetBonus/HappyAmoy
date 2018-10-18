//
//  NewBrandImportCell.h
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewBrandImportCell;
@class CommodityListItem;

@protocol NewBrandImportCellDelegate <NSObject>

@optional

- (void)newBrandImportCell:(NewBrandImportCell *)newBrandImportCell didSelectItem:(CommodityListItem *)item;

@end


@interface NewBrandImportCell : UICollectionViewCell

/**    代理    */
@property(nonatomic,weak) id<NewBrandImportCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end
