//
//  GoodsDetailWebCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GoodsDetailWebCell : UITableViewCell


/**    html    */
@property (copy, nonatomic) NSString *content;

@property (copy, nonatomic) NSAttributedString *attribute;

/**    回调    */
@property (copy, nonatomic) void(^loadFinish)(void);

@end
