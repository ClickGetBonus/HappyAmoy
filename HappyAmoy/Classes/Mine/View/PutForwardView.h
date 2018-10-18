//
//  PutForwardView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PutForwardView;

@protocol PutForwardViewDelegate <NSObject>

@optional

- (void)putForwardView:(PutForwardView *)putForwardView changeAccount:(NSString *)account;
- (void)putForwardView:(PutForwardView *)putForwardView checkProtocol:(NSString *)protocol;
- (void)putForwardView:(PutForwardView *)putForwardView confirmPutForward:(NSString *)money;

@end

@interface PutForwardView : UIView

/**    代理    */
@property (weak, nonatomic) id<PutForwardViewDelegate> delegate;

@end
