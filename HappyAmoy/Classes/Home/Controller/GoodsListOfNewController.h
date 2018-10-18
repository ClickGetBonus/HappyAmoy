//
//  GoodsListOfNewController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class CommodityCategoriesItem;
@class CommoditySpecialCategoriesItem;

@interface GoodsListOfNewController : BaseViewControll

/**    标记是否是视频类型    */
@property(nonatomic,assign) BOOL isVideoType;
/**    商品分类    */
@property(nonatomic,strong) CommodityCategoriesItem *categoriesItem;
/**    特色分类    */
//@property(nonatomic,strong) CommoditySpecialCategoriesItem *specialCategoriesItem;
/**    特色分类id    */
@property (copy, nonatomic) NSString *specialCategoriesId;


@end
