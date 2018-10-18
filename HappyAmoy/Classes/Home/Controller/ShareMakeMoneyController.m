//
//  ShareMakeMoneyController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareMakeMoneyController.h"

@interface ShareMakeMoneyController ()

/**    背景图片    */
@property(nonatomic,strong) UIImageView *bgImageView;
/**    内容图片    */
@property(nonatomic,strong) UIImageView *contentImageView;

@end

@implementation ShareMakeMoneyController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"分享赚钱";
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    UIImageView *bgImageView = [[UIImageView alloc] init];
    bgImageView.image = ImageWithNamed(@"分享赚钱bg");
    [self.view addSubview:bgImageView];
    self.bgImageView = bgImageView;
    
    [self.bgImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.bottom.equalTo(self.view);
    }];
    
    UIImageView *contentImageView = [[UIImageView alloc] init];
    contentImageView.image = ImageWithNamed(@"内容");
    [self.view addSubview:contentImageView];
    self.contentImageView = contentImageView;
    
    [self.contentImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(165));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(375));
    }];
}


@end
