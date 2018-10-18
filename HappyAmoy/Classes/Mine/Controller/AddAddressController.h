//
//  AddAddressController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class AddressItem;

@interface AddAddressController : BaseViewControll

/**    标识是否是修改    */
@property(nonatomic,assign) BOOL isModify;
/**    数据模型    */
@property(nonatomic,strong) AddressItem *item;

@end
