//
//  UIView+Frame.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIView+Frame.h"

@implementation UIView (Frame)

- (void)setWidth:(CGFloat)width {
    
    CGRect rect = self.frame;
    
    rect.size.width = width;
    
    self.frame = rect;
    
}

- (CGFloat)width {
   
    return self.frame.size.width;

}

- (void)setHeight:(CGFloat)height {
    
    CGRect rect = self.frame;
    
    rect.size.height = height;
    
    self.frame = rect;
    
}

- (CGFloat)height {
    
    return self.frame.size.height;
    
}

- (void)setX:(CGFloat)x {
    
    CGRect rect = self.frame;
    
    rect.origin.x = x;
    
    self.frame = rect;
    
}

- (CGFloat)x {
    
    return self.frame.origin.x;
    
}

- (void)setY:(CGFloat)y {
    
    CGRect rect = self.frame;
    
    rect.origin.y = y;
    
    self.frame = rect;
    
}

- (CGFloat)y {
    
    return self.frame.origin.y;
    
}

- (void)setSize:(CGSize)size {
    
    CGRect rect = self.frame;
    
    rect.size = size;
    
    self.frame = rect;
    
}

- (CGSize)size {
    
    return self.frame.size;
    
}

- (void)setPoint:(CGPoint)point {
    
    CGRect rect = self.frame;
    
    rect.origin = point;
    
    self.frame = rect;
    
}

- (CGPoint)point {
    
    return self.frame.origin;
    
}

- (void)setCenterX:(CGFloat)centerX {
    
    CGPoint center = self.center;
    
    center.x = centerX;
    
    self.center = center;
    
}

- (CGFloat)centerX {
    
    return self.center.x;
    
}

- (void)setCenterY:(CGFloat)centerY {
    
    CGPoint center = self.center;
    
    center.y = centerY;
    
    self.center = center;
    
}

- (CGFloat)centerY {
    
    return self.center.y;

}

- (CGFloat)left_WY {
    return CGRectGetMinX(self.frame);
}

- (void)setLeft_WY:(CGFloat)x {
    CGRect frame = self.frame;
    frame.origin.x = x;
    self.frame = frame;
}

- (CGFloat)top_WY {
    return CGRectGetMinY(self.frame);
}

- (void)setTop_WY:(CGFloat)y {
    CGRect frame = self.frame;
    frame.origin.y = y;
    self.frame = frame;
}

- (CGFloat)right_WY {
    return CGRectGetMaxX(self.frame);
}

- (void)setRight_WY:(CGFloat)right {
    CGRect frame = self.frame;
    frame.origin.x = right - frame.size.width;
    self.frame = frame;
}

- (CGFloat)bottom_WY {
    return CGRectGetMaxY(self.frame);
}

- (void)setBottom_WY:(CGFloat)bottom {
    CGRect frame = self.frame;
    frame.origin.y = bottom - frame.size.height;
    self.frame = frame;
}

- (CGFloat)width_WY {
    return CGRectGetWidth(self.frame);
}

- (void)setWidth_WY:(CGFloat)width {
    CGRect frame = self.frame;
    frame.size.width = width;
    self.frame = frame;
}

- (CGFloat)height_WY {
    return CGRectGetHeight(self.frame);
}

- (void)setHeight_WY:(CGFloat)height {
    CGRect frame = self.frame;
    frame.size.height = height;
    self.frame = frame;
}

- (CGFloat)centerX_WY {
    return self.center.x;
}

- (void)setCenterX_WY:(CGFloat)centerX {
    self.center = CGPointMake(centerX, self.center.y);
}

- (CGFloat)centerY_WY {
    return self.center.y;
}

- (void)setCenterY_WY:(CGFloat)centerY {
    self.center = CGPointMake(self.center.x, centerY);
}

- (CGPoint)origin_WY {
    return self.frame.origin;
}

- (void)setOrigin_WY:(CGPoint)origin {
    CGRect frame = self.frame;
    frame.origin = origin;
    self.frame = frame;
}

- (CGSize)size_WY {
    return self.frame.size;
}

- (void)setSize_WY:(CGSize)size {
    CGRect frame = self.frame;
    frame.size = size;
    self.frame = frame;
}



/**
 * 从xib加载UIView
 */
+ (instancetype)loadViewFromXib {
    
    return [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self) owner:nil options:nil].firstObject;
    
}

@end
