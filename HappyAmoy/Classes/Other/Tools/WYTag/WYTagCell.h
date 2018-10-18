//
//  WYTagCell.h
//  DianDian
//
//  Created by apple on 17/10/27.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CustomCoterieItem;

@interface WYTagCell : UICollectionViewCell

/**    是否是共同的兴趣爱好    */
@property (assign, nonatomic) BOOL isSameHobby;
/**    标签内容    */
@property (copy, nonatomic) NSString *tagString;
/**    自定义部落模型    */
@property (strong, nonatomic) CustomCoterieItem *item;
/**    背景颜色    */
@property (strong, nonatomic) UIColor *defaultBackgroundColor;
/**    文字颜色    */
@property (strong, nonatomic) UIColor *defaultTextColor;
/**    边框颜色    */
@property (strong, nonatomic) UIColor *defaultBorderColor;
/**    共同爱好的背景颜色    */
@property (strong, nonatomic) UIColor *backgroundColorOfSameHobby;
/**    共同爱好的文字颜色    */
@property (strong, nonatomic) UIColor *textColorOfSameHobby;
/**    共同爱好的边框颜色    */
@property (strong, nonatomic) UIColor *borderColorOfSameHobby;

/**    点击标签按钮的回调    */
@property (copy, nonatomic) void(^didClickTagButtonCallBack)(id tagItem);

@end
