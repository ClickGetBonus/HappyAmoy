//
//  ShareView.h
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ShareView;

@protocol ShareViewDelegate <NSObject>

@optional

- (void)shareView:(ShareView *)shareView platformType:(UMSocialPlatformType)platformType;

@end

@interface ShareView : UIView

/**    代理    */
@property (weak, nonatomic) id<ShareViewDelegate> delegate;

@end
