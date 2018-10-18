//
//  MineThirdSectionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineThirdSectionCell;

@protocol MineThirdSectionCellDelegate <NSObject>

@optional

- (void)mineThirdSectionCell:(MineThirdSectionCell *)mineThirdSectionCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface MineThirdSectionCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<MineThirdSectionCellDelegate> delegate;

@end
