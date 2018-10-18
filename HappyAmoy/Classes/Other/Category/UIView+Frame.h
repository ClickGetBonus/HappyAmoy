//
//  UIView+Frame.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Frame)

@property (assign, nonatomic) CGFloat width;
@property (assign, nonatomic) CGFloat height;
@property (assign, nonatomic) CGFloat x;
@property (assign, nonatomic) CGFloat y;
@property (assign, nonatomic) CGSize size;
@property (assign, nonatomic) CGPoint point;
@property (assign, nonatomic) CGFloat centerX;
@property (assign, nonatomic) CGFloat centerY;

@property (nonatomic) CGFloat left_WY;
@property (nonatomic) CGFloat top_WY;
@property (nonatomic) CGFloat right_WY;
@property (nonatomic) CGFloat bottom_WY;
@property (nonatomic) CGFloat width_WY;
@property (nonatomic) CGFloat height_WY;
@property (nonatomic) CGFloat centerX_WY;
@property (nonatomic) CGFloat centerY_WY;
@property (nonatomic) CGPoint origin_WY;
@property (nonatomic) CGSize  size_WY;

/**
 * 从xib加载UIView
 */
+ (instancetype)loadViewFromXib;

@end
