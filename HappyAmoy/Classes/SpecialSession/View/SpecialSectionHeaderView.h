//
//  SpecialSectionHeaderView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SpecialSectionHeaderView : UIView

/**    索引    */
@property (assign, nonatomic) NSInteger index;
/**    主标题    */
@property (copy, nonatomic) NSString *mainTitle;
/**    副标题    */
@property (copy, nonatomic) NSString *subTitle;
/**    是否需要隐藏全部按钮    */
@property (assign, nonatomic) BOOL isHiddenButton;
/**    点击全部的回调    */
@property (copy, nonatomic) void(^allButtonCallBack)(NSInteger index);

@end
