//
//  UIBarButtonItem+Item.h
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Item)
/**     快速创建UIBarButtonItem     */
+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage buttonSize:(CGSize)buttonSize target:(id)target action:(SEL)action;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage buttonSize:(CGSize)buttonSize target:(id)target action:(SEL)action imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action title:(NSString *)title;

// 购物车

+ (UIBarButtonItem *)shoppingBarButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage buttonSize:(CGSize)buttonSize shoppingCount:(NSInteger)count target:(id)target action:(SEL)action imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets;

/**
 *  @brief  上图片，下文字
 */
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont size:(CGSize)size target:(id)target action:(SEL)action;
@end
