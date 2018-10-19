//
//  SearchGoodsItem.h
//  HappyAmoy
//
//  Created by VictoryLam on 2018/10/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchGoodsItem : NSObject

@property(nonatomic,copy) NSString *volume;
@property(nonatomic,assign) float maisui;
@property(nonatomic,copy) NSString *quan;
@property(nonatomic,copy) NSString *id;
@property(nonatomic,copy) NSString *price;
@property(nonatomic,copy) NSString *title;
@property(nonatomic,copy) NSString *cover;
@property(nonatomic,copy) NSString *type;
@property(nonatomic,copy) NSString *price_old;

@end

NS_ASSUME_NONNULL_END
