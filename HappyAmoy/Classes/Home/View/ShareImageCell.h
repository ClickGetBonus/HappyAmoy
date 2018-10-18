//
//  ShareImageCell.h
//  HappyAmoy
//
//  Created by apple on 2018/5/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CommodityDetailItem;

@interface ShareImageCell : UICollectionViewCell


/**    标记是否是第一张图片    */
//@property (assign, nonatomic) BOOL isFirstImage;
/**    索引    */
@property (assign, nonatomic) NSInteger index;
/**    分享图片    */
@property (strong, nonatomic) UIImage *shareImage;
/**    商品模型    */
//@property (strong, nonatomic) CommodityDetailItem *item;



@end
