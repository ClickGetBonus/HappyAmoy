//
//  NewsReportListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsReportItem;

@interface NewsReportListCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) NewsReportItem *item;

@end
