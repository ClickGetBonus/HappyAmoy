//
//  SpecialCategoryFeaturedController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class ClassifyItem;

@interface SpecialCategoryFeaturedController : BaseViewControll

/**    标记是否是视频类型    */
@property(nonatomic,assign) BOOL isVideoType;
/**    分类ID    */
@property(nonatomic,copy) NSString *categoryId;
/**    特色分类ID    */
@property(nonatomic,copy) NSString *specialCategoryId;

@end
