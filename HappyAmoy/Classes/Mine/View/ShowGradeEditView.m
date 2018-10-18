//
//  ShowGradeEditView.m
//  HappyAmoy
//
//  Created by apple on 2018/4/21.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShowGradeEditView.h"
#import <AVKit/AVKit.h>
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

@interface ShowGradeEditView() <YYTextViewDelegate>

/**    输入框    */
@property (strong, nonatomic) YYTextView *textView;
/**    选择图片按钮    */
@property (strong, nonatomic) UIButton *selecteButton;

@end

// 最多输入字数
static const NSInteger maxTextCount = 20;

@implementation ShowGradeEditView

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = QHWhiteColor;
        self.imageArray = [NSMutableArray array];
        
        [self setupUI];
        self.layer.cornerRadius = 6;
        self.layer.masksToBounds = YES;
    }
    return self;
}

#pragma mark - UI

- (void)setupUI {
    
    YYTextView *textView = [[YYTextView alloc] init];
    textView.placeholderText = @"编辑文字内容不能超过20字数";
    textView.placeholderFont = TextFont(14);
    textView.placeholderTextColor = ColorWithHexString(@"#888888");
    textView.font = TextFont(14);
    textView.textColor = QHBlackColor;
    textView.delegate = self;
    [self addSubview:textView];
    self.textView = textView;
    
    UIButton *selecteButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [selecteButton setBackgroundImage:ImageWithNamed(@"相机") forState:UIControlStateNormal];
    [self addSubview:selecteButton];
    self.selecteButton = selecteButton;
    WeakSelf
    [[selecteButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [weakSelf endEditing:YES];
        [WYUtils showActionSheetWithTitle:nil message:nil firstActionTitle:@"直接拍照上传" firstAction:^{
            [weakSelf takePhotos];
        } secondActionTitle:@"从手机相片选择" secondAction:^{
            [weakSelf selectImage];
        }];
    }];
    [UIFont fontWithName:@"" size:14];
    [self addConstraints];
    
    UILabel *tipLabel = [[UILabel alloc] init];
    tipLabel.text = @"上传一张图片";
    tipLabel.font = TextFont(13.5);
    tipLabel.textColor = RGB(150, 150, 150);
    [self addSubview:tipLabel];
    [tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self.selecteButton).offset(AUTOSIZESCALEX(0));
        make.left.equalTo(self.selecteButton.mas_right).offset(AUTOSIZESCALEX(17.5));
    }];
}

#pragma mark - Layout

- (void)addConstraints {
    
    [self.textView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self).offset(AUTOSIZESCALEX(10));
        make.left.equalTo(self).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self).offset(AUTOSIZESCALEX(-15));
        make.height.mas_equalTo(AUTOSIZESCALEX(90));
    }];
    
    [self.selecteButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.equalTo(self).offset(AUTOSIZESCALEX(-15));
        make.left.equalTo(self.textView).offset(AUTOSIZESCALEX(0));
        make.width.mas_equalTo(AUTOSIZESCALEX(65));
        make.height.mas_equalTo(AUTOSIZESCALEX(65));
    }];
}

#pragma mark - Setter

#pragma mark - Lazy load

- (NSString *)content {
    
    _content = self.textView.text;
    
    return _content;
}

- (NSMutableArray *)imageArray {
    if (!_imageArray) {
        _imageArray = [NSMutableArray array];
    }
    return _imageArray;
}

#pragma mark - YYTextViewDelegate

- (void)textViewDidChange:(YYTextView *)textView {
    
    UITextRange *selectedRange = [textView markedTextRange];
    
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
//    if (selectedRange && pos) {
//        return;
//    }
    
    NSString *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > maxTextCount){ //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:maxTextCount];
        textView.text = s;
        existTextNum = maxTextCount;
    }
}

#pragma mark - Private method

// 直接拍照上传
- (void)takePhotos {
    
    WeakSelf
    
    WYCameraController *cameraVc = [WYCameraController defaultCamera];
    // 相机类型
    cameraVc.cameraType = PhotoCamera;
    // 拍照的回调
    cameraVc.didFinishTakePhotosHandle = ^(UIImage *image, NSError *error) {
        [weakSelf.imageArray addObject:image];
        [weakSelf.selecteButton setBackgroundImage:[UIImage scaleAcceptFitWithImage:image imageViewSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(65))] forState:UIControlStateNormal];
    };
    // 取消的回调
    cameraVc.cameraDidCancelHandle = ^{
        WYLog(@"取消拍照");
    };
    [[WYUtils rootViewController] presentViewController:cameraVc animated:YES completion:nil];
}

// 从手机相册选择图片
- (void)selectImage {
    
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    
    // 禁止选择视频
    imagePickerVc.allowPickingVideo = NO;
    WeakSelf
    // 选择图片的回调
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isSelectOriginalPhoto) {
        [weakSelf.imageArray addObjectsFromArray:photos];
        [weakSelf.selecteButton setBackgroundImage:[UIImage scaleAcceptFitWithImage:photos[0] imageViewSize:CGSizeMake(AUTOSIZESCALEX(65), AUTOSIZESCALEX(65))] forState:UIControlStateNormal];
    }];

    [[WYUtils rootViewController] presentViewController:imagePickerVc animated:YES completion:nil];
}



@end
