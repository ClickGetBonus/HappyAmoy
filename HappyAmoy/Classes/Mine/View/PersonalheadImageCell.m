//
//  PersonalheadImageCell.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PersonalheadImageCell.h"

@interface PersonalheadImageCell()

/**    类型    */
@property (strong, nonatomic) UILabel *typeLabel;
/**    头像    */
@property (strong, nonatomic) UIImageView *headImageView;
/**    分割线    */
@property (strong, nonatomic) UIView *line;

@end

@implementation PersonalheadImageCell

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
    typeLabel.text = @"头像";
    typeLabel.textColor = RGB(90, 90, 90);
    typeLabel.font = TextFont(15);
    [self.contentView addSubview:typeLabel];
    self.typeLabel = typeLabel;
    
    UIImageView *headImageView = [[UIImageView alloc] init];
    headImageView.image = PlaceHolderImage;
    headImageView.layer.cornerRadius = AUTOSIZESCALEX(22.5);
    headImageView.layer.masksToBounds = YES;
    [self.contentView addSubview:headImageView];
    self.headImageView = headImageView;
    
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
    
    [self.headImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-20));
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(45));
        make.height.equalTo(self.headImageView.mas_width);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Setter

- (void)setHeadImage:(UIImage *)headImage {
    _headImage = headImage;
    
    self.headImageView.image = _headImage ? _headImage : PlaceHolderImage;
}

- (void)setHeadPicUrl:(NSString *)headPicUrl {
    _headPicUrl = headPicUrl;
    [self.headImageView wy_setImageWithUrlString:_headPicUrl placeholderImage:PlaceHolderImage scaleAspectFit:YES imageViewSize:CGSizeMake(AUTOSIZESCALEX(45), AUTOSIZESCALEX(45))];
}

@end
