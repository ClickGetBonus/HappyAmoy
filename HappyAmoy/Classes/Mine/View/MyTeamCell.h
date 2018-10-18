//
//  MyTeamCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyTeamCell : UITableViewCell

/**    类型    */
@property (copy, nonatomic) NSString *type;
/**    索引    */
@property (assign, nonatomic) NSInteger index;
/**    数据源    */
@property (strong, nonatomic) NSDictionary *dataDict;

@end
