//
//  FeedBackController.m
//  HappyAmoy
//
//  Created by apple on 2018/7/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "FeedBackController.h"

@interface FeedBackController () <UITextViewDelegate>

/**    容器    */
@property(nonatomic,strong) UIView *containerView;
/**    顶部    */
@property(nonatomic,strong) UIView *topView;
/**    中部    */
@property(nonatomic,strong) UIView *middleView;
/**    底部    */
@property(nonatomic,strong) UIView *bottomView;

/**    提示语    */
@property(nonatomic,strong) UILabel *tipsLabel;
/**    占位语    */
@property(nonatomic,strong) UILabel *placeholderLabel;

/**    建议    */
@property(nonatomic,strong) UITextView *suggestTextView;
/**    手机号码    */
@property(nonatomic,strong) UITextField *mobileTextField;

/**    分割线1    */
@property(nonatomic,strong) UIView *line1;
/**    分割线2    */
@property(nonatomic,strong) UIView *line2;

@end

@implementation FeedBackController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"意见反馈";
    self.view.backgroundColor = ColorWithHexString(@"#EBEBEB");
    [self setupNav];
    [self setupUI];
}

#pragma mark - Nav

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"提交" titleColor:ColorWithHexString(@"#3B3A3A") titleFont:TextFont(13) target:self action:@selector(didClickSubmitButton)];
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *containerView = [[UIView alloc] init];
    containerView.backgroundColor = RandomColor;
    [self.view addSubview:containerView];
    self.containerView = containerView;
    
    UIView *topView = [[UIView alloc] init];
    topView.backgroundColor = QHWhiteColor;
    [self.containerView addSubview:topView];
    self.topView = topView;

    UIView *middleView = [[UIView alloc] init];
    middleView.backgroundColor = QHWhiteColor;
    [self.containerView addSubview:middleView];
    self.middleView = middleView;

    UIView *bottomView = [[UIView alloc] init];
    bottomView.backgroundColor = QHWhiteColor;
    [self.containerView addSubview:bottomView];
    self.bottomView = bottomView;
    
    UILabel *tipsLabel = [[UILabel alloc] init];
    tipsLabel.numberOfLines = 0;
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"亲爱的用户，如果您对我们平台有更好的建议，\n请您留下宝贵意见，我们会尽快处理。"];
    attribute.yy_lineSpacing = AUTOSIZESCALEX(5);
    tipsLabel.attributedText = attribute;
    tipsLabel.font = TextFont(12);
    tipsLabel.textColor = ColorWithHexString(@"#615D5D");
    tipsLabel.textAlignment = NSTextAlignmentCenter;
    [self.topView addSubview:tipsLabel];
    self.tipsLabel = tipsLabel;
    
    UIView *line1 = [[UIView alloc] init];
    line1.backgroundColor = SeparatorLineColor;
    [self.containerView addSubview:line1];
    self.line1 = line1;

    UIView *line2 = [[UIView alloc] init];
    line2.backgroundColor = SeparatorLineColor;
    [self.containerView addSubview:line2];
    self.line2 = line2;

    UILabel *placeholderLabel = [[UILabel alloc] init];
    placeholderLabel.text = @"请填写意见描述（500字以内）";
    placeholderLabel.font = TextFont(12);
    placeholderLabel.textColor = ColorWithHexString(@"#999999");
    placeholderLabel.textAlignment = NSTextAlignmentCenter;
    [self.middleView addSubview:placeholderLabel];
    self.placeholderLabel = placeholderLabel;

    UITextView *suggestTextView = [[UITextView alloc] init];
    suggestTextView.delegate = self;
    suggestTextView.font = TextFont(12);
    suggestTextView.textColor = ColorWithHexString(@"#615D5D");
    suggestTextView.backgroundColor = QHClearColor;
    [self.middleView addSubview:suggestTextView];
    self.suggestTextView = suggestTextView;

    UITextField *mobileTextField = [[UITextField alloc] init];
    mobileTextField.placeholder = @"请填写联系人电话";
    mobileTextField.keyboardType = UIKeyboardTypeNumberPad;
    mobileTextField.font = TextFont(12);
    mobileTextField.textColor = ColorWithHexString(@"#615D5D");
    [self.bottomView addSubview:mobileTextField];
    self.mobileTextField = mobileTextField;
    
    [self addConstraints];
}

#pragma mark - Layout

- (void)addConstraints {
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(5) + kNavHeight);
        make.left.right.equalTo(self.view);
//        make.height.mas_equalTo(AUTOSIZESCALEX(AUTOSIZESCALEX(260)));
    }];

    [self.topView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(AUTOSIZESCALEX(0));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(AUTOSIZESCALEX(60));
    }];

    [self.middleView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.topView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(AUTOSIZESCALEX(150));
    }];

    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView.mas_bottom).offset(AUTOSIZESCALEX(0));
        make.left.right.bottom.equalTo(self.containerView);
        make.height.mas_equalTo(AUTOSIZESCALEX(50));
    }];

    [self.tipsLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.topView);
    }];
    
    [self.line1 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(AUTOSIZESCALEX(60));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(AUTOSIZESCALEX(0.5));
    }];

    [self.line2 mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.containerView).offset(AUTOSIZESCALEX(210));
        make.left.right.equalTo(self.containerView);
        make.height.mas_equalTo(AUTOSIZESCALEX(0.5));
    }];
    
    [self.placeholderLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.middleView).offset(AUTOSIZESCALEX(13.5));
        make.left.equalTo(self.middleView).offset(AUTOSIZESCALEX(16.5));
        make.height.mas_equalTo(AUTOSIZESCALEX(13));
    }];

    [self.suggestTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.middleView);
        make.width.mas_equalTo(SCREEN_WIDTH - AUTOSIZESCALEX(20));
        make.height.mas_equalTo(AUTOSIZESCALEX(140));
    }];

    [self.mobileTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.bottomView);
        make.width.mas_equalTo(SCREEN_WIDTH - AUTOSIZESCALEX(30));
    }];


}

#pragma mark - Button Action

// 提交
- (void)didClickSubmitButton {
    [self.view endEditing:YES];

    if ([NSString isEmpty:self.suggestTextView.text]) {
        [WYProgress showErrorWithStatus:@"意见建议不能为空!"];
        return;
    }
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    parameters[@"customerId"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"customerName"] = [LoginUserDefault userDefault].userItem.nickname;
    parameters[@"content"] = self.suggestTextView.text;
//    parameters[@"images"] = @"";
    parameters[@"mobile"] = [NSString excludeEmptyQuestion:self.mobileTextField.text];

    WeakSelf
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/system/feedback/add" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"反馈成功，感谢您的反馈!"];
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];

}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)textViewDidChange:(UITextView *)textView {
    
    self.placeholderLabel.hidden = textView.text.length > 0;
    
}



@end
