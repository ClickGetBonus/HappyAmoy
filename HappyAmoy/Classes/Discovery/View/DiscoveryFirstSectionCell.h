//
//  DiscoveryFirstSectionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/11.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DiscoveryFirstSectionCell : UITableViewCell

/**    标题    */
@property(nonatomic,copy) NSString *title;
/**    banner    */
@property(nonatomic,strong) UIImage *bannerImage;
/**    标记是否隐藏分割线    */
@property(nonatomic,assign) BOOL hiddenLine;


@end
