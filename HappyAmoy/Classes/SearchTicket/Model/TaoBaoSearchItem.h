//
//  TaoBaoSearchItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoBaoSearchItem : NSObject

@property(nonatomic,copy) NSString *pictUrl;
@property(nonatomic,assign) CGFloat couponPrice;
@property(nonatomic,copy) NSString *totalCouponCount;
@property(nonatomic,assign) CGFloat afterCouponPrice;
@property(nonatomic,assign) NSInteger userType;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *clickUrl;
@property(nonatomic,assign) CGFloat currentPrice;
@property(nonatomic,copy) NSString *shareUrl;
@property(nonatomic,copy) NSString *sendCouponCount;
@property(nonatomic,assign) NSInteger biz30Day;
@property(nonatomic,copy) NSString *itemId;

@end
