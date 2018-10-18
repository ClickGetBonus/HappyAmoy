//
//  PersonalEditCell.h
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PersonalEditCell;

@protocol PersonalEditCellDelegate <NSObject>

@optional

- (void)personalEditCell:(PersonalEditCell *)personalEditCell textFieldDidEndEditing:(NSString *)content;

@end

@interface PersonalEditCell : UITableViewCell

/**    类型    */
@property (copy, nonatomic) NSString *type;
/**    内容    */
@property (copy, nonatomic) NSString *content;
/**    标记是否可以编辑，默认可以编辑    */
@property (assign, nonatomic) BOOL canEdit;
/**    代理    */
@property (weak, nonatomic) id<PersonalEditCellDelegate> delegate;

@end
