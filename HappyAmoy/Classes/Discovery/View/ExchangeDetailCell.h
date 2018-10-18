//
//  ExchangeDetailCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/12.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SwapGoogsListItem;

@interface ExchangeDetailCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) SwapGoogsListItem *item;

@end
