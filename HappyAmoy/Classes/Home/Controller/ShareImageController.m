//
//  ShareImageController.m
//  HappyAmoy
//
//  Created by apple on 2018/5/20.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "ShareImageController.h"
#import "ShareImageCell.h"
#import "CommodityDetailItem.h"

@interface ShareImageController () <UICollectionViewDataSource,UICollectionViewDelegate>

/**    collectionView    */
@property (strong, nonatomic) UICollectionView *collectionView;

@end

static NSString *const shareCellId = @"shareCellId";

@implementation ShareImageController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = ViewControllerBackgroundColor;
    
    [self setupUI];
    
    WeakSelf
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:@"ShareImage" object:nil] subscribeNext:^(id x) {
        [weakSelf.collectionView reloadData];
    }];
}

#pragma mark - UI

- (void)setupUI {
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    
    layout.itemSize = CGSizeMake(AUTOSIZESCALEX(250), AUTOSIZESCALEX(345));
    layout.minimumLineSpacing = AUTOSIZESCALEX(15);
    layout.minimumInteritemSpacing = AUTOSIZESCALEX(15);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
    collectionView.delegate = self;
    collectionView.dataSource = self;
    collectionView.backgroundColor = [UIColor clearColor];
    collectionView.showsHorizontalScrollIndicator = NO;
    collectionView.contentInset = UIEdgeInsetsMake(0, AUTOSIZESCALEX(15), 0, AUTOSIZESCALEX(15));
    [collectionView registerClass:[ShareImageCell class] forCellWithReuseIdentifier:shareCellId];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view).offset(AUTOSIZESCALEX(15));
        make.left.right.equalTo(self.view).offset(AUTOSIZESCALEX(0));
        make.height.mas_equalTo(AUTOSIZESCALEX(345));
    }];
    
    UIButton *copyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    copyButton.layer.cornerRadius = AUTOSIZESCALEX(3);
    copyButton.layer.masksToBounds = YES;
    copyButton.titleLabel.font = TextFont(12);
    [copyButton setTitle:@"一键保存图片到相册" forState:UIControlStateNormal];
    [copyButton setTitleColor:QHBlackColor forState:UIControlStateNormal];
    [copyButton gradientButtonWithSize:CGSizeMake(AUTOSIZESCALEX(125), AUTOSIZESCALEX(23)) colorArray:@[(id)ColorWithHexString(@"#ffb42b"),(id)ColorWithHexString(@"#ffb42b")] percentageArray:@[@(0.2),@(1.0)] gradientType:GradientFromTopToBottom];
    [self.view addSubview:copyButton];
    [copyButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.collectionView.mas_bottom).offset(AUTOSIZESCALEX(15));
        make.right.equalTo(self.view).offset(AUTOSIZESCALEX(-15));
        make.width.mas_equalTo(AUTOSIZESCALEX(125));
        make.height.mas_equalTo(AUTOSIZESCALEX(23));
    }];
    
    [[copyButton rac_signalForControlEvents:UIControlEventTouchUpInside] subscribeNext:^(id x) {
        [WYProgress show];
        for (UIImage *image in [LoginUserDefault userDefault].shareImageArray) {
            [WYPhotoLibraryManager wy_savePhotoImage:image completion:^(UIImage *image, NSError *error) {
                if (!error) {
                } else {
                }
            }];
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [WYProgress showSuccessWithStatus:@"保存图片成功!"];
        });
        
    }];
}

#pragma mark - UICollectionViewDataSource

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [LoginUserDefault userDefault].shareImageArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    ShareImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:shareCellId forIndexPath:indexPath];
    cell.index = indexPath.row;
    cell.shareImage = [LoginUserDefault userDefault].shareImageArray[indexPath.row];
//    cell.item = self.item;
//    cell.isFirstImage = indexPath.row == 0;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    WYLog(@"indexPath = %zd",indexPath.row);
    [WYPackagePhotoBrowser showPhotoWithImageArray:[LoginUserDefault userDefault].shareImageArray currentIndex:indexPath.row];
}


#pragma mark - Button Action

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [self.view endEditing:YES];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

@end
