/**
 @@create by 刘智援 2016-11-28
 
 @简书地址:    http://www.jianshu.com/users/0714484ea84f/latest_articles
 @Github地址: https://github.com/lyoniOS
 @return MXWechatPayHandler（微信调用工具类）
 */

#import <Foundation/Foundation.h>

@interface MXWechatPayHandler : NSObject

+ (void)payWithOrder:(NSString *)order amount:(float)amount completation:(void(^)(BOOL resp))comp;

+ (void)payWithOrder:(NSString *)order amount:(float)amount title:(NSString *)title completation:(void(^)(BOOL resp))comp;

@end
