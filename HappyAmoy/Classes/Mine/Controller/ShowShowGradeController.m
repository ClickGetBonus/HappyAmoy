//
//  ShowShowGradeController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShowShowGradeController.h"
#import "ShowGradeEditView.h"

@interface ShowShowGradeController ()

/**    编辑    */
@property (strong, nonatomic) ShowGradeEditView *editView;

@end

@implementation ShowShowGradeController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.title = @"晒晒成绩";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    [self setupNav];
    [self setupUI];
}

#pragma mark - Nav

- (void)setupNav {
    
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"发布" titleColor:ColorWithHexString(@"#FB4F67") titleFont:TextFont(14) target:self action:@selector(didClickPublish)];
}

#pragma mark - UI

- (void)setupUI {
    
    ShowGradeEditView *editView = [[ShowGradeEditView alloc] init];
    [self.view addSubview:editView];
    self.editView = editView;
    
    [self.editView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(15) + kNavHeight);
        make.left.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(280));
    }];
}

#pragma mark - Button Action

- (void)didClickPublish {
    
    [self.view endEditing:YES];
    
    if ([NSString isEmpty:self.editView.content]) {
        [WYProgress showErrorWithStatus:@"文字内容不能为空!"];
        return;
    }
    
    if (self.editView.imageArray.count == 0) {
        [WYProgress showErrorWithStatus:@"请选择一张图片!"];
        return;
    }
    
    WeakSelf

    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 1-头像 2评论
    parameters[@"module"] = @"1";
    
    [[NetworkSingleton sharedManager] uploadImageWithUrl:@"" parameters:parameters image:self.editView.imageArray[0] successBlock:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == RequestSuccess) {
            
            NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
            
            parameters[@"customerId"] = [LoginUserDefault userDefault].userItem.userId;
            parameters[@"image"] = response[@"id"];
            parameters[@"content"] = self.editView.content;
            
            [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/harvest" parameters:parameters successBlock:^(id response) {
                if ([response[@"code"] integerValue] == RequestSuccess) {
                    
                    [WYProgress showSuccessWithStatus:@"晒晒成绩成功!"];
                    
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [weakSelf.navigationController popViewControllerAnimated:YES];
                    });
                } else {
                    [WYProgress showErrorWithStatus:response[@"msg"]];
                }
            } failureBlock:^(NSString *error) {
                
            }];
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"] dismissWithDelay:1.0];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

@end
