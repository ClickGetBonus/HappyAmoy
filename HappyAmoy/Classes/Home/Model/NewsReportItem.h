//
//  NewsReportItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NewsReportItem : NSObject

@property (copy, nonatomic) NSString *reportId;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *author;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *content;
@property (assign, nonatomic) NSInteger enabled;
@property (assign, nonatomic) NSInteger viewNum;
@property (assign, nonatomic) NSInteger praiseNum;
@property (assign, nonatomic) NSInteger icon;
@property (assign, nonatomic) NSInteger praised;

@end
