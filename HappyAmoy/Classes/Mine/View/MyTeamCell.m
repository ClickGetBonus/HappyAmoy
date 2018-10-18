//
//  MyTeamCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/30.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MyTeamCell.h"

@interface MyTeamCell()

/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    直接    */
@property (strong, nonatomic) UILabel *directLabel;
/**    间接    */
@property (strong, nonatomic) UILabel *indirectLabel;
/**    下一步图标    */
@property (strong, nonatomic) UIImageView *nextIconImageView;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation MyTeamCell

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
    typeLabel.textColor = ColorWithHexString(@"#898589");
    typeLabel.font = TextFont(14.0);
    typeLabel.text = @"VIP会员";
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UILabel *directLabel = [[UILabel alloc] init];
    directLabel.textColor = ColorWithHexString(@"C1BCC1");
    directLabel.font = TextFont(12.0);
    directLabel.text = @"直属：0";
    [self.contentView addSubview:directLabel];
    self.directLabel = directLabel;
    
    UILabel *indirectLabel = [[UILabel alloc] init];
    indirectLabel.font = TextFont(12.0);
    indirectLabel.textColor = ColorWithHexString(@"C1BCC1");
    indirectLabel.text = @"间属：0";
    [self.contentView addSubview:indirectLabel];
    self.indirectLabel = indirectLabel;
    
    UIImageView *nextIconImageView = [[UIImageView alloc] initWithImage:ImageWithNamed(@"next")];
    [self.contentView addSubview:nextIconImageView];
    self.nextIconImageView = nextIconImageView;
    
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
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(21));
    }];
    
    [self.directLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-12));
        make.left.equalTo(self.typeLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.indirectLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.directLabel).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(143));
    }];
    
    [self.nextIconImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-22));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Layout

- (void)setType:(NSString *)type {
    _type = type;
    self.typeLabel.text = _type;
}

- (void)setIndex:(NSInteger)index {
    _index = index;
    
    self.typeLabel.text = _index == 0 ? @"VIP会员" : @"普通会员";
}

- (void)setDataDict:(NSDictionary *)dataDict {
    _dataDict = dataDict;
    if (_dataDict) {
        if (_index == 0) { // VIP会员
            self.directLabel.text = [NSString stringWithFormat:@"直属：%@",_dataDict[@"directViped"]];
            self.indirectLabel.text = [NSString stringWithFormat:@"间属：%@",_dataDict[@"indirectViped"]];
        } else { // 普通会员
            self.directLabel.text = [NSString stringWithFormat:@"直属：%@",_dataDict[@"directUnviped"]];
            self.indirectLabel.text = [NSString stringWithFormat:@"间属：%@",_dataDict[@"indirectUnviped"]];
        }
    }
}

@end
