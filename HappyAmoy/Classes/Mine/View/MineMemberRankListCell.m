//
//  MineMemberRankListCell.m
//  HappyAmoy
//
//  Created by apple on 2018/7/10.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "MineMemberRankListCell.h"

@interface MineMemberRankListCell()

/**    背景图片    */
@property(nonatomic,strong) UIImageView *bgImageView;

@end

@implementation MineMemberRankListCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    UIImageView *bgImageView = [[UIImageView alloc] init];
    UIImage *image = ImageWithNamed(@"会员排行榜");
    bgImageView.image = image;
    [self.contentView addSubview:bgImageView];
    self.bgImageView = bgImageView;
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.edges.equalTo(self.contentView);
        make.centerX.centerX.equalTo(self.contentView);
        NSNumber *sizeWidth = @AUTOSIZESCALEX(image.size.width);
        make.width.equalTo(sizeWidth);
        
        CGFloat sizeHeight = image.size.height/image.size.width*sizeWidth.floatValue;
        make.height.equalTo(@(sizeHeight));
    }];
}

@end
