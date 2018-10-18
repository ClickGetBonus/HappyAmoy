//
//  NewBrandTypeCell.h
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewBrandTypeCell;
@class CommodityCategoriesItem;

@protocol NewBrandTypeCellDelegate <NSObject>

@optional

- (void)newBrandTypeCell:(NewBrandTypeCell *)newBrandTypeCell didSelectItem:(CommodityCategoriesItem *)item;

@end

@interface NewBrandTypeCell : UICollectionViewCell

/**    代理    */
@property (weak, nonatomic) id<NewBrandTypeCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end

