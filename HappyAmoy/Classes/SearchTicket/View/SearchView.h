//
//  SearchView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchView;

@protocol SearchViewDelegate <NSObject>

@optional

- (void)searchView:(SearchView *)searchView searchWithContent:(NSString *)content;

@end

@interface SearchView : UIView

/**    搜索关键词    */
@property (copy, nonatomic) NSString *keyword;
/**    占位文字    */
@property(nonatomic,copy) NSString *placeholder;
/**    代理    */
@property (weak, nonatomic) id<SearchViewDelegate> delegate;

/**
 *  @brief  开始编辑
 */
- (void)beginEditingWithContent:(NSString *)content;

/**
 *  @brief  结束编辑
 */
- (void)endEditing;

- (NSString *)getKeyword;

@end
