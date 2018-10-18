//
//  GoodsRankListChildController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class ClassifyItem;

@interface GoodsRankListChildController : BaseViewControll

/**    分类    */
@property(nonatomic,strong) ClassifyItem *classifyItem;
/**    特色分类ID    */
@property(nonatomic,copy) NSString *specialCategoryId;

@end
