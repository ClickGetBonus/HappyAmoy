//
//  PersonalheadImageCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PersonalheadImageCell : UITableViewCell

/**    头像    */
@property (strong, nonatomic) UIImage *headImage;
/**    头像url    */
@property (copy, nonatomic) NSString *headPicUrl;

@end
