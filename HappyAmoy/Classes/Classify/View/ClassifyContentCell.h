//
//  ClassifyContentCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassifyContentCell;
@class ClassifyItem;

@protocol ClassifyContentCellDelegate <NSObject>

@optional

- (void)classifyContentCell:(ClassifyContentCell *)classifyContentCell didSelectItem:(ClassifyItem *)item;

@end

@interface ClassifyContentCell : UITableViewCell

/**    数据源    */
@property(nonatomic,strong) NSMutableArray *datasource;
/**    代理    */
@property(nonatomic,weak) id<ClassifyContentCellDelegate> delegate;

@end
