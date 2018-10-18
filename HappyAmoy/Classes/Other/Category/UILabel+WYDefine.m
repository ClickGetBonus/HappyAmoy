//
//  UILabel+WYDefine.m
//  QianHong
//
//  Created by apple on 2018/3/30.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "UILabel+WYDefine.h"

@implementation UILabel (WYDefine)

/**
 设置文字间距
 
 @param attributeString 文字
 @param lineSpace 间距
 */
//- (void)wy_setAttributeText:(NSString *)attributeString lineSpace:(CGFloat)lineSpace {
//
//    NSMutableAttributedString *attributedText = [[NSMutableAttributedString alloc] initWithString:attributeString];
//    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//    [paragraphStyle setLineSpacing:lineSpace];
//    [attributedText addAttribute:NSParagraphStyleAttributeName value:paragraphStyle range:NSMakeRange(0, [attributeString length])];
//
//    self.attributedText = attributedText;
//}

/**
 把掺合有表情的文字转换成文字和图片的富文本，并设置给label显示
 
 @param orignalText 需要转换的文字
 */
- (void)wy_setAttributedText:(NSString *)orignalText {
    // 默认行间距为0
    [self wy_setAttributedText:orignalText lineSpacing:0];
}

/**
 把掺合有表情的文字转换成文字和图片的富文本，并设置给label显示
 
 @param orignalText 需要转换的文字
 @param lineSpacing 行间距
 */
- (void)wy_setAttributedText:(NSString *)orignalText lineSpacing:(CGFloat)lineSpacing {
    
    [self wy_setAttributedText:orignalText lineSpacing:lineSpacing highlightedText:@"" highlightedColor:nil highlightedRange:0];
}

/**
 把掺合有表情的文字转换成文字和图片的富文本，并设置给label显示
 
 @param orignalText 需要转换的文字
 @param highlightedText 高亮的文字
 @param highlightedColor 高亮的颜色
 @param highlightedRange 高亮的起始位置
 @param lineSpacing 行间距
 */
- (void)wy_setAttributedText:(NSString *)orignalText lineSpacing:(CGFloat)lineSpacing highlightedText:(NSString *)highlightedText highlightedColor:(UIColor *)highlightedColor highlightedRange:(NSInteger)highlightedRange {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    
    paraStyle.alignment = NSTextAlignmentLeft;
    
    paraStyle.lineSpacing = lineSpacing; //设置行间距
    
    paraStyle.hyphenationFactor = 1.0;
    
    paraStyle.firstLineHeadIndent = 0.0;
    
    paraStyle.paragraphSpacingBefore = 0.0;
    
    paraStyle.headIndent = 0;
    
    paraStyle.tailIndent = 0;
    
    //设置字间距 NSKernAttributeName
    NSDictionary *dic = @{NSFontAttributeName:self.font, NSParagraphStyleAttributeName:paraStyle
                          };
    NSMutableAttributedString *attributeStr = [NSString handleWordMixFaceText:orignalText faceWH:self.font.lineHeight];
    [attributeStr addAttributes:dic range:NSMakeRange(0, attributeStr.length)];
    
    if (![NSString isEmpty:highlightedText]) { // 高亮
        [attributeStr addAttribute:NSForegroundColorAttributeName value:highlightedColor range:NSMakeRange(highlightedRange, highlightedText.length)];
    }
    
    self.attributedText = attributeStr;
    
}



@end
