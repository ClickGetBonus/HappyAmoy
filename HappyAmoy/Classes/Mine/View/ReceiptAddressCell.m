//
//  ReceiptAddressCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ReceiptAddressCell.h"
#import "AddressItem.h"

@interface ReceiptAddressCell()

/**    姓名    */
@property(nonatomic,strong) UILabel *nameLabel;
/**    地址    */
@property(nonatomic,strong) UILabel *addressLabel;
/**    竖线    */
@property(nonatomic,strong) UIView *line;
/**    编辑图标    */
@property(nonatomic,strong) UIImageView *editIcon;

@end

@implementation ReceiptAddressCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = QHWhiteColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *nameLabel = [[UILabel alloc] init];
    nameLabel.text = @"兔崽子   13985626633";
    nameLabel.textColor = ColorWithHexString(@"#666666");
    nameLabel.font = TextFont(14);
    [self.contentView addSubview:nameLabel];
    self.nameLabel = nameLabel;
    
    UILabel *addressLabel = [[UILabel alloc] init];
    addressLabel.text = @"天河区猎德大道31号（中海璟晖华庭二楼）";
    addressLabel.textColor = ColorWithHexString(@"#666666");
    addressLabel.font = TextFont(14);
    [self.contentView addSubview:addressLabel];
    self.addressLabel = addressLabel;

    UIView *line = [[UIView alloc] init];
    line.backgroundColor = ColorWithHexString(@"#CCCCCC");
    [self.contentView addSubview:line];
    self.line = line;
    
    UIImageView *editIcon = [[UIImageView alloc] init];
    editIcon.image = ImageWithNamed(@"写信");
    [self.contentView addSubview:editIcon];
    self.editIcon = editIcon;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(15));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-80));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(15));
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.nameLabel).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-80));
        make.bottom.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-57));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(1), AUTOSIZESCALEX(30)));
    }];
    
    [self.editIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView).offset(AUTOSIZESCALEX(0));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-15));
        make.size.mas_equalTo(CGSizeMake(AUTOSIZESCALEX(22), AUTOSIZESCALEX(22)));
    }];
}

#pragma mark - Setter

- (void)setItem:(AddressItem *)item {
    _item = item;
    if (_item) {
        self.nameLabel.text = [NSString stringWithFormat:@"%@    %@",_item.deliveryName,_item.deliveryMobile];
        self.addressLabel.text = [NSString stringWithFormat:@"%@%@%@%@",_item.provinceName,_item.cityName,_item.areaName,_item.address];;
    }
}

@end
