//
//  PromotionItem.h
//  HappyAmoy
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PromotionItem : NSObject

@property (copy, nonatomic) NSString *promotionId;
@property (copy, nonatomic) NSString *title;
@property (strong, nonatomic) NSArray *images;
@property (copy, nonatomic) NSString *createTime;
@property (assign, nonatomic) NSInteger enabled;

/**===============额外增加的属性===============*/

/*     缓存cell的高度   */
@property (assign, nonatomic) CGFloat cellHeight;
/**    第一张图片    */
@property (strong, nonatomic) UIImage *firstImage;

@end
