//
//  ShareTextController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareTextController.h"
#import "CommodityDetailItem.h"

@interface ShareTextController ()

/**    编辑框    */
@property (strong, nonatomic) UITextView *textView;

@end

@implementation ShareTextController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
}

#pragma mark - UI

- (void)setupUI {
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"编辑分享文案";
    tipLabel.textColor = ColorWithHexString(@"#333333");
    tipLabel.font = TextFont(12);
    [self.view addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
    }];
    
    UITextView *textView = [[UITextView alloc] init];
    textView.layer.borderColor = ColorWithHexString(@"CCCCCC").CGColor;
    textView.layer.borderWidth = AUTOSIZESCALEX(1);
    textView.layer.cornerRadius = AUTOSIZESCALEX(5);
    textView.layer.masksToBounds = YES;
    textView.textColor = ColorWithHexString(@"#333333");
    NSString *text = [NSString stringWithFormat:@"  %@\n\n【原价】 %.2f元\n\n【券后价】%.2f元                         \n\n\n\n  复制这条信息，%@，打开【手机淘宝】即可查看",self.item.name,self.item.price,self.item.discountPrice,[NSString excludeEmptyQuestion:self.item.taoToken]];
//    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:@"  男士带翻领紧身短袖衬衫【包邮】\n\n【原价】 88.00元\n\n【券后价】88.00元\n\n\n\n  复制这条信息，￥XFvs0F0P1vQ￥，打开【手机淘宝】即可\n  查看"];
    NSMutableAttributedString *attribute = [[NSMutableAttributedString alloc] initWithString:text];
    [attribute addAttribute:NSForegroundColorAttributeName value:QHMainColor range:NSMakeRange(attribute.length - 40, 40)];
    textView.attributedText = attribute;
    textView.font = TextFont(12);
    [self.view addSubview:textView];
    self.textView = textView;
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(tipLabel.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(225));
    }];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.layer.cornerRadius = AUTOSIZESCALEX(3);
    copyButton.layer.masksToBounds = YES;
    copyButton.titleLabel.font = TextFont(12);
    [copyButton setTitle:@"复制分享文案" forState:UIControlStateNormal];
    [copyButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    [copyButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(90), AUTOSIZESCALEX(23)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.textView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.textView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(90));
        make.height.mas_equalTo(AUTOSIZESCALEX(23));
    }];
    
    WeakSelf
    [[copyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        
        UIPasteboard* pasteboard = [UIPasteboard generalPasteboard];
        pasteboard.string = weakSelf.textView.text;
        [WYHud showMessage:@"已复制到剪贴板!"];
        WYLog(@"复制的内容 = %@",weakSelf.textView.text);

    }];
}

#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
