//
//  PasteResponseItem.h
//  HappyAmoy
//
//  Created by Lan on 2018/10/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PasteResponseItem : NSObject

@property (copy, nonatomic) NSString *itemId;
@property (assign, nonatomic) NSString *discountPrice;
@property (copy, nonatomic) NSString *couponAmount;
@property (assign, nonatomic) NSString *price;
@property (copy, nonatomic) NSString *id;
@property (assign, nonatomic) CGFloat mineCommision;
@property (copy, nonatomic) NSString *iconUrl;
@property (copy, nonatomic) NSString *keyword;
@property (copy, nonatomic) NSString *name;

@end
