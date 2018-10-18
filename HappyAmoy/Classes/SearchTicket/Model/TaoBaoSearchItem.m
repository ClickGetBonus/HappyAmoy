//
//  TaoBaoSearchItem.m
//  HappyAmoy
//
//  Created by apple on 2018/7/22.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TaoBaoSearchItem.h"

@implementation TaoBaoSearchItem

- (void)setPictUrl:(NSString *)pictUrl {
    _pictUrl = pictUrl;
}

- (void)setTitle:(NSString *)title {
    if ([NSString isEmpty:title]) {
        _title = @"";
    } else {
        if ([title containsString:@"</span>"]) {
            _title = [title stringByReplacingOccurrencesOfString:@"</span>" withString:@""];
        } else {
            _title = title;
        }
    }
}

@end
