//
//  ClassifyTypeCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassifyItem;

@interface ClassifyTypeCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) ClassifyItem *item;
/**    标记是否已选    */
@property (assign, nonatomic) BOOL haveSelected;

@end
