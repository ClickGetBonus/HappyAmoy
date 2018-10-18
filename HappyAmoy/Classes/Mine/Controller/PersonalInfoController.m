//
//  PersonalInfoController.m
//  HappyAmoy
//
//  Created by apple on 2018/4/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PersonalInfoController.h"
#import "MineNormalCell.h"
#import "PersonalheadImageCell.h"
#import "PersonalEditCell.h"
#import <AVFoundation/AVFoundation.h>
#import "ReceiptAddressController.h"
#import "WebViewH5Controller.h"
@interface PersonalInfoController () <UITableViewDelegate,UITableViewDataSource,PersonalEditCellDelegate,UINavigationControllerDelegate,UIImagePickerControllerDelegate>

/**    tableView    */
@property (strong, nonatomic) UITableView *tableView;
/**    数据源    */
@property (strong, nonatomic) NSArray *titleArray;
/**    头像    */
@property (strong, nonatomic) UIImage *headImage;
/**    昵称    */
@property (copy, nonatomic) NSString *nickName;
/**    性别    */
@property (copy, nonatomic) NSString *sex;
/**    头像附件id    */
@property (copy, nonatomic) NSString *headpic;

@end

static NSString *const headImageCellId = @"headImageCellId";
static NSString *const editCellId = @"editCellId";

@implementation PersonalInfoController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    NSDictionary *attributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                [UIColor whiteColor],
                                NSForegroundColorAttributeName, nil];
    [self.navigationController.navigationBar setTitleTextAttributes:attributes];
    
    self.view.backgroundColor = ViewControllerBackgroundColor;
    self.titleArray = @[@"头像",@"昵称",@"性别",@"收货地址"];
    [self initData];
    [self setupNav];
    [self setupUI];
}

#pragma mark - Nav

- (void)setupNav {
    self.navigationItem.rightBarButtonItem = [UIBarButtonItem barButtonItemWithTitle:@"保存" titleColor:QHBlackColor titleFont:TextFont(14) target:self action:@selector(didClickSave)];
}

#pragma mark - UI

// 初始化数据
- (void)initData {
    self.nickName = [LoginUserDefault userDefault].userItem.nickname;
    if ([LoginUserDefault userDefault].userItem.gender == 1) {
        self.sex = @"男";
    } else if ([LoginUserDefault userDefault].userItem.gender == 2) {
        self.sex = @"女";
    } else {
        self.sex = @"保密";
    }
}

- (void)setupUI {
    
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.backgroundColor = self.view.backgroundColor;
    tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [tableView registerClass:[PersonalheadImageCell class] forCellReuseIdentifier:headImageCellId];
    [tableView registerClass:[PersonalEditCell class] forCellReuseIdentifier:editCellId];
    [self.view addSubview:tableView];
    self.tableView = tableView;
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(5) + kNavHeight);
        make.left.right.bottom.equalTo(self.view).offset(AUTOSIZESCALEX(0));
    }];
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = SeparatorLineColor;
    [self.view addSubview:line];

    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.top.equalTo(self.view).offset(kNavHeight);
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(SeparatorLineHeight);
    }];
}

#pragma mark - Button Action

