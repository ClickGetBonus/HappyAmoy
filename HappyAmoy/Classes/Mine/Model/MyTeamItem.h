//
//  MyTeamItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MyTeamItem : NSObject

@property (copy, nonatomic) NSString *headpicUrl;
@property (copy, nonatomic) NSString *teamId;
@property (copy, nonatomic) NSString *mobile;
@property (copy, nonatomic) NSString *nickname;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger viped;

@end
