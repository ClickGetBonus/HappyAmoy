//
//  ShareController.h
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class CommodityDetailItem;
@class TaoBaoSearchDetailItem;

@interface ShareController : BaseViewControll

/**    商品模型    */
@property (strong, nonatomic) CommodityDetailItem *item;
/**    搜索的商品数据模型    */
@property(nonatomic,strong) TaoBaoSearchDetailItem *searchItem;

@end
