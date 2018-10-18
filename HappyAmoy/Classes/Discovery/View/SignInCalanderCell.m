//
//  SignInCalanderCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SignInCalanderCell.h"

@interface SignInCalanderCell()

/**    日期    */
@property(nonatomic,strong) UILabel *dateLabel;
/**    签到标识    */
@property(nonatomic,strong) UIImageView *signInIcon;

@end

@implementation SignInCalanderCell

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupUI];
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UILabel *dateLabel = [[UILabel alloc] init];
    dateLabel.text = @"01";
    dateLabel.textColor = ColorWithHexString(@"#666666");
    dateLabel.font = TextFont(12);
    [self.contentView addSubview:dateLabel];
    self.dateLabel = dateLabel;
    
    [self.dateLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
    }];
    
    UIImageView *signInIcon = [[UIImageView alloc] init];
    signInIcon.image = ImageWithNamed(@"矢量智能对象");
    [self.contentView addSubview:signInIcon];
    self.signInIcon = signInIcon;
    
    [self.signInIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(29), AUTOSIZESCALEX(27)));
    }];

}

#pragma mark - Setter

- (void)setDate:(NSString *)date {
    _date = date;
    self.dateLabel.text = _date;
}

- (void)setHaveSignIn:(BOOL)haveSignIn {
    _haveSignIn = haveSignIn;

    if (_haveSignIn) {
        self.signInIcon.hidden = NO;
        self.dateLabel.textColor = ColorWithHexString(@"#FB4F67");
    } else {
        self.signInIcon.hidden = YES;
        self.dateLabel.textColor = ColorWithHexString(@"#666666");
    }
}

@end
