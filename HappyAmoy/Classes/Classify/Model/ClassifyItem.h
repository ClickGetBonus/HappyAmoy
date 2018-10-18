//
//  ClassifyItem.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ClassifyItem : NSObject

/**    分类id    */
@property(nonatomic,copy) NSString *classifyId;
/**    热门分类数组    */
@property(nonatomic,strong) NSArray *hotCategories;
/**    全部分类数组    */
@property(nonatomic,strong) NSArray *subCategories;
/**    分类图标id    */
@property(nonatomic,copy) NSString *icon;
/**    分类名称    */
@property(nonatomic,copy) NSString *name;
/**    分类图标    */
@property(nonatomic,copy) NSString *iconUrl;
/**    所属分类id    */
@property(nonatomic,copy) NSString *pid;



@end
