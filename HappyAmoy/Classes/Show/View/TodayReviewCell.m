//
//  TodayReviewCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "TodayReviewCell.h"
#import "TodayReviewView.h"

@interface TodayReviewCell()

/**    今日点评    */
@property (strong, nonatomic) TodayReviewView *todayReview;


@end

@implementation TodayReviewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    TodayReviewView *todayReview = [[TodayReviewView alloc] init];
    [self.contentView addSubview:todayReview];
    self.todayReview = todayReview;

    [self.todayReview mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(0);
        make.left.equalTo(self.contentView).offset(0);
        make.right.equalTo(self.contentView).offset(0);
        make.bottom.equalTo(self.contentView).offset(0);
//        make.height.mas_equalTo(AUTOSIZESCALEX(295));
    }];

}

@end
