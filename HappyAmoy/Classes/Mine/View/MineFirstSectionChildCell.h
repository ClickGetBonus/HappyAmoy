//
//  MineFirstSectionChildCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineFirstSectionChildCell : UICollectionViewCell

/**    图标    */
@property (strong, nonatomic) UIButton *iconImageView;
/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    余额    */
@property (strong, nonatomic) UILabel *balanceLabel;

/**    索引    */
@property (assign, nonatomic) NSInteger index;
/**    类型    */
@property (copy, nonatomic) NSString *type;
/**    图标    */
@property (copy, nonatomic) NSString *iconName;
/**    余额    */
@property (copy, nonatomic) NSString *balance;

@end
