//
//  PastePopupView.h
//  HappyAmoy
//
//  Created by Lan on 2018/10/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PastePopupView : UIView


+ (instancetype)showByType:(NSInteger)type data:(id)data;

#pragma mark - Public method
- (void)show;
- (void)dismiss;

@end
