//
//  NSString+WordMixFace.h
//  DianDian
//
//  Created by apple on 17/10/17.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (WordMixFace)

/**
 处理文字和表情，返回文字混合图片的富文本，这个方法主要是用来显示在界面

 @param text   混合有表情转义的文字
 @param faceWH 表情宽高

 @return 返回文字混合图片的富文本
 */
+ (NSMutableAttributedString *)handleWordMixFaceText:(NSString *)text faceWH:(CGFloat)faceWH;

/**
 处理文字和表情，返回文字和替代表情文字的富文本，将表情的转义替换成了一个“哦”字，以便计算字符串的高度，这个方法主要是用来计算获取字符串计算高度
 
 @param text   混合有表情转义的文字
 @param faceWH 表情宽高
 
 @return 返回文字混合图片的富文本
 */
+ (NSMutableAttributedString *)getTextSizeWithWordMixFaceText:(NSString *)text faceWH:(CGFloat)faceWH;

/**
 处理文字和表情，返回没有表情的文字，将表情的转义替换成了一个“”字，以便计算字符串的高度，这个方法主要是用来计算获取字符串计算高度
 
 @param text   混合有表情转义的文字
 @param placeholder 替换文字
 
 @return 返回没有表情的文字文字的富文本
 */
+ (NSMutableAttributedString *)getTextSizeWithWordMixFaceText:(NSString *)text placeholder:(NSString *)placeholder;

@end
