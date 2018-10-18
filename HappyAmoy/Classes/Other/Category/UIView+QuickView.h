//
//  UIView+QuickView.h
//  QianHong
//
//  Created by apple on 2018/3/21.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (QuickView)

/**
 *  @brief  tableView 的 footer
 */
+ (UIView *)tableFooterView;

/**
 *  @brief  分割线
 */
+ (UIView *)separatorLine;

/**
 *  @brief  分割线
 */
+ (UIView *)separatorLine:(CGRect)frame;


@end