- (void)didClickSave {
    [self.view endEditing:YES];
    
    [WYProgress show];
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    
    parameters[@"id"] = [LoginUserDefault userDefault].userItem.userId;
    parameters[@"headpic"] = self.headpic;
    parameters[@"nickname"] = self.nickName;
    // 性别 0-保密 1-男 2-女
    parameters[@"gender"] = [self.sex isEqualToString:@"男"] ? @"1" : @"2";
//    parameters[@"birthday"] = @"";

    WeakSelf
    
    [[NetworkSingleton sharedManager] postRequestWithUrl:@"/personal/edit" parameters:parameters successBlock:^(id response) {
        if ([response[@"code"] integerValue] == RequestSuccess) {
            [WYProgress showSuccessWithStatus:@"修改资料成功!"];
            UserItem *item = [UserItem mj_objectWithKeyValues:response[@"data"]];
            [LoginUserDefault userDefault].userItem.nickname = item.nickname;
            [LoginUserDefault userDefault].userItem.gender = item.gender;
            [LoginUserDefault userDefault].userItem.headpicUrl = item.headpicUrl;
            [LoginUserDefault userDefault].userItem.headpic = item.headpic;
            [LoginUserDefault userDefault].dataHaveChanged = ![LoginUserDefault userDefault].dataHaveChanged;

            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.75 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
            });
        } else {
            [WYProgress showErrorWithStatus:response[@"msg"]];
        }
    } failureBlock:^(NSString *error) {
        
    }];
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.titleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return AUTOSIZESCALEX(75);
    }
    return AUTOSIZESCALEX(50);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (indexPath.row == 0) {
        PersonalheadImageCell *cell = [tableView dequeueReusableCellWithIdentifier:headImageCellId];
        if (self.headImage) {
            cell.headImage = [UIImage scaleAcceptFitWithImage:self.headImage imageViewSize:CGSizeMake(AUTOSIZESCALEX(45), AUTOSIZESCALEX(45))];
        } else {
            cell.headPicUrl = [LoginUserDefault userDefault].userItem.headpicUrl;
        }
        return cell;
    }
    
    PersonalEditCell *cell = [tableView dequeueReusableCellWithIdentifier:editCellId];
    cell.delegate = self;
    cell.type = self.titleArray[indexPath.row];
    cell.canEdit = indexPath.row == 1;
    if (indexPath.row == 1) {
        cell.content = self.nickName;
    } else if (indexPath.row == 2) {
        cell.content = self.sex;
    } else if (indexPath.row == 3) {
        cell.content = @"";
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.view endEditing:YES];
    
    WeakSelf
    if (indexPath.row == 0) { // 选择头像
        [WYUtils showActionSheetWithTitle:nil message:nil firstActionTitle:@"直接拍照上传" firstAction:^{
            [weakSelf takePhotos];
        } secondActionTitle:@"从手机相片选择" secondAction:^{
            [weakSelf selectImage];
        }];
    } else if (indexPath.row == 1) { // 昵称
        
    } else if (indexPath.row == 2) { // 性别
        [WYUtils showActionSheetWithTitle:nil message:nil firstActionTitle:@"男" firstAction:^{
            weakSelf.sex = @"男";
            [weakSelf.tableView reloadData];
        } secondActionTitle:@"女" secondAction:^{
            weakSelf.sex = @"女";
            [weakSelf.tableView reloadData];
        }];
    } else if (indexPath.row == 3) { // 收货地址
        NSString *userid = [LoginUserDefault userDefault].userItem.userId;
    
        NSString *url = [NSString stringWithFormat:@"http://haomaimall.lucius.cn/center/address?uid=%@",userid];
//        ReceiptAddressController *addressVc = [[ReceiptAddressController alloc] init];
//        [self.navigationController pushViewController:addressVc animated:YES];
        WebViewH5Controller *webVc = [[WebViewH5Controller alloc] init];
        webVc.urlString = url;
        //    webVc.title = @"我的钱包";
        [self.navigationController pushViewController:webVc animated:YES];
    }
}

#pragma mark - Private method

// 直接拍照上传
- (void)takePhotos {
    
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc]init];
    imagePicker.delegate = self;
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:imagePicker animated:YES completion:nil];

    
//    WeakSelf
//    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeAudio];
//    if (authStatus == AVAuthorizationStatusRestricted || authStatus == AVAuthorizationStatusDenied) {
//        // 用户拒绝授权访问相机
//        UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//        [alert show];
//        return;
//    }
//    WYCameraController *cameraVc = [WYCameraController defaultCamera];
//    // 相机类型
//    cameraVc.cameraType = PhotoCamera;
//    // 拍照的回调
//    cameraVc.didFinishTakePhotosHandle = ^(UIImage *image, NSError *error) {
//        weakSelf.headImage = image;
//        [weakSelf.tableView reloadData];
//        [weakSelf uploadImage:image];
//    };
//    [self presentViewController:cameraVc animated:YES completion:nil];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    
    self.headImage = image;
    [self.tableView reloadData];
    [self uploadImage:image];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}

// 从手机相册选择图片
- (void)selectImage {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    // 禁止选择视频
    imagePickerVc.allowPickingVideo = NO;
    
    WeakSelf
    // 你可以通过block或者代理，来得到用户选择的照片.
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        weakSelf.headImage = photos[0];
        [weakSelf.tableView reloadData];
        [weakSelf uploadImage:photos[0]];
    }];
    
    [[WYUtils rootViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}

// 上传图片
- (void)uploadImage:(UIImage *)image {
    
    NSMutableDictionary *parameters = [NSMutableDictionary dictionary];
    // 1-头像 2评论
    parameters[@"module"] = @"1";
    
    WeakSelf
    
    [[NetworkSingleton sharedManager] uploadImageWithUrl:@"" parameters:parameters image:image successBlock:^(id response) {
        if ([[response objectForKey:@"code"] integerValue] == RequestSuccess) {
            
            weakSelf.headpic = [NSString stringWithFormat:@"%@",[response objectForKey:@"id"]];
            
//            [WYProgress showSuccessWithStatus:@"上传图片成功" dismissWithDelay:1.0];
            
        } else {
//            [WYProgress showErrorWithStatus:@"上传图片失败" dismissWithDelay:1.0];
        }
    } failureBlock:^(NSString *error) {
    }];

}

#pragma mark - PersonalEditCellDelegate
- (void)personalEditCell:(PersonalEditCell *)personalEditCell textFieldDidEndEditing:(NSString *)content {
    self.nickName = content;
    [self.tableView reloadData];
}

@end
