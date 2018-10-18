//
//  AddAddressCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AddAddressCell;

@protocol AddAddressCellDelegate <NSObject>

@optional

- (void)addAddressCell:(AddAddressCell *)addAddressCell textFieldDidEndEditing:(NSString *)text index:(NSInteger)index;

@end

@interface AddAddressCell : UITableViewCell

/**    标识是否可以编辑    */
@property(nonatomic,assign) BOOL canEdit;
/**    类型    */
@property(nonatomic,copy) NSString *type;
/**    内容    */
@property(nonatomic,copy) NSString *content;
/**    索引    */
@property(nonatomic,assign) NSInteger index;
/**    代理    */
@property(nonatomic,weak) id<AddAddressCellDelegate> delegate;

@end
