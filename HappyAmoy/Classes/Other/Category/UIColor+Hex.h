//
//  UIColor+Hex.h
//  DianDian
//
//  Created by apple on 2017/11/25.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIColor (Hex)

+ (UIColor *)colorWithHexString:(NSString *)color;

//从十六进制字符串获取颜色，
//color:支持@“#123456”、 @“0X123456”、 @“123456”三种格式
+ (UIColor *)colorWithHexString:(NSString *)color alpha:(CGFloat)alpha;
/** 渐变色 [_view.layer addSublayer:CAGradientLayer] */
+ (CAGradientLayer *)shadowAsInverse:(CGRect)frame statrColor:(UIColor*)statrColor endColor:(UIColor*)endColor;

@end
