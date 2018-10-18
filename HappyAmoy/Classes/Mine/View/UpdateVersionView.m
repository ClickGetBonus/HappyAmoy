//
//  UpdateVersionView.m
//  HappyAmoy
//
//  Created by apple on 2018/5/9.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "UpdateVersionView.h"

@interface UpdateVersionView ()

/**    遮罩    */
@property (strong, nonatomic) UIView *maskView;
/**    弹框    */
@property (strong, nonatomic) UIView *bulletView;
/**    更新内容label    */
@property (strong, nonatomic) UILabel *contentLabel;

@end

@implementation UpdateVersionView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *maskView = [[UIView alloc] initWithFrame:SCREEN_FRAME];
    maskView.backgroundColor = RGBA(0, 0, 0, 0.4);
    [self addSubview:maskView];
    self.maskView = maskView;
    
    UIView *bulletView = [[UIView alloc] init];
    bulletView.backgroundColor = QHWhiteColor;
    bulletView.layer.cornerRadius = AUTOSIZESCALEX(5);
    bulletView.layer.masksToBounds = YES;
    [self addSubview:bulletView];
    self.bulletView = bulletView;
    
    [self.bulletView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AUTOSIZESCALEX(65));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-65));
        make.centerY.equalTo(self).offset(AUTOSIZESCALEX(0));
//        make.height.mas_equalTo(AUTOSIZESCALEX(305));
    }];
    
    UIImageView *bgImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"设置-版本升级")];
    [self.bulletView addSubview:bgImageView];
    [bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(self.bulletView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(130));
    }];
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.textColor = ColorWithHexString(@"#FFFFFF");
    titleLabel.font = TextFont(15);
    titleLabel.text = @"发现新版本啦～";
    [self.bulletView addSubview:titleLabel];
    
    [titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bulletView).offset(AUTOSIZESCALEX(15));
        make.top.equalTo(self.bulletView).offset(AUTOSIZESCALEX(48));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    WeakSelf
    
    UIButton *closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [closeButton setBackgroundImage:ImageWithNamed(@"关闭_白色") forState:UIControlStateNormal];
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
        make.bottom.equalTo(self.bulletView).offset(AUTOSIZESCALEX(-60));
        make.left.equalTo(self.bulletView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.bulletView).offset(AUTOSIZESCALEX(-10));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
    UIButton *updateButton = [UIButton buttonWithType:UIButtonTypeCustom];
    updateButton.layer.cornerRadius = AUTOSIZESCALEX(5);
    updateButton.layer.masksToBounds = YES;
    [updateButton setTitle:@"立即升级" forState:UIControlStateNormal];
    [updateButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    updateButton.titleLabel.font = TextFont(13);
    [updateButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(30)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [[updateButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(UIButton *sender) {
        [weakSelf dismiss];
        if ([weakSelf.delegate respondsToSelector:@selector(updateVersionView:didClcikUpdateButton:)]) {
            [weakSelf.delegate updateVersionView:weakSelf didClcikUpdateButton:sender];
        }
    }];
    [self.bulletView addSubview:updateButton];
    
    [updateButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(line.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.centerX.equalTo(self.bulletView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(90));
        make.height.mas_equalTo(AUTOSIZESCALEX(30));
    }];
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = ColorWithHexString(@"#333333");
    tipsLabel.font = TextFont(13);
    tipsLabel.text = @"更新内容:";
    [self.bulletView addSubview:tipsLabel];
    
    [tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bulletView).offset(AUTOSIZESCALEX(16));
        make.top.equalTo(self.bulletView).offset(AUTOSIZESCALEX(125));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];
    UILabel *contentLabel = [[UILabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textColor = ColorWithHexString(@"#666666");
    contentLabel.font = TextFont(12);
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"1、修复了部分bug体验更优\n2、双十一双重活动来袭，快来领福利!\n3、增加更多礼包\n4、优化了部分界面"];
    attribute.yy_lineSpacing = AUTOSIZESCALEX(5);
    contentLabel.attributedText = attribute;
    [self.bulletView addSubview:contentLabel];
    self.contentLabel = contentLabel;
    [self.contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipsLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(tipsLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.bulletView).offset(AUTOSIZESCALEX(-15));
        make.bottom.equalTo(self.bulletView).offset(AUTOSIZESCALEX(-70));
    }];

}

#pragma mark - Setter

- (void)setUpdateDesc:(NSString *)updateDesc {
    _updateDesc = updateDesc;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:_updateDesc];
    attribute.yy_lineSpacing = AUTOSIZESCALEX(5);
    self.contentLabel.attributedText = attribute;
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
