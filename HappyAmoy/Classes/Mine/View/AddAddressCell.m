//
//  AddAddressCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AddAddressCell.h"

@interface AddAddressCell () <UITextFieldDelegate>

@property(nonatomic,strong) UILabel *typeLabel;
@property(nonatomic,strong) UITextField *textField;

@end

@implementation AddAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *typeLabel = [[UILabel alloc] init];
    typeLabel.textColor = ColorWithHexString(@"#666666");
    typeLabel.font = TextFont(14);
    typeLabel.text = @"收件人 ：";
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];

    UITextField *textField = [[UITextField alloc] init];
    textField.delegate = self;
    textField.textColor = ColorWithHexString(@"#333333");
    textField.font = TextFont(14);
    textField.text = @"龙在江湖";
    textField.returnKeyType = UIReturnKeyDone;
    [self.contentView addSubview:textField];
    self.textField = textField;
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(90));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(SCREEN_WIDTH - AUTOSIZESCALEX(105));
    }];

    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(self.contentView);
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    self.textField.userInteractionEnabled = _canEdit;
}

- (void)setType:(NSString *)type {
    _type = type;
    self.typeLabel.text = _type;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.textField.text = _content;
}

#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(addAddressCell:textFieldDidEndEditing:index:)]) {
        [_delegate addAddressCell:self textFieldDidEndEditing:textField.text index:self.index];
    }
}

@end
