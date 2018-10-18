//
//  ExchangeSuccessView.m
//  HappyAmoy
//
//  Created by apple on 2018/7/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeSuccessView.h"

@implementation ExchangeSuccessView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = RGBA(0, 0, 0, 0.5);
    }
    return self;
}
#pragma mark - Public method
// 显示
- (void)show {
    [self UIOfNormal];
    self.alpha = 0;
    WeakSelf
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        weakSelf.alpha = 1.0;
    }];
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
    
    UIImageView *lightImageView = [[UIImageView alloc] init];
    lightImageView.image = ImageWithNamed(@"发光2");
    [self addSubview:lightImageView];
    [lightImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self);
        make.size.mas_equalTo(CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(370)));
    }];

    UIView *alertView = [[UIView alloc] init];
    alertView.backgroundColor = QHWhiteColor;
    alertView.layer.cornerRadius = AUTOSIZESCALEX(5);
    alertView.layer.masksToBounds = YES;
    [self addSubview:alertView];
    [alertView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AUTOSIZESCALEX(50));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-50));
        make.height.mas_equalTo(AUTOSIZESCALEX(185));
        make.center.equalTo(self);
    }];
    
    UIImageView *iconImageView = [[UIImageView alloc] init];
    iconImageView.image = ImageWithNamed(@"图层2");
    [alertView addSubview:iconImageView];
    [iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(alertView).offset(AUTOSIZESCALEX(-10));
        make.top.equalTo(alertView).offset(AUTOSIZESCALEX(25));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(70), AUTOSIZESCALEX(65)));
    }];

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"兑换成功！";
    titleLabel.font = TextFont(15);
    titleLabel.textColor = ColorWithHexString(@"#FB4F67");
    [alertView addSubview:titleLabel];
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(iconImageView.mas_bottom).offset(AUTOSIZESCALEX(25));
        make.centerX.equalTo(alertView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    UILabel *subTitleLabel = [[UILabel alloc] init];
    subTitleLabel.text = @"亲，我们会尽快为您发货！";
    subTitleLabel.font = TextFont(13);
    subTitleLabel.textColor = ColorWithHexString(@"#666666");
    [alertView addSubview:subTitleLabel];
    [subTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.centerX.equalTo(alertView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];

    WeakSelf
    UIButton *cancelButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [cancelButton setImage:ImageWithNamed(@"积分商城－关闭") forState:UIControlStateNormal];
    [self addSubview:cancelButton];
    cancelButton = cancelButton;
    [[cancelButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf dismiss];
        if (weakSelf.cancelCallBack) {
            weakSelf.cancelCallBack();
        }
    }];
    [cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(alertView.mas_top).offset(AUTOSIZESCALEX(-10));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-35));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(20), AUTOSIZESCALEX(20)));
    }];
}


@end
