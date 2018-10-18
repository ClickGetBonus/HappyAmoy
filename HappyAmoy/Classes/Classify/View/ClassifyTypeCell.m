//
//  ClassifyTypeCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ClassifyTypeCell.h"
#import "ClassifyItem.h"

@interface ClassifyTypeCell ()

/**    分类    */
@property(nonatomic,strong) UIButton *classifyButton;

@end

@implementation ClassifyTypeCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UIButton *classifyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    classifyButton.userInteractionEnabled = NO;
    [classifyButton setTitle:@"男装" forState:UIControlStateNormal];
    classifyButton.layer.cornerRadius = AUTOSIZESCALEX(12.5);
    classifyButton.layer.masksToBounds = YES;
    [classifyButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
    classifyButton.titleLabel.font = TextFont(12);
    [self.contentView addSubview:classifyButton];
    self.classifyButton = classifyButton;
    
    [self.classifyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.contentView);
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(25)));
    }];
}

#pragma mark - Setter

- (void)setItem:(ClassifyItem *)item {
    _item = item;
    if (_item) {
        [self.classifyButton setTitle:_item.name forState:UIControlStateNormal];
    }
}

- (void)setHaveSelected:(BOOL)haveSelected {
    
    _haveSelected = haveSelected;
    
    if (_haveSelected) {
        [self.classifyButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
        [self.classifyButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    } else {
        [self.classifyButton setTitleColor:ColorWithHexString(@"#000000") forState:UIControlStateNormal];
        [self.classifyButton setBackgroundImage:[[UIImage alloc] init] forState:UIControlStateNormal];
//        [self.classifyButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(25)) colorArray:@[(id)ColorWithHexString(@"#FFFFFF"),(id)(id)ColorWithHexString(@"#FFFFFF")] percentageArray:@[@(0.18),@(1)] gradientType:GradientFromTopToBottom];
    }
}

@end
