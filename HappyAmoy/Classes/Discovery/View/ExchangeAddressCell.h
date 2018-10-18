//
//  ExchangeAddressCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddressItem;

@interface ExchangeAddressCell : UITableViewCell

/**    地址    */
@property(nonatomic,strong) AddressItem *item;

@end
