//
//  CategoryScrollView.h
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ClassifyItem;
@class CategoryScrollView;

@protocol CategoryScrollViewDelegate <NSObject>

@optional

- (void)categoryScrollView:(CategoryScrollView *)categoryScrollView didSelectItem:(ClassifyItem *)item;

@end

@interface CategoryScrollView : UIView

/**    分类数组    */
@property(nonatomic,strong) NSArray *categoriesArray;
/**    代理    */
@property(nonatomic,weak) id<CategoryScrollViewDelegate> delegate;

@end
