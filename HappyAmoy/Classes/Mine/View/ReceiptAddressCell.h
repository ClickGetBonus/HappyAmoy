//
//  ReceiptAddressCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressItem;

@interface ReceiptAddressCell : UITableViewCell

/**    数据模型    */
@property(nonatomic,strong) AddressItem *item;

@end
