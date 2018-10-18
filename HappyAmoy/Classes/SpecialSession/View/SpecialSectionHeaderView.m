//
//  SpecialSectionHeaderView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SpecialSectionHeaderView.h"

@interface SpecialSectionHeaderView()

/**    主标题    */
@property (strong, nonatomic) UILabel *mainTitleLabel;
/**    副标题    */
@property (strong, nonatomic) UILabel *subtitleLabel;
/**    全部    */
@property (strong, nonatomic) UIButton *allButton;

@end

@implementation SpecialSectionHeaderView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *mainTitleLabel = [[UILabel alloc] init];
    mainTitleLabel.text = @"今日推荐";
    mainTitleLabel.textColor = RGB(229, 99, 159);
    mainTitleLabel.font = TextFontBold(17);
    [self addSubview:mainTitleLabel];
    self.mainTitleLabel = mainTitleLabel;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"为你选择更多精品";
    subtitleLabel.textColor = RGB(135, 131, 132);
    subtitleLabel.font = TextFont(14);
    [self addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;
    
    UIButton *allButton = [UIButton buttonWithType:UIButtonTypeCustom];
    allButton.titleLabel.font = TextFont(15);
    [allButton setTitleColor:RGB(125, 125, 121) forState:UIControlStateNormal];
    [allButton setTitle:@"全部" forState:UIControlStateNormal];
    [allButton addTarget:self action:@selector(didClickAllButton) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:allButton];
    self.allButton = allButton;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.mainTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.centerY.equalTo(self);
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mainTitleLabel.mas_right).offset(AUTOSIZESCALEX(15));
        make.centerY.equalTo(self);
    }];
    
    [self.allButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Setter

- (void)setMainTitle:(NSString *)mainTitle {
    _mainTitle = mainTitle;
    self.mainTitleLabel.text = _mainTitle;
}

- (void)setSubTitle:(NSString *)subTitle {
    _subTitle = subTitle;
    self.subtitleLabel.text = _subTitle;
}

- (void)setIsHiddenButton:(BOOL)isHiddenButton {
    _isHiddenButton = isHiddenButton;
    self.allButton.hidden = _isHiddenButton;
}

#pragma mark - Button Action

- (void)didClickAllButton {
    if (self.allButtonCallBack) {
        self.allButtonCallBack(self.index);
    }
}

@end
