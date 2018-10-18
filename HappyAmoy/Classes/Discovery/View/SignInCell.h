//
//  SignInCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SignInCell;
@class SignInOverviewItem;

@protocol SignInCellDelegate <NSObject>

@optional

- (void)signInCell:(SignInCell *)signInCell didClickSignInButton:(UIButton *)sender;

@end

@interface SignInCell : UITableViewCell

/**    代理    */
@property(nonatomic,weak) id<SignInCellDelegate> delegate;
/**    签到概览    */
@property(nonatomic,strong) SignInOverviewItem *overviewItem;
/**    签到列表    */
@property(nonatomic,strong) NSMutableArray *daysArray;


@end
