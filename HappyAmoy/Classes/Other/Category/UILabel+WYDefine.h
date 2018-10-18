//
//  UILabel+WYDefine.h
//  QianHong
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UILabel (WYDefine)

/**
 设置文字间距
 
 @param attributeString 文字
 @param lineSpace 间距
 */

//- (void)wy_setAttributeText:(NSString *)attributeString lineSpace:(CGFloat)lineSpace;

/**
 把掺合有表情的文字转换成文字和图片的富文本，并设置给label显示
 
 @param orignalText 需要转换的文字
 */
- (void)wy_setAttributedText:(NSString *)orignalText;

/**
 把掺合有表情的文字转换成文字和图片的富文本，并设置给label显示
 
 @param orignalText 需要转换的文字
 @param lineSpacing 行间距
 */
- (void)wy_setAttributedText:(NSString *)orignalText lineSpacing:(CGFloat)lineSpacing;

/**
 把掺合有表情的文字转换成文字和图片的富文本，并设置给label显示
 
 @param orignalText 需要转换的文字
 @param highlightedText 高亮的文字
 @param highlightedColor 高亮的颜色
 @param highlightedRange 高亮的起始位置
 @param lineSpacing 行间距
 */
- (void)wy_setAttributedText:(NSString *)orignalText lineSpacing:(CGFloat)lineSpacing highlightedText:(NSString *)highlightedText highlightedColor:(UIColor *)highlightedColor highlightedRange:(NSInteger)highlightedRange;

@end
