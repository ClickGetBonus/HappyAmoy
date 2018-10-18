//
//  MessageCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MessageItem;

@interface MessageCell : UITableViewCell

/**    数据模型    */
@property (strong, nonatomic) MessageItem *item;

/**    标识是否是好友消息通知    */
@property(nonatomic,assign) BOOL isFriendNotice;

@end
