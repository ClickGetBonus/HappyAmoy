//
//  MemberListCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberListCell : UITableViewCell

/**    排名    */
@property (assign, nonatomic) NSInteger sort;
/**    会员    */
@property (copy, nonatomic) NSString *memberName;
/**    奖励    */
@property (copy, nonatomic) NSString *reward;

@end
