//
//  NSString+TextHelper.m
//  ChikeCommerCial
//
//  Created by apple on 2018/2/26.
//  Copyright © 2018年 LL. All rights reserved.
//

#import "NSString+TextHelper.h"

@implementation NSString (TextHelper)

/**
 判断输入的字符串是否为空或者为nil
 
 @param string 需要判断的字符串
 
 @return 返回YES或NO
 */
+ (BOOL)isEmpty:(NSString *)string {
    
    if ([string isEqualToString:@""] || string == nil || [string isEqualToString:@"(null)"]) {
        return YES;
    }
    return NO;
}

/**
 排除字符串为空的情况，防止显示在界面为nil值
 
 @param string 需要判断的字符串
 
 @return 判断后的结果
 */
+ (NSString *)excludeEmptyQuestion:(NSString *)string {
    
    if ([string isEqualToString:@""] || string == nil || [string isEqualToString:@"(null)"]) {
        return @"";
    }
    return string;
}

/**
 生成一个随机字符串

 @param count 生成多少位的字符串
 @param type 字符串类型，0-包含大小写字母和数字 ； 1-只包含大小写 ； 2-只包含大写 ； 3-只包含小写 ； 4-只包含数字
 @return 随机字符串
 */
+ (NSString *)returnRandomStringWithCount:(NSInteger)count type:(NSInteger)type {
    //定义一个包含数字，大小写字母的字符串
    NSString * strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
    
    switch (type) {
        case 1:
            strAll = @"abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            break;
        case 2:
            strAll = @"ABCDEFGHIJKLMNOPQRSTUVWXYZ";
            break;
        case 3:
            strAll = @"abcdefghijklmnopqrstuvwxyz";
            break;
        case 4:
            strAll = @"0123456789";
            break;
        default:
            strAll = @"0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ";
            break;
    }
    
    //定义一个结果
    NSString * result = [[NSMutableString alloc]initWithCapacity:count];
    for (int i = 0; i < count; i++) {
        //获取随机数
        NSInteger index = arc4random() % (strAll.length-1);
        char tempStr = [strAll characterAtIndex:index];
        result = (NSMutableString *)[result stringByAppendingString:[NSString stringWithFormat:@"%c",tempStr]];
    }
    
    return result;
}

/**
 检查手机号码是否符合格式
 
 @param mobileNum 手机号码
 @return 是否符合
 */
+ (BOOL)checkMobilePhone:(NSString *)mobileNum {
    /**
     * 移动号段正则表达式
     */
    NSString *CM_NUM = @"^((13[4-9])|(147)|(154)|(15[0-2,7-9])|(178)|(18[2-4,7-8]))\\d{8}|(1705)\\d{7}$";
    /**
     * 联通号段正则表达式
     */
    NSString *CU_NUM = @"^((13[0-2])|(145)|(154)|(15[5-6])|(176)|(170)|(171)|(18[5,6]))\\d{8}|(1709)\\d{7}$";
    /**
     * 电信号段正则表达式
     */
    NSString *CT_NUM = @"^((133)|(153)|(154)|(177)|(18[0,1,9]))\\d{8}$";
    NSPredicate *pred1 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CM_NUM];
    BOOL isMatch1 = [pred1 evaluateWithObject:mobileNum];
    NSPredicate *pred2 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CU_NUM];
    BOOL isMatch2 = [pred2 evaluateWithObject:mobileNum];
    NSPredicate *pred3 = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", CT_NUM];
    BOOL isMatch3 = [pred3 evaluateWithObject:mobileNum];
    
    if (isMatch1 || isMatch2 || isMatch3) {
        return YES;
    } else {
        return NO;
    }
}

/**
 字符串转字典

 @param JSONString 字符串
 @return 返回字典
 */
+ (NSDictionary *)parseJSONStringToNSDictionary:(NSString *)JSONString {
    
    NSData *JSONData = [JSONString dataUsingEncoding:NSUTF8StringEncoding];
    
    NSDictionary *responseJSON = [NSJSONSerialization JSONObjectWithData:JSONData options:NSJSONReadingMutableLeaves error:nil];
    
    return responseJSON;
}

/**
 字典转json格式字符串
 
 @param dic 字典
 @return 字符串
 */
+ (NSString*)dictionaryToJson:(NSDictionary *)dic {
    NSError *parseError = nil;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:dic options:NSJSONWritingPrettyPrinted error:&parseError];
    
    return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
}

/**
 获取当前屏幕显示的VC

 @return 当前控制器
 */
+ (UIViewController *)wy_getCurrentVC {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    UIViewController *currentVC = [self getCurrentVCFrom:rootViewController];
    
    return currentVC;
}

+ (UIViewController *)getCurrentVCFrom:(UIViewController *)rootVC
{
    UIViewController *currentVC;
    
    if([rootVC presentedViewController]) {
        // 视图是被presented出来的
        rootVC = [rootVC presentedViewController];
    }
    if([rootVC isKindOfClass:[UITabBarController class]]) {
        // 根视图为UITabBarController
        currentVC = [self getCurrentVCFrom:[(UITabBarController *)rootVC selectedViewController]];
        
    }else if([rootVC isKindOfClass:[UINavigationController class]]){
        // 根视图为UINavigationController
        currentVC = [self getCurrentVCFrom:[(UINavigationController *)rootVC visibleViewController]];
        
    }else{
        // 根视图为非导航类
        currentVC = rootVC;
    }
    return currentVC;
}

