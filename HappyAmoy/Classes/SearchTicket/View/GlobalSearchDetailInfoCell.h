//
//  GlobalSearchDetailInfoCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TaoBaoSearchItem;

@interface GlobalSearchDetailInfoCell : UITableViewCell

/**    全网搜索的数据模型    */
@property(nonatomic,strong) TaoBaoSearchItem *searchItem;

@end

