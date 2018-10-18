//
//  QHNewFeatureCell.h
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class QHNewFeatureCell;
@class BootPagesItem;

@protocol QHNewFeatureCellDelegate <NSObject>

@optional

- (void)newFeatureCell:(QHNewFeatureCell *)newFeatureCell didClickStartAtOnce:(UIButton *)sender;

@end

@interface QHNewFeatureCell : UICollectionViewCell

/**    数据模型    */
@property (strong, nonatomic) BootPagesItem *item;
/**    标记是否是最后一个新特性    */
@property (assign, nonatomic) BOOL isLastFeature;
/**    图片    */
@property (strong, nonatomic) UIImage *featureImage;
/**    标记是否隐藏按钮    */
@property (assign, nonatomic) BOOL isHiddenButton;

/**    代理    **/
@property (weak, nonatomic) id<QHNewFeatureCellDelegate> delegate;

@end
