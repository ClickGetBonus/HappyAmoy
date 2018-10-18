//
//  MyTeamMemberCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MyTeamItem;

@interface MyTeamMemberCell : UITableViewCell
@property (nonatomic, copy  )void (^ClickedPhoneBlockBlock)(MyTeamItem *item);

/**    数据模型    */
@property (strong, nonatomic) MyTeamItem *item;

@end
