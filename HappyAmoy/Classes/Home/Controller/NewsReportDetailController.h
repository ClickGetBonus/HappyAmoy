//
//  NewsReportDetailController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class NewsReportItem;

@interface NewsReportDetailController : BaseViewControll

/**    数据模型    */
@property(nonatomic,strong) NewsReportItem *item;

@end
