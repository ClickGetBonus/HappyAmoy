//
//  ReceiptAddressController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class AddressItem;

@interface ReceiptAddressController : BaseViewControll

/**    标记是否是选择地址    */
@property(nonatomic,assign) BOOL isSelectAddress;
/**    选择地址的回调    */
@property(nonatomic,copy) void(^selectAddressCallBack)(AddressItem *item);

@end
