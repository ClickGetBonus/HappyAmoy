//
//  NSString+TextHelper.h
//  ChikeCommerCial
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 LL. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (TextHelper)

/**
 判断输入的字符串是否为空或者为nil
 
 @param string 需要判断的字符串
 
 @return 返回YES或NO
 */
+ (BOOL)isEmpty:(NSString *)string;

/**
 排除字符串为空的情况，防止显示在界面为nil值
 
 @param string 需要判断的字符串
 
 @return 判断后的结果
 */
+ (NSString *)excludeEmptyQuestion:(NSString *)string;

/**
 生成一个随机字符串
 
 @param count 生成多少位的字符串
 @param type 字符串类型，0-包含大小写字母和数字 ； 1-只包含大小写 ； 2-只包含大写 ； 3-只包含小写 ； 4-只包含数字
 @return 随机字符串
 */
+ (NSString *)returnRandomStringWithCount:(NSInteger)count type:(NSInteger)type;

/**
 检查手机号码是否符合格式
 
 @param mobileNum 手机号码
 @return 是否符合
 */
+ (BOOL)checkMobilePhone:(NSString *)mobileNum;

/**
 字符串转字典
 
 @param JSONString 字符串
 @return 返回字典
 */
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString;

/**
 字典转json格式字符串

 @param dic 字典
 @return 字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic;

/**
 *  @brief  获取当前屏幕显示的VC
 */
+ (UIViewController *)wy_getCurrentVC;

/**
 计算UILabel的高度，默认间距为0
 
 @param string 字符串
 @param maxWidth 宽度
 @param font 字体大小
 @return 高度
 */
+ (CGFloat)calculateLabelHeight:(NSString*)string maxWidth:(CGFloat)maxWidth font:(UIFont*)font;

/**
 计算UILabel的高度(带有行间距的情况)
 
 @param string 字符串
 @param lineSpacing 行间距
 @param maxWidth label的最大宽度
 @param font 字体大小
 @return 高度
 */
+ (CGFloat)calculateLabelHeight:(NSString*)string lineSpacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth font:(UIFont*)font;

/**
 根据出生日期计算星座
 
 @param dateString 出生日期
 
 @return 星座
 */
+ (NSString *)getXingzuo:(NSString *)dateString;

@end
