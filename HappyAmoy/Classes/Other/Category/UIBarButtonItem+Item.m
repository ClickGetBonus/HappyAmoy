//
//  UIBarButtonItem+Item.m
//  BaiSiBuDeJie_Imitate
//
//  Created by apple on 17/9/9.
//  Copyright © 2017年 wy. All rights reserved.
//

#import "UIBarButtonItem+Item.h"

@implementation UIBarButtonItem (Item)

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title target:(id)target action:(SEL)action {
    
    return [self barButtonItemWithTitle:title titleColor:QHWhiteColor target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor target:(id)target action:(SEL)action {
    
    return [self barButtonItemWithTitle:title titleColor:titleColor titleFont:TextFont(16) target:target action:action];
}

+ (UIBarButtonItem *)barButtonItemWithTitle:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setTitle:title forState:UIControlStateNormal];
    button.titleLabel.font = titleFont;
    [button setTitleColor:titleColor forState:UIControlStateNormal];
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
    
    [containerView addSubview:button];
    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:highlightImage forState:UIControlStateHighlighted];
    // 设置内容自适应
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
    
    [containerView addSubview:button];
    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image selectedImage:(UIImage *)selectedImage target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setBackgroundImage:image forState:UIControlStateNormal];
    [button setBackgroundImage:selectedImage forState:UIControlStateSelected];
    // 设置内容自适应
    [button sizeToFit];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
    
    [containerView addSubview:button];
    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage buttonSize:(CGSize)buttonSize target:(id)target action:(SEL)action {
    
    return [self barButtonItemWithImage:image highlightImage:highlightImage buttonSize:buttonSize target:target action:action imageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -10)];
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage buttonSize:(CGSize)buttonSize target:(id)target action:(SEL)action imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    button.imageEdgeInsets = imageEdgeInsets;
    button.size = buttonSize;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
    
}

+ (UIBarButtonItem *)shoppingBarButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage buttonSize:(CGSize)buttonSize shoppingCount:(NSInteger)count target:(id)target action:(SEL)action imageEdgeInsets:(UIEdgeInsets)imageEdgeInsets {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [button setImage:image forState:UIControlStateNormal];
    [button setImage:highlightImage forState:UIControlStateHighlighted];
    button.imageEdgeInsets = imageEdgeInsets;
    button.size = buttonSize;
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    UILabel *goodsNumLabel = [[UILabel alloc] initWithFrame:CGRectMake(button.center.x + 2, button.frame.origin.y + 2, 14, 14)];
    [button addSubview:goodsNumLabel];
    goodsNumLabel.backgroundColor = QHWhiteColor;
    goodsNumLabel.layer.borderColor = [UIColor redColor].CGColor;
    goodsNumLabel.layer.borderWidth = 0.7;
    goodsNumLabel.textColor = [UIColor redColor];
    goodsNumLabel.textAlignment = NSTextAlignmentCenter;
    goodsNumLabel.font = [UIFont systemFontOfSize:8];
    goodsNumLabel.layer.cornerRadius = 7;
    goodsNumLabel.clipsToBounds = YES;
    goodsNumLabel.text = [NSString stringWithFormat:@"%zd",count];
    goodsNumLabel.hidden = count == 0 ? YES : NO;
    
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    
    return barButtonItem;
    
}

+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image highlightImage:(UIImage *)highlightImage target:(id)target action:(SEL)action title:(NSString *)title {
    
    // 设置返回按钮
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    
    [backBtn setImage:image forState:UIControlStateNormal];
    [backBtn setImage:highlightImage forState:UIControlStateHighlighted];
    
    [backBtn setTitle:title forState:UIControlStateNormal];
    [backBtn setTitleColor:QHWhiteColor forState:UIControlStateNormal];
//    [backBtn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    
    // 让按钮内容左移
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -10, 0, 0);
    
    [backBtn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    [backBtn sizeToFit];

    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backBtn];
    
    return barButtonItem;
}

/**
 *  @brief  上图片，下文字
 */
+ (UIBarButtonItem *)barButtonItemWithImage:(UIImage *)image title:(NSString *)title titleColor:(UIColor *)titleColor titleFont:(UIFont *)titleFont size:(CGSize)size target:(id)target action:(SEL)action {
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    button.size = size;
    
    UIImageView *imageView = [[UIImageView alloc] init];
    imageView.image = image;
    imageView.size = CGSizeMake(AUTOSIZESCALEX(14), AUTOSIZESCALEX(14));
    imageView.centerX = button.centerX;
    imageView.y = 0;
    [button addSubview:imageView];
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom_WY + AUTOSIZESCALEX(4), button.width, button.height - imageView.bottom_WY - AUTOSIZESCALEX(4))];
    titleLabel.text = title;
    titleLabel.textAlignment = NSTextAlignmentCenter;
    titleLabel.textColor = titleColor;
    titleLabel.font = titleFont;
    [button addSubview:titleLabel];
    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
    
    [containerView addSubview:button];
    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
//    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
//    button.size = size;
//    [button setImage:image forState:UIControlStateNormal];
//    [button setTitle:title forState:UIControlStateNormal];
//    button.titleLabel.font = titleFont;
//    [button setTitleColor:titleColor forState:UIControlStateNormal];
//
//    button.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;//使图片和文字水平居中显示
//    [button setTitleEdgeInsets:UIEdgeInsetsMake(button.imageView.frame.size.height ,-button.imageView.frame.size.width, 0.0,0.0)];//文字距离上边框的距离增加imageView的高度，距离左边框减少imageView的宽度，距离下边框和右边框距离不变
//    [button setImageEdgeInsets:UIEdgeInsetsMake(-button.titleLabel.bounds.size.height, 0.0,0.0, -button.titleLabel.bounds.size.width)];//图片距离右边框距离减少图片的宽度，其它不边
//
////    [button sizeToFit];
//    [button addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
//
//    UIView *containerView = [[UIView alloc] initWithFrame:button.bounds];
//
//    [containerView addSubview:button];
//    // 直接把UIButton包装成UIBarButtonItem会导致点击区域扩大，所以需要将UIButton先经过UIView包装。
//    UIBarButtonItem *barButtonItem = [[UIBarButtonItem alloc] initWithCustomView:containerView];
    
    return barButtonItem;
}


@end
