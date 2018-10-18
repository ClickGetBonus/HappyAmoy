//
//  GoodsRankListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityListItem;

@interface GoodsRankListCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) CommodityListItem *item;
/**    索引    */
@property(nonatomic,assign) NSInteger index;


@end
