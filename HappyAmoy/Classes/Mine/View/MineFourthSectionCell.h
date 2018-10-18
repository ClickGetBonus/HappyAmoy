//
//  MineFourthSectionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MineFourthSectionCell;

@protocol MineFourthSectionCellDelegate <NSObject>

@optional

- (void)mineFourthSectionCell:(MineFourthSectionCell *)mineFourthSectionCell didSelectItemAtIndex:(NSInteger)index;

@end

@interface MineFourthSectionCell : UITableViewCell

/**    代理    */
@property (weak, nonatomic) id<MineFourthSectionCellDelegate> delegate;

@end
