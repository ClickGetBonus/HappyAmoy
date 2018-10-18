//
//  GoodsListViewController.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class BrandSellerListItem;
@class CommodityCategoriesItem;
@class CommoditySpecialCategoriesItem;
@class ClassifyItem;

typedef NS_ENUM(NSInteger,CommodityType){
    // 品牌商家商品
    CommodityOfBrand = 1,
    // 今日推荐商品
    CommodityOfTodayRecommend = 2,
    // 商品分类
    CommodityOfCategories = 3,
    // 特色商品分类
    CommodityOfSpecialCategories = 4,

};

@interface GoodsListViewController : BaseViewControll

/**    分类模型    */
//@property(nonatomic,strong) ClassifyItem *classifyItem;
/**    一级分类id    */
@property(nonatomic,copy) NSString *categoryId;
/**    二级分类id    */
@property(nonatomic,copy) NSString *subCategoryId;
/**    特色分类ID    */
@property(nonatomic,copy) NSString *specialCategoryId;
/**    模块 1-爱生活 2-品牌精选    */
@property(nonatomic,copy) NSString *module;
/**    模块分类id    */
@property(nonatomic,copy) NSString *moduleCategoryId;
/**    是否进口优选 1-是 0-否    */
@property(nonatomic,copy) NSString *imported;
/**    是否必买清单 1-是 0-否    */
@property(nonatomic,copy) NSString *needBuyed;

/**    商品类型    */
@property (assign, nonatomic) CommodityType type;
/**    品牌商家的模型    */
@property (strong, nonatomic) BrandSellerListItem *brandItem;
/**    商品分类的模型    */
@property (strong, nonatomic) CommodityCategoriesItem *categoriesItem;
/**    特色分类的模型    */
@property (strong, nonatomic) CommoditySpecialCategoriesItem *specialItem;

@end
