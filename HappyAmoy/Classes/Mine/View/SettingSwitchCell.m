//
//  SettingSwitchCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SettingSwitchCell.h"

@interface SettingSwitchCell()

/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    开关    */
@property (strong, nonatomic) UISwitch *openSwitch;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation SettingSwitchCell

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
    typeLabel.textColor = RGB(70, 70, 70);
    typeLabel.font = TextFont(14.0);
    typeLabel.text = @"推送设置";
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UISwitch *openSwitch = [[UISwitch alloc] init];
    openSwitch.on = [WYUserDefaultManager shareManager].receiveMessageNoticeSetting;
    openSwitch.onTintColor = RGB(39, 239, 61);
    [[openSwitch rac_signalForControlEvents:UIControlEventValueChanged] subscribeNext:^(id x) {
        [[WYUserDefaultManager shareManager] saveReceiveMessageNoticeSetting:![WYUserDefaultManager shareManager].receiveMessageNoticeSetting];
    }];
    [self.contentView addSubview:openSwitch];
    self.openSwitch = openSwitch;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.contentView addSubview:line];
    self.line = line;
    
    // 添加约束
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.typeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
    }];
    
    [self.openSwitch mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

@end
