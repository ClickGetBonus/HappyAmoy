//
//  NewHomeOfNetRedCell.h
//  HappyAmoy
//
//  Created by apple on 2018/8/2.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewHomeOfNetRedCell;
@class CommoditySpecialCategoriesItem;

@protocol NewHomeOfNetRedCellDelegate <NSObject>

@optional

- (void)newHomeOfNetRedCell:(NewHomeOfNetRedCell *)newHomeOfNetRedCell didSelectItem:(CommoditySpecialCategoriesItem *)item;

@end

@interface NewHomeOfNetRedCell : UICollectionViewCell

/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    代理    */
@property(nonatomic,weak) id<NewHomeOfNetRedCellDelegate> delegate;

@end