/**
 计算UILabel的高度，默认间距为0
 
 @param string 字符串
 @param maxWidth 宽度
 @param font 字体大小
 @return 高度
 */
+ (CGFloat)calculateLabelHeight:(NSString*)string maxWidth:(CGFloat)maxWidth font:(UIFont*)font {
    return [self calculateLabelHeight:string lineSpacing:0 maxWidth:maxWidth font:font];
}

/**
 计算UILabel的高度(带有行间距的情况)
 
 @param string 字符串
 @param lineSpacing 行间距
 @param maxWidth label的最大宽度
 @param font 字体大小
 @return 高度
 */
+ (CGFloat)calculateLabelHeight:(NSString*)string lineSpacing:(CGFloat)lineSpacing maxWidth:(CGFloat)maxWidth font:(UIFont*)font {
    
    NSMutableParagraphStyle *paraStyle = [[NSMutableParagraphStyle alloc] init];
    
    paraStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paraStyle.alignment = NSTextAlignmentLeft;
    paraStyle.lineSpacing = lineSpacing;
    paraStyle.hyphenationFactor = 1.0;
    paraStyle.firstLineHeadIndent = 0.0;
    paraStyle.paragraphSpacingBefore = 0.0;
    paraStyle.headIndent = 0;
    paraStyle.tailIndent = 0;
    
    NSDictionary *dic = @{NSFontAttributeName:font, NSParagraphStyleAttributeName:paraStyle};
    
    CGSize size = [string boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:dic context:nil].size;
    
    return size.height;
}

/**
 根据出生日期计算星座
 
 @param dateString 出生日期
 
 @return 星座
 */
+ (NSString *)getXingzuo:(NSString *)dateString {
    
    // 把出生日期转为日期
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    
    [dateFormat setDateFormat:@"yyyy-MM-dd"];
    
    NSDate *in_date = [dateFormat dateFromString:dateString];
    
    //计算星座
    NSString *retStr=@"";
    
    [dateFormat setDateFormat:@"MM"];
    
    int i_month=0;
    
    NSString *theMonth = [dateFormat stringFromDate:in_date];
    
    if([[theMonth substringToIndex:0] isEqualToString:@"0"]) {
        i_month = [[theMonth substringFromIndex:1] intValue];
    } else {
        i_month = [theMonth intValue];
    }
    
    [dateFormat setDateFormat:@"dd"];
    
    int i_day=0;
    
    NSString *theDay = [dateFormat stringFromDate:in_date];

    if([[theDay substringToIndex:0] isEqualToString:@"0"]) {
        i_day = [[theDay substringFromIndex:1] intValue];
    } else {
        i_day = [theDay intValue];
    }
    /*
     
     摩羯座 12月22日------1月19日
     
     水瓶座 1月20日-------2月18日
     
     双鱼座 2月19日-------3月20日
     
     白羊座 3月21日-------4月19日
     
     金牛座 4月20日-------5月20日
     
     双子座 5月21日-------6月21日
     
     巨蟹座 6月22日-------7月22日
     
     狮子座 7月23日-------8月22日
     
     处女座 8月23日-------9月22日
     
     天秤座 9月23日------10月23日
     
     天蝎座 10月24日-----11月21日
     
     射手座 11月22日-----12月21日
     
     */
    switch (i_month) {
        case 1:
            if(i_day>=20 && i_day<=31){
                retStr=@"水瓶座";
            }
            if(i_day>=1 && i_day<=19){
                retStr=@"摩羯座";
            }
            break;
        case 2:
            if(i_day>=1 && i_day<=18){
                retStr=@"水瓶座";
            }
            if(i_day>=19 && i_day<=31){
                retStr=@"双鱼座";
            }
            break;
        case 3:
            if(i_day>=1 && i_day<=20){
                retStr=@"双鱼座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"白羊座";
            }
            break;
        case 4:
            if(i_day>=1 && i_day<=19){
                retStr=@"白羊座";
            }
            if(i_day>=20 && i_day<=31){
                retStr=@"金牛座";
            }
            break;
        case 5:
            if(i_day>=1 && i_day<=20){
                retStr=@"金牛座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"双子座";
            }
            break;
        case 6:
            if(i_day>=1 && i_day<=21){
                retStr=@"双子座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"巨蟹座";
            }
            break;
        case 7:
            if(i_day>=1 && i_day<=22){
                retStr=@"巨蟹座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"狮子座";
            }
            break;
        case 8:
            if(i_day>=1 && i_day<=22){
                retStr=@"狮子座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"处女座";
            }
            break;
        case 9:
            if(i_day>=1 && i_day<=22){
                retStr=@"处女座";
            }
            if(i_day>=23 && i_day<=31){
                retStr=@"天秤座";
            }
            break;
        case 10:
            if(i_day>=1 && i_day<=23){
                retStr=@"天秤座";
            }
            if(i_day>=24 && i_day<=31){
                retStr=@"天蝎座";
            }
            break;
        case 11:
            if(i_day>=1 && i_day<=21){
                retStr=@"天蝎座";
            }
            if(i_day>=22 && i_day<=31){
                retStr=@"射手座";
            }
            break;
        case 12:
            if(i_day>=1 && i_day<=21){
                retStr=@"射手座";
            }
            if(i_day>=21 && i_day<=31){
                retStr=@"摩羯座";
            }
            break;
    }
    return retStr;
}


@end
