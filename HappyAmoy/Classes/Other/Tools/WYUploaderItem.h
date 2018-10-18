//
//  WYUploaderItem.h
//  QianHong
//
//  Created by apple on 2018/4/3.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYUploaderItem : NSObject

/**    图片路径    */
@property (copy, nonatomic) NSString *filePath;
/**    key    */
@property (copy, nonatomic) NSString *key;
/**    token    */
@property (copy, nonatomic) NSString *token;

@end
