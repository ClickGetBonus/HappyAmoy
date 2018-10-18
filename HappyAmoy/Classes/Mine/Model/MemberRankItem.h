//
//  MemberRankItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MemberRankItem : NSObject

@property (copy, nonatomic) NSString *rankId;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *headpic;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *headpicUrl;
@property (copy, nonatomic) NSString *money;

@property (assign, nonatomic) NSInteger viped;

@end
