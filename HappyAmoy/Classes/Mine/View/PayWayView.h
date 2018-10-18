//
//  PayWayView.h
//  HappyAmoy
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PayWayView;

@protocol PayWayViewDelegate <NSObject>

@optional

- (void)payWayView:(PayWayView *)payWayView didSelectedPayWay:(NSInteger)payWay;

@end

@interface PayWayView : UIView

/**    代理    */
@property (weak, nonatomic) id<PayWayViewDelegate> delegate;

- (void)show;


@end
