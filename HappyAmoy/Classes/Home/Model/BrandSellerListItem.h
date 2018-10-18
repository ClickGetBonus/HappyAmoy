//
//  BrandSellerListItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BrandSellerListItem : NSObject

@property (copy, nonatomic) NSString *sellerId;
@property (copy, nonatomic) NSString *name;
@property (strong, nonatomic) NSArray *commodityList;

@end
