//
//  MineFirstSectionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineFirstSectionCell;

@protocol MineFirstSectionCellDelegate <NSObject>

@optional

- (void)mineFirstSectionCell:(MineFirstSectionCell *)mineFirstSectionCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface MineFirstSectionCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<MineFirstSectionCellDelegate> delegate;
/**    余额数组    */
@property (strong, nonatomic) NSMutableArray *balanceArray;

@end
