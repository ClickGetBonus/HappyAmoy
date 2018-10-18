//
//  MemberRankSecondSectionCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/15.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class MemberRankItem;

@interface MemberRankSecondSectionCell : UITableViewCell

/**    索引    */
@property(nonatomic,assign) NSInteger index;
/**    数据模型    */
@property(nonatomic,strong) MemberRankItem *item;

@end
