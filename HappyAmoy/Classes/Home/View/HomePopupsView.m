//
//  HomePopupsView.m
//  HappyAmoy
//
//  Created by apple on 2018/7/27.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HomePopupsView.h"

@implementation HomePopupsView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    }
    return self;
}
#pragma mark - Public method
// 显示
- (void)show {
//    [self UIOfNormal];
//    self.alpha = 0;
//    WeakSelf
//    [[UIApplication sharedApplication].keyWindow addSubview:self];
//    
//    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
//        weakSelf.alpha = 1.0;
//    }];
}

// 关闭弹框
- (void)dismiss {
    WeakSelf
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

#pragma mark - UI
// 普通样式
- (void)UIOfNormal {
//
//    UIImageView *lightImageView = [[UIImageView alloc] init];
//    lightImageView.image = ImageWithNamed(@"发光2");
//    [self addSubview:lightImageView];
//    [lightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.center.equalTo(self);
//        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(370)));
//    }];
//
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = ImageWithNamed(@"首页弹窗");
    iconImageView.userInteractionEnabled = YES;
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didClickIconImageView)];
    [iconImageView addGestureRecognizer:tap];
    [self addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(50), SCREEN_WIDTH - AUTOSIZESCALEX(50)));
    }];
    
    WeakSelf
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:ImageWithNamed(@"首页弹窗关闭") forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    cancelButton = cancelButton;
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf dismiss];
        
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(-140));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(30), AUTOSIZESCALEX(30)));
    }];
}

#pragma mark - Button Action

- (void)didClickIconImageView {
    [self removeFromSuperview];

    if (self.clickIconCallBack) {
        self.clickIconCallBack();
    }
}

@end
