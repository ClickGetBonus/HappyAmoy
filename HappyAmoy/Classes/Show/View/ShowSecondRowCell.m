//
//  ShowSecondRowCell.m
//  HappyAmoy
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShowSecondRowCell.h"
#import "MemberListView.h"

@interface ShowSecondRowCell()

/**    会员榜单    */
@property (strong, nonatomic) MemberListView *memberListView;

@end

@implementation ShowSecondRowCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupUI];
        self.backgroundColor = ViewControllerBackgroundColor;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    MemberListView *memberListView = [[MemberListView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH - AUTOSIZESCALEX(20), AUTOSIZESCALEX(40) * 12)];
    [self.contentView addSubview:memberListView];
    self.memberListView = memberListView;

    [self.memberListView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.contentView).offset(AUTOSIZESCALEX(10));
        make.right.equalTo(self.contentView).offset(AUTOSIZESCALEX(-10));
        make.bottom.equalTo(self.contentView).offset(0);
    }];

}

@end
