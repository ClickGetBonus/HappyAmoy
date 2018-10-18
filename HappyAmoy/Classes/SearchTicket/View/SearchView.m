//
//  SearchView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchView.h"

@interface SearchView() <UITextFieldDelegate>

/**    搜索图标    */
@property (strong, nonatomic) UIImageView *searchIconImageView;
/**    占位文字    */
@property (strong, nonatomic) UITextField *textField;


@end

@implementation SearchView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        
        self.layer.cornerRadius = 15;
        self.layer.masksToBounds = YES;
        self.backgroundColor = RGBA(0, 0, 0, 0.35);

        [self setupUI];

    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *searchIconImageView = [[UIImageView alloc] init];
    searchIconImageView.image = ImageWithNamed(@"搜索栏");
    [self addSubview:searchIconImageView];
    self.searchIconImageView = searchIconImageView;

    UITextField *textField = [[UITextField alloc] init];
    textField.placeholder = @"输入商品关键词，搜索商品优惠券";
    textField.textColor = ColorWithHexString(@"000000");
    // "通过KVC修改占位文字的颜色"
    [textField setValue:ColorWithHexString(@"999999") forKeyPath:@"_placeholderLabel.textColor"];
    textField.font = TextFont(11);
    textField.returnKeyType = UIReturnKeySearch;
    textField.delegate = self;
    [self addSubview:textField];
    self.textField = textField;

    [self.searchIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(AUTOSIZESCALEX(10));
        make.centerY.equalTo(self);
        make.width.mas_equalTo(AUTOSIZESCALEX(18));
        make.height.mas_equalTo(AUTOSIZESCALEX(18));
    }];

    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.searchIconImageView.mas_right).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-10));
        make.centerY.equalTo(self);
    }];
}

#pragma mark - Setter
- (void)setKeyword:(NSString *)keyword {
    _keyword = keyword;
    self.textField.text = _keyword;
}

- (NSString *)getKeyword
{
    return self.textField.text;
}

- (void)setPlaceholder:(NSString *)placeholder {
    _placeholder = placeholder;
    self.textField.placeholder = placeholder;
}

#pragma mark - Public method
// 开始编辑
- (void)beginEditingWithContent:(NSString *)content {
    
    self.textField.text = content;
    [self.textField becomeFirstResponder];
}

// 结束编辑
- (void)endEditing {
    [self.textField resignFirstResponder];
}

#pragma mark - UITextFieldDelegate

// 点击搜索
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    WYLog(@"text = %@",textField.text);
    
    if ([_delegate respondsToSelector:@selector(searchView:searchWithContent:)]) {
        [_delegate searchView:self searchWithContent:textField.text];
    }
    [textField resignFirstResponder];
    return YES;
}

@end
