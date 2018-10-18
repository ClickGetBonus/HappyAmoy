//
//  WYTagFlowLayout.h
//  DianDian
//
//  Created by apple on 17/10/27.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYTagFlowLayout;

@protocol WYTagFlowLayoutDataSource <NSObject>

@required

- (NSString *)tagFlowLayout:(WYTagFlowLayout *)tagFlowLayout titleForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol WYTagFlowLayoutDelegate <NSObject>

@optional

- (void)tagFlowLayout:(WYTagFlowLayout *)tagFlowLayout collectionViewHeight:(CGFloat)height;

@end

@interface WYTagFlowLayout : UICollectionViewFlowLayout

/**    布局的数据源    */
@property (assign, nonatomic) id<WYTagFlowLayoutDataSource> dataSource;
/**    布局的代理    */
@property (assign, nonatomic) id<WYTagFlowLayoutDelegate> delegate;

@end
