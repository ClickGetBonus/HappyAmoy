//
//  CheckProtocolController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/6.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "CheckProtocolController.h"

@interface CheckProtocolController () <UIWebViewDelegate>

/**    webVIew    */
@property (strong, nonatomic) UIWebView *webView;

@end

@implementation CheckProtocolController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [WYProgress show];

    [self setupUI];
    
    if (_isPutForward) {
        [self fetchNotice];
    }
}

#pragma mark - Data

- (void)fetchNotice {
    
    WeakSelf
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    [[NetworkSingleton sharedManager] getRequestWithUrl:@"/system/fetchNotice" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [weakSelf.webView loadHTMLString:response[@"data"] baseURL:nil];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    } shouldDismissHud:NO];
    
}

#pragma mark - UI

- (void)setupUI {
    
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(0, kNavHeight, SCREEN_WIDTH, SeparatorLineHeight)];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, kNavHeight + SeparatorLineHeight, SCREEN_WIDTH, SCREEN_HEIGHT - kNavHeight - SeparatorLineHeight)];
    ///自动适应大小
    webView.scalesPageToFit = YES;
    ///关闭下拉刷新效果
    webView.scrollView.bounces = NO;
    webView.delegate = self;
    if (!_isPutForward) { // 用户注册协议
        [self loadDocument:@"好麦用户协议" inView:webView];
    }
    [self.view addSubview:webView];
    self.webView = webView;
}


-(void)loadDocument:(NSString *)documentName inView:(UIWebView *)webView {
    NSString *path = [[NSBundle mainBundle] pathForResource:documentName ofType:@"docx"];
    NSURL *url = [NSURL fileURLWithPath:path];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [WYProgress dismiss];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    [WYProgress dismiss];
}






