//
//  ExchangeRemarkCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ExchangeRemarkCell;

@protocol ExchangeRemarkCellDelegate <NSObject>

@optional

- (void)exchangeRemarkCell:(ExchangeRemarkCell *)exchangeRemarkCell textViewDidBeginEditing:(NSString *)text;

- (void)exchangeRemarkCell:(ExchangeRemarkCell *)exchangeRemarkCell textViewDidEndEditing:(NSString *)text;


@end

@interface ExchangeRemarkCell : UITableViewCell

/**    备注    */
@property(nonatomic,copy) NSString *remark;
/**    代理    */
@property(nonatomic,weak) id<ExchangeRemarkCellDelegate> delegate;

@end
