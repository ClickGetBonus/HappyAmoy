//
//  HomeOfNetRedCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HomeOfNetRedCell;
@class CommoditySpecialCategoriesItem;

@protocol HomeOfNetRedCellDelegate <NSObject>

@optional

- (void)homeOfNetRedCell:(HomeOfNetRedCell *)homeOfNetRedCell didSelectItem:(CommoditySpecialCategoriesItem *)item;

@end

@interface HomeOfNetRedCell : UITableViewCell

/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;
/**    代理    */
@property(nonatomic,weak) id<HomeOfNetRedCellDelegate> delegate;

@end
