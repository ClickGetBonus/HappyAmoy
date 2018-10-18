//
//  FilterView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class FilterView;

@protocol FilterViewDelegate <NSObject>

@optional

- (void)filterView:(FilterView *)filterView didClickIndex:(NSInteger)index;

- (void)filterView:(FilterView *)filterView didClickBabyType:(NSInteger)babyType;

@end

@interface FilterView : UIView

- (instancetype)initWithFrame:(CGRect)frame buttonArray:(NSArray *)buttonArray synthesisArray:(NSArray *)synthesisArray;

/**    代理    */
@property (weak, nonatomic) id<FilterViewDelegate> delegate;

@end
