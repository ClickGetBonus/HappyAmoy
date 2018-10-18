//
//  NSString+WordMixFace.m
//  DianDian
//
//  Created by apple on 17/10/17.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "NSString+WordMixFace.h"

@implementation NSString (WordMixFace)

/**
 处理文字和表情，返回文字混合图片的富文本
 
 @param text   混合有表情转义的文字
 @param faceWH 表情宽高
 
 @return 返回文字混合图片的富文本
 */
+ (NSMutableAttributedString *)handleWordMixFaceText:(NSString *)text faceWH:(CGFloat)faceWH {
    // 加载表情资源
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"plist"];
    
    NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:facePath];
    
    NSMutableArray *contenArray = [NSMutableArray array];
    
    [self getMessageRange:text contentArray:contenArray];
    
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] init];
    
    for (NSString *object in contenArray) {
        
        if ([object hasSuffix:@"]"] && [object hasPrefix:@"["]) {
            
            if (faceDic[object] != nil) {
                NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
                
                imageAttachment.image = [UIImage imageNamed:faceDic[object]];
                //这里对图片的大小进行设置,一般来说等于文字的高度
                imageAttachment.bounds = CGRectMake(0, -3, faceWH, faceWH);
//                imageAttachment.bounds = CGRectMake(0, -3, 20.5, 20.5);

                NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
                
                [mutableAttrString appendAttributedString:attrString];
            } else { // 如果没有对应的表情，则直接显示文字
                [mutableAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:object]];
            }
            
            
        } else {
            [mutableAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:object]];
        }
    }
    
    return mutableAttrString;
}

#pragma mark - 判断哪些是表情，哪些是文字然后加入一个数组中待用。
+ (void)getMessageRange:(NSString*)message contentArray:(NSMutableArray*)array {
    
    NSRange startRange = [message rangeOfString:@"["];
    
    NSRange endRange = [message rangeOfString:@"]"];
    
    //判断当前字符串是否还有表情的标志。
    /*      测试表情()[大哭]大哭]大哭]大哭][大哭[大哭[大哭[微笑][难过]      */
    if (startRange.length>0 && endRange.length>0) {
        
        if (startRange.location > 0) {
            
            [array addObject:[message substringToIndex:startRange.location]];
            
            NSString *str = @"";
            if (endRange.location > startRange.location) {// 结尾位置要大于开始位置，否则不是表情
                
                [array addObject:[message substringWithRange:NSMakeRange(startRange.location, endRange.location + 1 - startRange.location)]];
                
                str = [message substringFromIndex:endRange.location + 1];
            } else {
                
                str = [message substringFromIndex:startRange.location];
                
            }
            
            [self getMessageRange:str contentArray:array];
        } else {
            NSString *nextStr = [message substringWithRange:NSMakeRange(startRange.location, endRange.location + 1 - startRange.location)];
            // 排除文字是“”的
            if (![nextStr isEqualToString:@""]) {
                
                [array addObject:nextStr];
                
                NSString *str = [message substringFromIndex:endRange.location + 1];
                
                [self getMessageRange:str contentArray:array];
            } else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

/**
 处理文字和表情，返回文字和替代表情文字的富文本，将表情的转义替换成了一个“哦”字，以便计算字符串的高度，这个方法主要是用来计算获取字符串计算高度
 
 @param text   混合有表情转义的文字
 @param faceWH 表情宽高
 
 @return 返回文字混合图片的富文本
 */
+ (NSMutableAttributedString *)getTextSizeWithWordMixFaceText:(NSString *)text faceWH:(CGFloat)faceWH {
    // 加载表情资源
    NSString *facePath = [[NSBundle mainBundle] pathForResource:@"face" ofType:@"plist"];
    
    NSDictionary *faceDic = [NSDictionary dictionaryWithContentsOfFile:facePath];
    
    NSMutableArray *contenArray = [NSMutableArray array];
    
    [self getTextSizeWithMessageRange:text contentArray:contenArray];
    
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] init];
    
    for (NSString *object in contenArray) {
                
        if ([object hasSuffix:@"]"] && [object hasPrefix:@"["]) {
            
            if (faceDic[object] != nil) {
                NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
                
                imageAttachment.image = [UIImage imageNamed:faceDic[object]];
                //这里对图片的大小进行设置,一般来说等于文字的高度
                imageAttachment.bounds = CGRectMake(0, -3, faceWH, faceWH);
//                imageAttachment.bounds = CGRectMake(0, -3, 20.5, 20.5);

                NSAttributedString *attrString = [NSAttributedString attributedStringWithAttachment:imageAttachment];
                
                [mutableAttrString appendAttributedString:attrString];
            } else { // 如果没有对应的表情，则直接显示文字
                [mutableAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:object]];
            }
            
            
        } else {
            [mutableAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:object]];
        }
    }
    
    return mutableAttrString;
}

