//
//  ExchangeAddressCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/13.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ExchangeAddressCell.h"
#import "AddressItem.h"

@interface ExchangeAddressCell ()

/**    提示    */
@property(nonatomic,strong) UILabel *tipsLabel;
/**    姓名    */
@property(nonatomic,strong) UILabel *nameLabel;
/**    手机号码    */
@property(nonatomic,strong) UILabel *phoneNumLabel;
/**    默认    */
@property(nonatomic,strong) UILabel *defaultLabel;
/**    地址    */
@property(nonatomic,strong) UILabel *addressLabel;
/**    箭头    */
@property(nonatomic,strong) UIImageView *arrowImageView;

@end

@implementation ExchangeAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.textColor = ColorWithHexString(@"#333333");
    nameLabel.font = TextFont(14);
    nameLabel.text = @"李小龙";
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *phoneNumLabel = [[UILabel alloc] init];
    phoneNumLabel.textColor = ColorWithHexString(@"#333333");
    phoneNumLabel.font = TextFont(14);
    phoneNumLabel.text = @"13822228888";
    [self.contentView addSubview:phoneNumLabel];
    self.phoneNumLabel = phoneNumLabel;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.textColor = ColorWithHexString(@"#333333");
    addressLabel.font = TextFont(14);
    addressLabel.text = @"            广东省广州市白云区岗贝路1号A座1211房白云区大道1号A座1211房";
    addressLabel.numberOfLines = 0;
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;
    
    UILabel *defaultLabel = [[UILabel alloc] init];
    defaultLabel.textColor = ColorWithHexString(@"#4B749D");
    defaultLabel.font = TextFont(14);
    defaultLabel.text = @"【默认】";
    [self.contentView addSubview:defaultLabel];
    self.defaultLabel = defaultLabel;

    UIImageView *arrowImageView = [[UIImageView alloc] init];
    arrowImageView.image = ImageWithNamed(@"next");
    [self.contentView addSubview:arrowImageView];
    self.arrowImageView = arrowImageView;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.textColor = ColorWithHexString(@"#333333");
    tipsLabel.font = TextFont(14);
    tipsLabel.text = @"请选择收货地址";
    [self.contentView addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;

    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];
    
    [self.phoneNumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-40));
        make.height.equalTo(self.nameLabel);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.phoneNumLabel).offset(AUTOSIZESCALEX(0));
    }];
    
    [self.defaultLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.nameLabel.mas_bottom).offset(AUTOSIZESCALEX(12));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(5));
        make.right.equalTo(self.phoneNumLabel).offset(AUTOSIZESCALEX(0));
    }];

    [self.arrowImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(8));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
    }];

}

#pragma mark - Setter
- (void)setItem:(AddressItem *)item {
    _item = item;
    if (_item) {
        self.tipsLabel.hidden = YES;
        self.nameLabel.hidden = self.phoneNumLabel.hidden = self.addressLabel.hidden = self.defaultLabel.hidden = NO;
        
        self.nameLabel.text = _item.deliveryName;
        self.phoneNumLabel.text = _item.deliveryMobile;
        self.addressLabel.text = [NSString stringWithFormat:@"            %@%@%@%@",_item.provinceName,_item.cityName,_item.areaName,_item.address];
    } else {
        self.tipsLabel.hidden = NO;
        self.nameLabel.hidden = self.phoneNumLabel.hidden = self.addressLabel.hidden = self.defaultLabel.hidden = YES;
    }
}

@end
