//
//  PayWayView.m
//  HappyAmoy
//
//  Created by apple on 2018/5/5.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PayWayView.h"

@interface PayWayView()

/**    遮罩    */
@property (strong, nonatomic) UIView *maskView;
/**    弹框    */
@property (strong, nonatomic) UIView *bulletView;

@end

@implementation PayWayView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *maskView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.3);
    [self addSubview:maskView];
    self.maskView = maskView;
    
    UIView *bulletView = [[UIView alloc] init];
    bulletView.backgroundColor = QHWhiteColor;
    bulletView.layer.cornerRadius = AUTOSIZESCALEX(5);
    bulletView.layer.masksToBounds = YES;
    [self addSubview:bulletView];
    self.bulletView = bulletView;
    CGFloat top = AUTOSIZESCALEX(185);
    if (UI_IS_IPHONEX) {
        top = AUTOSIZESCALEX(260);
    }
    [self.bulletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AUTOSIZESCALEX(50));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-50));
        make.top.equalTo(self).offset(top);
//        make.centerY.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(145));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = ColorWithHexString(@"000000");
    titleLabel.font = TextFont(15);
    titleLabel.text = @"请选择支付方式";
    [self.bulletView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.bulletView).offset(AUTOSIZESCALEX(0));
        make.top.equalTo(self.bulletView).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    WeakSelf
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:ImageWithNamed(@"关闭") forState:UIControlStateNormal];
    [[closeButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismiss];
    }];
    [self.bulletView addSubview:closeButton];
    
    [closeButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bulletView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.bulletView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.bulletView addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(titleLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.bulletView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.bulletView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIButton *alipayButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[alipayButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismiss];
        if ([weakSelf.delegate respondsToSelector:@selector(payWayView:didSelectedPayWay:)]) {
            [weakSelf.delegate payWayView:weakSelf didSelectedPayWay:1];
        }
    }];
    [self.bulletView addSubview:alipayButton];
    
    [alipayButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(line).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(line).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];
    
    UIImageView *icon1 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"支付宝支付")];
    [alipayButton addSubview:icon1];
    
    [icon1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(alipayButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(alipayButton).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(25));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    UILabel *payLabel = [[UILabel alloc] init];
    payLabel.textColor = ColorWithHexString(@"232322");
    payLabel.font = TextFont(14);
    payLabel.text = @"支付宝支付";
    [alipayButton addSubview:payLabel];
    
    [payLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon1).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(icon1.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    UIImageView *arrow1 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next")];
    [alipayButton addSubview:arrow1];
    
    [arrow1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(alipayButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(alipayButton).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = SeparatorLineColor;
    [self.bulletView addSubview:line2];
    
    [line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(alipayButton.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(line).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(line).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIButton *wechatButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [[wechatButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf dismiss];
        if ([weakSelf.delegate respondsToSelector:@selector(payWayView:didSelectedPayWay:)]) {
            [weakSelf.delegate payWayView:weakSelf didSelectedPayWay:2];
        }
    }];
    [self.bulletView addSubview:wechatButton];
    
    [wechatButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line2.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(line).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(line).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.bulletView).offset(AUTOSIZESCALEX(0));
    }];
    
    UIImageView *icon2 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"微信支付")];
    [alipayButton addSubview:icon2];
    
    [icon2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wechatButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(wechatButton).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(25));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    UILabel *payLabe2 = [[UILabel alloc] init];
    payLabe2.textColor = ColorWithHexString(@"232322");
    payLabe2.font = TextFont(14);
    payLabe2.text = @"微信支付";
    [wechatButton addSubview:payLabe2];
    
    [payLabe2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(icon2).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(icon2.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    UIImageView *arrow2 = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next")];
    [wechatButton addSubview:arrow2];
    
    [arrow2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(wechatButton).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(wechatButton).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
}

#pragma mark - Public method

- (void)show {
    
    self.alpha = 0;

    WeakSelf
    
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        weakSelf.alpha = 1.0;
    }];
}

- (void)dismiss {
    
    WeakSelf
    
    [UIView animateWithDuration:DEFAULT_DURATION animations:^{
        weakSelf.alpha = 0;
    } completion:^(BOOL finished) {
        [weakSelf removeFromSuperview];
    }];
}

@end
