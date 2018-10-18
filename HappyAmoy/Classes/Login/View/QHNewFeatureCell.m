//
//  QHNewFeatureCell.m
//  QianHong
//
//  Created by apple on 2018/3/19.
//  Copyright © 2018年 YouQu. All rights reserved.
//

#import "QHNewFeatureCell.h"
#import "BootPagesItem.h"

@interface QHNewFeatureCell ()

/**    新特性图片    */
@property (strong, nonatomic) UIImageView *featureImageView;
/**    立即开启按钮    */
@property (strong, nonatomic) UIButton *startAtOnceButton;

@end

@implementation QHNewFeatureCell

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *featureImageView = [[UIImageView alloc] init];
    featureImageView.image = ImageWithNamed(@"launch");
    [self.contentView addSubview:featureImageView];
    self.featureImageView = featureImageView;
    
    UIButton *startAtOnceButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [startAtOnceButton setTitle:@"即刻开启" forState:UIControlStateNormal];
    startAtOnceButton.titleLabel.font = TextFontBold(20);
    startAtOnceButton.layer.borderWidth = 1.0;
    startAtOnceButton.layer.borderColor = ColorWithHexString(@"#ffb42b").CGColor;
    [startAtOnceButton setTitleColor:ColorWithHexString(@"#ffb42b") forState:UIControlStateNormal];
    [startAtOnceButton addTarget:self action:@selector(didClcikStartAtOnceButton) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:startAtOnceButton];
    self.startAtOnceButton = startAtOnceButton;
    // 添加约束
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {

    [self.featureImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
    [self.maskView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
    
//    [self.topLeftBorderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEY(200));
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(63.5));
//        make.width.mas_equalTo(AUTOSIZESCALEX(40));
//        make.height.mas_equalTo(AUTOSIZESCALEX(40));
//    }];
//
//    [self.firstTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.topLeftBorderImageView.mas_bottom).offset(AUTOSIZESCALEY(10));
//        make.left.equalTo(self.topLeftBorderImageView.mas_right).offset(AUTOSIZESCALEY(0));
//    }];
//
//    [self.secondTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.firstTitleLabel.mas_bottom).offset(AUTOSIZESCALEY(25));
//        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEY(150));
//    }];
//
//    [self.bottomRightBorderImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.secondTitleLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
//        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-63.5));
//        make.width.equalTo(self.topLeftBorderImageView);
//        make.height.equalTo(self.topLeftBorderImageView);
//    }];
    
    [self.startAtOnceButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEY(-30));
        make.centerX.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(200));
        make.height.mas_equalTo(AUTOSIZESCALEX(40));
    }];
}

#pragma mark - Button Action
// 点击即刻开启
- (void)didClcikStartAtOnceButton {
    if ([_delegate respondsToSelector:@selector(newFeatureCell:didClickStartAtOnce:)]) {
        [_delegate newFeatureCell:self didClickStartAtOnce:self.startAtOnceButton];
    }
}

#pragma mark - Setter

- (void)setItem:(BootPagesItem *)item {
    _item = item;
    if (_item) {
        [self.featureImageView wy_setImageWithUrlString:_item.imageUrl placeholderImage:ImageWithNamed(@"launch")];
    }
}

- (void)setFeatureImage:(UIImage *)featureImage {
    
    _featureImage = featureImage;
    
    self.featureImageView.image = _featureImage;
}

- (void)setIsLastFeature:(BOOL)isLastFeature {
    
    _isLastFeature = isLastFeature;
    
    self.startAtOnceButton.hidden = !_isLastFeature;
}

- (void)setIsHiddenButton:(BOOL)isHiddenButton {
    _isHiddenButton = isHiddenButton;
    self.startAtOnceButton.hidden = isHiddenButton;
}

@end
