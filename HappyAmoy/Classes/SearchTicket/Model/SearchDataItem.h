//
//  SearchDataItem.h
//  HappyAmoy
//
//  Created by lb on 2018/9/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface SearchDataItem : NSObject

@property (assign, nonatomic) NSInteger itemId;
@property (copy, nonatomic) NSString *keyword;

@end

NS_ASSUME_NONNULL_END
