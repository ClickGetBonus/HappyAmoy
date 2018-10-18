//
//  TaoBaoSearchDetailItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface TaoBaoSearchDetailItem : NSObject

@property(nonatomic,copy) NSString *zkFinalPrice;
@property(nonatomic,strong) NSArray *smallImages;
@property(nonatomic,copy) NSString *catLeafName;
@property(nonatomic,copy) NSString *sellerId;
@property(nonatomic,assign) NSInteger userType;
@property(nonatomic,copy) NSString *reservePrice;
// 30天销量
@property(nonatomic,assign) NSInteger volume;
@property(nonatomic,copy) NSString *nick;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *itemUrl;
@property(nonatomic,copy) NSString *catName;
@property(nonatomic,copy) NSString *numIid;
@property(nonatomic,copy) NSString *pictUrl;
@property(nonatomic,copy) NSString *provcity;

@end
