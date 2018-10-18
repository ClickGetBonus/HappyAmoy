//
//  MineNormalCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/19.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineNormalCell.h"

@interface MineNormalCell()

/**    图标    */
@property (strong, nonatomic) UIButton *iconImageView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    箭头    */
@property (strong, nonatomic) UIImageView *arrowImageView;
/**    右边按钮    */
@property (strong, nonatomic) UIButton *rightButton;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation MineNormalCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    WeakSelf

    UIButton *iconImageView = [UIButton buttonWithType:UIButtonTypeCustom];
    [iconImageView setImage:ImageWithNamed(@"defaultHeadImage") forState:UIControlStateNormal];
    [self.contentView addSubview:iconImageView];
    self.iconImageView = iconImageView;

    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.font = TextFont(14);
    titleLabel.textColor = QHBlackColor;
    [self.contentView addSubview:titleLabel];
    self.titleLabel = titleLabel;
    [RACObserve([LoginUserDefault userDefault], dataHaveChanged) subscribeNext:^(id x) {
        if (weakSelf.isRecommendCode) {
            if ([LoginUserDefault userDefault].isTouristsMode) {
                weakSelf.titleLabel.text = @"我的邀请码";
            } else {
                NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的推荐码：%@",[LoginUserDefault userDefault].userItem.recommendCode]];
                [attribute addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"00A8EE") range:NSMakeRange(6, attribute.length - 6)];
                weakSelf.titleLabel.attributedText = attribute;
            }
        }
    }];
    UIButton *rightButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [rightButton setTitleColor:QHMainColor forState:UIControlStateNormal];
    rightButton.titleLabel.font = TextFont(14);
    [rightButton setTitle:@"复制" forState:UIControlStateNormal];
    rightButton.hidden = YES;
    [self.contentView addSubview:rightButton];
    self.rightButton = rightButton;
    [[self.rightButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        if (weakSelf.isRecommendCode) {
            if (![LoginUserDefault userDefault].isTouristsMode) {
                UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
                pasteboard.string = [LoginUserDefault userDefault].userItem.recommendCode;
                [WYHud showMessage:@"已复制到剪贴板!"];
                WYLog(@"复制的内容 = %@",[LoginUserDefault userDefault].userItem.recommendCode);
            }
        }
    }];
    
    UIImageView *arrowImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next")];
    [self.contentView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.iconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.width.mas_equalTo(AUTOSIZESCALEX(25));
        make.height.mas_equalTo(AUTOSIZESCALEX(25));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.iconImageView.mas_right).offset(AUTOSIZESCALEX(10));
    }];
    
    [self.rightButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
    
}

#pragma mark - Setter

- (void)setIsRecommendCode:(BOOL)isRecommendCode {
    _isRecommendCode = isRecommendCode;
}

- (void)setTitle:(NSString *)title {
    _title = title;
    
    if (_isRecommendCode) {
        if (![LoginUserDefault userDefault].isTouristsMode) {
            NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"我的推荐码：%@",[LoginUserDefault userDefault].userItem.recommendCode]];
            [attribute addAttribute:NSForegroundColorAttributeName value:ColorWithHexString(@"00A8EE") range:NSMakeRange(6, attribute.length - 6)];
            self.titleLabel.attributedText = attribute;
        } else {
            self.titleLabel.text = @"我的推荐码";
        }
    } else {
        self.titleLabel.text = _title;
    }
}

- (void)setIconName:(NSString *)iconName {
    _iconName = iconName;
    [self.iconImageView setImage:ImageWithNamed(_iconName) forState:UIControlStateNormal];
}

- (void)setRightButtonTitle:(NSString *)rightButtonTitle {
    _rightButtonTitle = rightButtonTitle;
    [self.rightButton setTitle:_rightButtonTitle forState:UIControlStateNormal];
    self.rightButton.hidden = [NSString isEmpty:_rightButtonTitle];
    self.arrowImageView.hidden = !self.rightButton.hidden;
}

@end
