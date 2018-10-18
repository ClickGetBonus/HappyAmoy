//
//  SettingNormalCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingNormalCell : UITableViewCell

/**    标题    */
@property (copy, nonatomic) NSString *title;
/**    内容    */
@property (copy, nonatomic) NSString *content;

- (void)setArrowImageViewHidden:(BOOL)hidden;

@end
