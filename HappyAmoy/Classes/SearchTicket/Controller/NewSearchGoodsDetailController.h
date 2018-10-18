//
//  NewSearchGoodsDetailController.h
//  HappyAmoy
//
//  Created by VictoryLam on 2018/10/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class SearchGoodsItem;

NS_ASSUME_NONNULL_BEGIN

@interface NewSearchGoodsDetailController : BaseViewControll

///**    商品模型    */
//@property (strong, nonatomic) SearchGoodsItem *item;

/**    商品id    */
@property (copy, nonatomic) NSString *itemId;


/**    数据源    */
@property (strong, nonatomic) NSMutableArray *datasource;

@end

NS_ASSUME_NONNULL_END
