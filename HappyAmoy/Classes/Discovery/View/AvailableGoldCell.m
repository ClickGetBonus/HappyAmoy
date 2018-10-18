//
//  AvailableGoldCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "AvailableGoldCell.h"

@interface AvailableGoldCell ()

/**    可用金豆    */
@property(nonatomic,strong) UILabel *availableGoldLabel;

@end

@implementation AvailableGoldCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *availableGoldLabel = [[UILabel alloc] init];
    availableGoldLabel.textColor = ColorWithHexString(@"#333333");
    availableGoldLabel.font = TextFont(14);
    availableGoldLabel.text = @"可用麦粒：0";
    [self.contentView addSubview:availableGoldLabel];
    self.availableGoldLabel = availableGoldLabel;
    
    [self.availableGoldLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
    }];
}

#pragma mark - Setter

- (void)setMyScroe:(NSInteger)myScroe {
    _myScroe = myScroe;
    self.availableGoldLabel.text = [NSString stringWithFormat:@"可用麦粒：%zd",self.myScroe];
}


@end
