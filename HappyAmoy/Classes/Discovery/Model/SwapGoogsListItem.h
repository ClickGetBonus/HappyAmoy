//
//  SwapGoogsListItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SwapGoogsListItem : NSObject

@property (copy, nonatomic) NSString *swapId;
@property (copy, nonatomic) NSString *summary;
@property (copy, nonatomic) NSString *images;
@property (copy, nonatomic) NSString *createTime;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *stock;
@property (copy, nonatomic) NSString *exchangeNum;
@property (assign, nonatomic) NSInteger enabled;
@property (assign, nonatomic) NSInteger score;
@property (strong, nonatomic) NSArray *imageUrls;
@property (copy, nonatomic) NSString *content;

@end
