//
//  SearchTicketView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchTicketView.h"

@interface SearchTicketView() <UITextFieldDelegate>

/**    背景    */
@property (strong, nonatomic) UIImageView *bgImageView;
/**    标题    */
@property (strong, nonatomic) UILabel *titleLabel;
/**    附标题    */
@property (strong, nonatomic) UILabel *subtitleLabel;
/**    输入背景框    */
@property (strong, nonatomic) UIView *editBgView;
/**    输入框    */
@property (strong, nonatomic) UITextField *textField;
/**    搜索按钮    */
@property (strong, nonatomic) UIButton *searchButton;

@end

@implementation SearchTicketView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = [UIImage scaleAcceptFitWithImage:ImageWithNamed(@"search_bgImage") imageViewSize:CGSizeMake(SCREEN_WIDTH, AUTOSIZESCALEX(210))];
    [self addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @"淘宝/天猫独家优惠券";
    titleLabel.font = TextFontBold(18.5);
    titleLabel.textColor = QHWhiteColor;
    [self addSubview:titleLabel];
    self.titleLabel = titleLabel;
    
    UILabel *subtitleLabel = [[UILabel alloc] init];
    subtitleLabel.text = @"购物最高省90%";
    subtitleLabel.font = TextFont(16);
    subtitleLabel.textColor = QHWhiteColor;
    [self addSubview:subtitleLabel];
    self.subtitleLabel = subtitleLabel;

    UIView *editBgView = [[UIView alloc] init];
    editBgView.backgroundColor = QHWhiteColor;
    editBgView.layer.cornerRadius = 5;
    editBgView.layer.masksToBounds = YES;
    [self addSubview:editBgView];
    self.editBgView = editBgView;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"输入商品关键词，搜索商品优惠券";
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    textField.font = TextFont(14);
    textField.textColor = QHBlackColor;
    [self.editBgView addSubview:textField];
    self.textField = textField;
    
    UIButton *searchButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [searchButton setTitle:@"搜索" forState:UIControlStateNormal];
    [searchButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(50), AUTOSIZESCALEX(37.5)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    searchButton.titleLabel.font = TextFont(14);
    [searchButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
//    [searchButton setBackgroundColor:QHMainColor];
    
    WeakSelf
    
    [[searchButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf endEditing:YES];
        if ([weakSelf.delegate respondsToSelector:@selector(searchTicketView:searchWithContent:)]) {
            [weakSelf.delegate searchTicketView:weakSelf searchWithContent:weakSelf.textField.text];
        }
        weakSelf.textField.text = @"";
    }];
    [self.editBgView addSubview:searchButton];
    self.searchButton = searchButton;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.titleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(55));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.subtitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.titleLabel.mas_bottom).offset(AUTOSIZESCALEX(10));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.editBgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.subtitleLabel.mas_bottom).offset(AUTOSIZESCALEX(25));
        make.centerX.equalTo(self).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(35));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-35));
        make.height.mas_equalTo(AUTOSIZESCALEX(37.5));
    }];
    
    [self.searchButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editBgView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.editBgView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.editBgView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(50));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.editBgView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.editBgView).offset(AUTOSIZESCALEX(10));
        make.bottom.equalTo(self.editBgView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.searchButton.mas_left).offset(AUTOSIZESCALEX(-10));
    }];
}

// 点击搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    WYLog(@"text = %@",textField.text);
    
    if ([self.delegate respondsToSelector:@selector(searchTicketView:searchWithContent:)]) {
        [self.delegate searchTicketView:self searchWithContent:self.textField.text];
    }
    self.textField.text = @"";
    [self.textField resignFirstResponder];
    return YES;
}

@end
