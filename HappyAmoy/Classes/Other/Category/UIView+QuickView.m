//
//  UIView+QuickView.m
//  QianHong
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "UIView+QuickView.h"

@implementation UIView (QuickView)

/**
 *  @brief  tableView 的 footer
 */
+ (UIView *)tableFooterView {
    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, AUTOSIZESCALEX(5))];
    footerView.backgroundColor = FooterViewBackgroundColor;
    return footerView;
}

/**
 *  @brief  分割线
 */
+ (UIView *)separatorLine {
    return [self separatorLine:CGRectZero];
}

/**
 *  @brief  分割线
 */
+ (UIView *)separatorLine:(CGRect)frame {
    UIView *footerView = [[UIView alloc] initWithFrame:frame];
    footerView.backgroundColor = SeparatorLineColor;
    return footerView;
}

@end
