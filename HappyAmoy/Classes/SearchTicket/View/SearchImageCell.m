//
//  SearchImageCell.m
//  HappyAmoy
//
//  Created by lb on 2018/9/25.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "SearchImageCell.h"


@interface SearchImageCell()

@property (nonatomic, strong) NSString *imageTxt;
@property (nonatomic, assign) float rowHeight;

@property (nonatomic, strong) UIImageView *introImageView;


@end
@implementation SearchImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
        [self createImageView];
    }
    return self;
}

#pragma mark - Method
- (void)createImageView
{
    if (!_introImageView) {
        _introImageView = [[UIImageView alloc]init];
        
        [self addSubview:_introImageView];
    }
}

#pragma mark - SetData
- (void)setImageTxt:(NSString *)imageTxt
{
    _imageTxt = imageTxt;
    UIImage *image = [UIImage imageNamed:imageTxt];
    float height = self.width * image.size.height/image.size.width;
    self.introImageView.image = image;
    self.introImageView.frame = CGRectMake(0, 0, self.width, height);
    _rowHeight = self.introImageView.bottom_WY;
}

- (float)getHeight
{
    return _rowHeight;
}
@end