#pragma mark - 判断哪些是表情，哪些是文字然后加入一个数组中待用。
+ (void)getTextSizeWithMessageRange:(NSString*)message contentArray:(NSMutableArray*)array {
    
    NSRange startRange = [message rangeOfString:@"["];
    
    NSRange endRange = [message rangeOfString:@"]"];
    
    //判断当前字符串是否还有表情的标志。
    if (startRange.length>0 && endRange.length>0) {
        
        if (startRange.location > 0) {
            
            [array addObject:[message substringToIndex:startRange.location]];
            
            NSString *str = @"";
            if (endRange.location > startRange.location) {// 结尾位置要大于开始位置，否则不是表情
                
                // 用一个字符代替表情，以便用来计算宽高
                [array addObject:@"哦 "];
                
                str = [message substringFromIndex:endRange.location + 1];
            } else {
                
                str = [message substringFromIndex:startRange.location];
                
            }
            
            [self getTextSizeWithMessageRange:str contentArray:array];
        } else {
            NSString *nextStr = [message substringWithRange:NSMakeRange(startRange.location, endRange.location + 1 - startRange.location)];
            // 排除文字是“”的
            if (![nextStr isEqualToString:@""]) {
                
                // 用一个字符代替表情，以便用来计算宽高
                [array addObject:@"哦 "];
                
                NSString *str = [message substringFromIndex:endRange.location + 1];
                
                [self getTextSizeWithMessageRange:str contentArray:array];
            } else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}


/**
 处理文字和表情，返回没有表情的文字，将表情的转义替换成了一个“”字，以便计算字符串的高度，这个方法主要是用来计算获取字符串计算高度
 
 @param text   混合有表情转义的文字
 @param placeholder 替换文字
 
 @return 返回没有表情的文字文字的富文本
 */
+ (NSMutableAttributedString *)getTextSizeWithWordMixFaceText:(NSString *)text placeholder:(NSString *)placeholder {
    
    NSMutableArray *contenArray = [NSMutableArray array];
    
    [self getTextSizeWithMessageRange:text contentArray:contenArray placeholder:placeholder];
    
    NSMutableAttributedString *mutableAttrString = [[NSMutableAttributedString alloc] init];
    
    for (NSString *object in contenArray) {
        
        if ([object hasSuffix:@"]"] && [object hasPrefix:@"["]) {
            WYLog(@"有表情吗");
            
        } else {
            [mutableAttrString appendAttributedString:[[NSAttributedString alloc] initWithString:object]];
        }
    }
    
    return mutableAttrString;
}

#pragma mark - 判断哪些是表情，哪些是文字然后加入一个数组中待用。
+ (void)getTextSizeWithMessageRange:(NSString*)message contentArray:(NSMutableArray*)array placeholder:(NSString *)placeholder {
    
    NSRange startRange = [message rangeOfString:@"["];
    
    NSRange endRange = [message rangeOfString:@"]"];
    
    //判断当前字符串是否还有表情的标志。
    if (startRange.length>0 && endRange.length>0) {
        
        if (startRange.location > 0) {
            
            [array addObject:[message substringToIndex:startRange.location]];
            
            NSString *str = @"";
            if (endRange.location > startRange.location) {// 结尾位置要大于开始位置，否则不是表情
                
                // 用一个字符代替表情，以便用来计算宽高
                [array addObject:placeholder];
                
                str = [message substringFromIndex:endRange.location + 1];
            } else {
                
                str = [message substringFromIndex:startRange.location];
                
            }
            
            [self getTextSizeWithMessageRange:str contentArray:array placeholder:placeholder];
        } else {
            NSString *nextStr = [message substringWithRange:NSMakeRange(startRange.location, endRange.location + 1 - startRange.location)];
            // 排除文字是“”的
            if (![nextStr isEqualToString:@""]) {
                
                // 用一个字符代替表情，以便用来计算宽高
                [array addObject:placeholder];
                
                NSString *str = [message substringFromIndex:endRange.location + 1];
                
                [self getTextSizeWithMessageRange:str contentArray:array placeholder:placeholder];
            } else {
                return;
            }
        }
        
    } else if (message != nil) {
        [array addObject:message];
    }
}

@end