//#pragma mark - UI
//
//- (void)setupUI {
//    UITextView *protocolLabel = [[UITextView alloc] init];
//    protocolLabel.text = @"尊敬的客户，欢迎您注册成为驰客用户。在注册前请您仔细阅读如下服务条款：\n本服务协议双方为驰客与驰客客户，本服务协议具有合同效力。您确认本服务协议后，本服务协议即在您和本平台之间产生法律效力。请您务必在注册之前认真阅读全部服务协议内容，如有任何疑问，可向本平台咨询。 无论您事实上是否在注册之前认真阅读了本服务协议，只要您点击协议正本下方的\"注册\"按钮并按照本网站注册程序成功注册为用户，您的行为仍然表示您同意并签署了本服务协议。\n协议细则\n1、驰客服务条款的确认和接纳\n驰客各项服务的所有权和运作权归本平台拥有。\n2、用户必须：\n(1)自行配备上网的所需设备， 包括个人电脑、调制解调器或其他必备上网装置。\n(2)自行负担个人上网所支付的与此服务有关的电话费用、 网络费用。\n3、用户在驰客交易平台上不得发布下列违法信息：\n(1)反对宪法所确定的基本原则的；\n(2)危害国家安全，泄露国家秘密，颠覆国家政权，破坏国家统一的；\n(3)损害国家荣誉和利益的；\n(4)煽动民族仇恨、民族歧视，破坏民族团结的；\n(5)破坏国家宗教政策，宣扬邪教和封建迷信的；\n(6)散布谣言，扰乱社会秩序，破坏社会稳定的；\n(7)散布淫秽、色情、赌博、暴力、凶杀、恐怖或者教唆犯罪的；\n(8)侮辱或者诽谤他人，侵害他人合法权益的；\n(9)含有法律、行政法规禁止的其他内容的。\n4、个人资料\n本平台对用户的电子邮件、手机号等隐私资料进行保护，承诺不会在未获得用户许可的情况下擅自将用户的个人资料信息出租或出售给任何第三方，但以下情况除外：\n(1)用户同意让第三方共享资料。\n(2)用户同意公开其个人资料，享受为其提供的产品和服务。\n(3)本平台需要听从法庭传票，法律命令或遵循法律程序。\n5、电子邮件\n用户在注册时应当选择稳定性及安全性相对较好的电子邮箱，并且同意接受并阅读本平台发往用户的各类电子邮件。如用户未及时从自己的电子邮箱接受电子邮件或因用户电子邮箱或用户电子邮件接收及阅读程序本身的问题使电子邮件无法正常接收或阅读的，只要本平台成功发送了电子邮件，应当视为用户已经接收到相关的电子邮件。电子邮件在发信服务器上所记录的发出时间视为送达时间。\n6、服务条款的修改\n本平台有权在必要时修改服务条款，本平台服务条款一旦发生变动，将会在重要页面上提示修改内容。如果不同意所改动的内容，用户可以主动取消获得的本平台信息服务。如果用户继续享用本平台信息服务，则视为接受服务条款的变动。本平台保留随时修改或中断服务而不需通知用户的权利。本平台行使修改或中断服务的权利，不需对用户或第三方负责。\n7、用户的帐号、密码和安全性\n你一旦注册成功成为用户，你将得到一个密码和帐号。如果你不保管好自己的帐号和密码安全，将负全部责任。另外，每个用户都要对其帐户中的所有活动和事件负全责。你可随时根据指示改变你的密码，也可以结束旧的帐户重开一个新帐户。用户同意若发现任何非法使用用户帐号或安全漏洞的情况，请立即通知本平台。\n8、拒绝提供担保\n用户明确同意信息服务的使用由用户个人承担风险。本平台不担保服务不会受中断，对服务的及时性，安全性，出错发生都不作担保，但会在能力范围内，避免出错。\n9、有限责任\n本平台对任何直接、间接、偶然、特殊及继起的损害不负责任，这些损害来自：不正当使用本平台服务，或用户传送的信息不符合规定等。这些行为都有可能导致本平台形象受损，所以本平台事先提出这种损害的可能性，同时会尽量避免这种损害的发生。\n10、信息的储存及限制\n本平台不对用户所发布信息的删除或储存失败负责。本平台有判定用户的行为是否符合本站服务条款的要求和精神的保留权利，如果用户违背了服务条款的规定，本平台有中断对其提供网络服务的权利。\n11、用户管理\n用户必须遵循：\n(1) 使用信息服务不作非法用途。\n(2) 不干扰或混乱网络服务。\n(3) 遵守所有使用服务的网络协议、规定、程序和惯例。用户的行为准则是以因特网法规，政策、程序和惯例为根据的。\n12、保障\n用户同意保障和维护本平台全体成员的利益，负责支付由用户使用超出服务范围引起的律师费用，违反服务条款的损害补偿费用，其它人使用用户的电脑、帐号和其它知识产权的追索费。\n13、结束服务\n用户或本平台可随时根据实际情况中断一项或多项服务。本平台不需对任何个人或第三方负责而随时中断服务。用户若反对任何服务条款的建议或对后来的条款修改有异议，或对本平台服务不满，用户可以行使如下权利：\n(1) 不再使用本平台信息服务。\n(2) 通知本平台停止对该用户的服务。\n结束用户服务后，用户使用本平台服务的权利马上中止。从那时起，用户没有权利，本平台也没有义务传送任何未处理的信息或未完成的服务给用户或第三方。n14、通告\n所有发给用户的通告都可通过重要页面的公告或电子邮件或常规的信件传送。服务条款的修改、服务变更、或其它重要事件的通告都会以此形式进行。\n15、信息内容的所有权\n本平台定义的信息内容包括：文字、软件、声音、相片、录象、图表；在广告中全部内容；本平台为用户提供的其它信息。所有这些内容受版权、商标、标签和其它财产所有权法律的保护。所以，用户只能在本平台和广告商授权下才能使用这些内容，而不能擅自复制、再造这些内容、或创造与内容有关的派生产品。\n16、法律\n本平台信息服务条款要与中华人民共和国的法律解释一致。用户和本平台一致同意服从本平台所在地有管辖权的法院管辖。";
//    protocolLabel.font = TextFont(16.0);
//    protocolLabel.textColor = RGB(60, 60, 60);
//    protocolLabel.backgroundColor = ViewControllerBackgroundColor;
//    protocolLabel.editable = NO;
//
//    [self.view addSubview:protocolLabel];
//
//    [protocolLabel mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.top.equalTo(self.view).offset(kNavHeight + AUTOSIZESCALEX(5));
//        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(10));
//        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//        make.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
//
//    }];
//}


@end
