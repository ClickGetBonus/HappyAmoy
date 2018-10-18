//
//  AliPay.h
//  ChiKe
//
//  Created by 刘俊臣 on 2018/1/16.
//  Copyright © 2018年 你亲爱的爸爸. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AliPay : NSObject

+ (void)payWithOrder:(NSString *)orderKey amount:(float)amount title:(NSString *)title completation:(void (^)(NSDictionary *, NSInteger, NSString *))comp;

@end
