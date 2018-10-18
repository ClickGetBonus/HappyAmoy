//
//  MineNormalCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineNormalCell : UITableViewCell

/**    标识是否是邀请码    */
@property (assign, nonatomic) BOOL isRecommendCode;
/**    标题    */
@property (copy, nonatomic) NSString *title;
/**    图标名称    */
@property (copy, nonatomic) NSString *iconName;
/**    右边按钮的title    */
@property (strong, nonatomic) NSString *rightButtonTitle;

@end
