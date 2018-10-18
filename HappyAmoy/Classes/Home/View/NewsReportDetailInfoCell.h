//
//  NewsReportDetailInfoCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class NewsReportItem;

@interface NewsReportDetailInfoCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) NewsReportItem *item;
/**    点赞的回调    */
@property(nonatomic,copy) void(^praiseCallBack)(BOOL cancel);

@end
