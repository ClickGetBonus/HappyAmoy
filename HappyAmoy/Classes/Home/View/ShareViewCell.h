//
//  ShareViewCell.h
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ShareViewCell : UICollectionViewCell

/**    图标    */
@property (strong, nonatomic) UIImage *iconImage;
/**    平台    */
@property (copy, nonatomic) NSString *platform;

@end
