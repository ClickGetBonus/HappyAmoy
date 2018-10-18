//
//  HistorySearchCell.h
//  HappyAmoy
//
//  Created by lb on 2018/9/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HistorySearchCell : UITableViewCell

@property (nonatomic, copy  )void (^searchTapHistoryBlock)(NSInteger tag);

- (void)setHistoryArray:(NSArray *)historyArray;

- (float)getRowHeight;

@end

NS_ASSUME_NONNULL_END
