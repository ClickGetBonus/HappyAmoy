//
//  ExchangeRemarkCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeRemarkCell.h"

@interface ExchangeRemarkCell () <UITextViewDelegate>

/**    备注    */
@property(nonatomic,strong) UILabel *remakeLabel;
/**    输入框    */
@property(nonatomic,strong) UITextView *textView;
/**    占位文字    */
@property(nonatomic,strong) UILabel *placeholderLabel;

@end

@implementation ExchangeRemarkCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *remakeLabel = [[UILabel alloc] init];
    remakeLabel.textColor = ColorWithHexString(@"#333333");
    remakeLabel.font = TextFont(14);
    remakeLabel.text = @"备注";
    [self.contentView addSubview:remakeLabel];
    self.remakeLabel = remakeLabel;
    
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderColor = ColorWithHexString(@"#CCCCCC").CGColor;
    textView.layer.borderWidth = AUTOSIZESCALEX(0.75);
    textView.textColor = ColorWithHexString(@"#333333");
    textView.font = TextFont(14);
    textView.delegate = self;
    textView.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:textView];
    self.textView = textView;
    
    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.textColor = ColorWithHexString(@"#CCCCCC");
    placeholderLabel.font = TextFont(13);
    placeholderLabel.text = @"会员充值类请填写充值相对应的账号";
    [self.contentView addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;

    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.remakeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(14));
    }];
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.remakeLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(140));
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(53));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(23));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];
}

#pragma mark - Setter

- (void)setRemark:(NSString *)remark {
    _remark = remark;
    if ([NSString isEmpty:_remark]) {
        self.placeholderLabel.hidden = NO;
    } else {
        self.placeholderLabel.hidden = YES;
    }
    self.textView.text = _remark;
}

#pragma mark - UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    
    self.placeholderLabel.hidden = textView.text.length > 0;
    
}

- (void)textViewDidBeginEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(exchangeRemarkCell:textViewDidBeginEditing:)]) {
        [_delegate exchangeRemarkCell:self textViewDidBeginEditing:@""];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([_delegate respondsToSelector:@selector(exchangeRemarkCell:textViewDidEndEditing:)]) {
        [_delegate exchangeRemarkCell:self textViewDidEndEditing:textView.text];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
