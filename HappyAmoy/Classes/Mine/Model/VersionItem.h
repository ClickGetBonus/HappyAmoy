//
//  VersionItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VersionItem : NSObject

@property (copy, nonatomic) NSString *versionId;
@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *version;
@property (copy, nonatomic) NSString *log;
@property (copy, nonatomic) NSString *downloadUrl;
@property (assign, nonatomic) NSInteger number;
@property (assign, nonatomic) NSInteger machineType;

@end
