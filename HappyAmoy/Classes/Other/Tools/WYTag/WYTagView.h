//
//  WYTagView.h
//  DianDian
//
//  Created by apple on 17/10/27.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DetailCandicateItem;
@class WYTagView;

@protocol WYTagViewDelegate <NSObject>

@optional

- (void)tagView:(WYTagView *)tagView didClickTag:(id)tagItem;

@end

@interface WYTagView : UIView

/**    代理    */
@property (weak, nonatomic) id<WYTagViewDelegate> delegate;
/**    共同的兴趣爱好    */
@property (strong, nonatomic) NSArray *sameHobbyDataSource;
/**    数据源    */
@property (strong, nonatomic) NSArray *dataSource;

/**    标记collectionView是否可以被点击，默认为否    */
@property (assign, nonatomic) BOOL canClickCollectionView;

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

@end
