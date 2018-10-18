//
//  ClassifyOfGoodsListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassifyOfGoodsListCell;
@class ClassifyItem;

@protocol ClassifyOfGoodsListCellDelegate <NSObject>

@optional

- (void)classifyOfGoodsListCell:(ClassifyOfGoodsListCell *)classifyOfGoodsListCell didSelectItem:(ClassifyItem *)item;

@end

@interface ClassifyOfGoodsListCell : UITableViewCell

/**    子分类数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;
/**    代理    */
@property(nonatomic,weak) id<ClassifyOfGoodsListCellDelegate> delegate;

@end
