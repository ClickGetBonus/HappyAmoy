//
//  GoodsListChildController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class ClassifyItem;

@interface GoodsListChildController : BaseViewControll

/**    分类    */
@property(nonatomic,strong) ClassifyItem *classifyItem;
/**    特色分类ID    */
@property(nonatomic,copy) NSString *specialCategoryId;
///**    标记是否是精选    */
//@property(nonatomic,assign) BOOL isFeatured;

@end
