//
//  PersonalEditCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PersonalEditCell.h"

@interface PersonalEditCell() <UITextFieldDelegate>

/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    箭头    */
@property (strong, nonatomic) UIImageView *arrowImageView;
/**    输入框    */
@property (strong, nonatomic) UITextField *textField;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation PersonalEditCell

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
    typeLabel.text = @"昵称";
    typeLabel.textColor = RGB(90, 90, 90);
    typeLabel.font = TextFont(15);
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = ImageWithNamed(@"grayRightArrow");
    [self.contentView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UITextField *textField = [[UITextField alloc] init];
    textField.textAlignment = NSTextAlignmentRight;
    textField.font = TextFont(15);
    textField.textColor = RGB(150, 150, 150);
    textField.text = @"小幸运";
    textField.delegate = self;
    [self.contentView addSubview:textField];
    self.textField = textField;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(6.5));
        make.height.mas_equalTo(AUTOSIZESCALEX(12));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.arrowImageView.mas_left).offset(AUTOSIZESCALEX(-15));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
//        make.width.mas_equalTo(AUTOSIZESCALEX(200));
        make.left.equalTo(self.typeLabel.mas_right).offset(AUTOSIZESCALEX(15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setType:(NSString *)type {
    _type = type;
    self.typeLabel.text = _type;
}

- (void)setContent:(NSString *)content {
    _content = content;
    self.textField.text = _content;
}

- (void)setCanEdit:(BOOL)canEdit {
    _canEdit = canEdit;
    self.textField.enabled = _canEdit;
}

#pragma mark - UITextFieldDelegate

- (void)textFieldDidEndEditing:(UITextField *)textField {
    if ([_delegate respondsToSelector:@selector(personalEditCell:textFieldDidEndEditing:)]) {
        [_delegate personalEditCell:self textFieldDidEndEditing:textField.text];
    }
}

@end
