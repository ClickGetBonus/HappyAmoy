//
//  GoodsDetailController.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class CommodityListItem;

@interface GoodsDetailController : BaseViewControll

/**    商品模型    */
@property (strong, nonatomic) CommodityListItem *item;

@end
