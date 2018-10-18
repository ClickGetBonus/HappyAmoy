//
//  BannerItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/8.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerItem : NSObject

@property (copy, nonatomic) NSString *bannerId;
@property (copy, nonatomic) NSString *image;
@property (copy, nonatomic) NSString *imageUrl;
@property (copy, nonatomic) NSString *target;
@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger type;
@property (assign, nonatomic) NSInteger urlType;

@end
