//
//  PlatfomrCharacterCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PlatfomrCharacterCell;
@class CommoditySpecialCategoriesItem;

@protocol PlatfomrCharacterCellDelegate <NSObject>

@optional

- (void)platfomrCharacterCell:(PlatfomrCharacterCell *)platfomrCharacterCell didSelectItem:(CommoditySpecialCategoriesItem *)item;

@end

@interface PlatfomrCharacterCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<PlatfomrCharacterCellDelegate> delegate;
/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end
