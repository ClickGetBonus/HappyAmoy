//
//  PushMessageDetailController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/14.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PushMessageDetailController.h"

@interface PushMessageDetailController ()

@end

@implementation PushMessageDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"消息中心";
    
    [self setupUI];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
}

#pragma mark - UI

- (void)setupUI {
    
    UITextView *messageTextView = [[UITextView alloc] init];
    
    messageTextView.text = [[[[LoginUserDefault userDefault].pushDict objectForKey:UIApplicationLaunchOptionsRemoteNotificationKey] objectForKey:@"aps"] objectForKey:@"alert"];
    
    messageTextView.font = TextFont(16.0);
    messageTextView.textColor = RGB(60, 60, 60);
    messageTextView.backgroundColor = ViewControllerBackgroundColor;
    messageTextView.editable = NO;
    
    [self.view addSubview:messageTextView];
    
    [messageTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        
    }];
}

- (void)viewDidDisappear:(BOOL)animated {
    [super viewDidDisappear:animated];
    
    [LoginUserDefault userDefault].pushDict = nil;
}

@end
