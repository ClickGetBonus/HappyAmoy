//
//  MemberMoneyChildCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MemberMoneyChildCell : UICollectionViewCell

/**    索引    */
@property (assign, nonatomic) NSInteger index;
/**    类型    */
@property (copy, nonatomic) NSString *type;
/**    图标    */
@property (copy, nonatomic) NSString *iconName;
/**    余额    */
@property (copy, nonatomic) NSString *balance;

@end
