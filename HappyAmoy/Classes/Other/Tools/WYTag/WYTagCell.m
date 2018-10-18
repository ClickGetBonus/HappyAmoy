//
//  WYTagCell.m
//  DianDian
//
//  Created by apple on 17/10/27.
//  Copyright © 2017年 com.chinajieyin.www. All rights reserved.
//

#import "WYTagCell.h"

@interface WYTagCell ()

@property (weak, nonatomic) IBOutlet UILabel *tagLabel;

@property (weak, nonatomic) IBOutlet UIButton *tagButton;

@end

@implementation WYTagCell

- (void)awakeFromNib {
    
    [super awakeFromNib];
    
    // 默认配置
    [self defaultConfigure];
    
    self.tagButton.backgroundColor = _defaultBackgroundColor;
    
    self.tagButton.userInteractionEnabled = YES;

    [self.tagButton setTitleColor:_defaultTextColor forState:UIControlStateNormal];
    
}

#pragma mark - 默认配置
- (void)defaultConfigure {
    // 默认颜色
    _defaultBackgroundColor = QHWhiteColor;
    _defaultTextColor = QHBlackColor;
    _defaultBorderColor = [UIColor clearColor];
    // 默认共同爱好的颜色
    _backgroundColorOfSameHobby = QHWhiteColor;
    _textColorOfSameHobby = QHBlackColor;
    _borderColorOfSameHobby = [UIColor clearColor];

}

- (void)setDefaultBackgroundColor:(UIColor *)defaultBackgroundColor {
    
    _defaultBackgroundColor = defaultBackgroundColor;
    
}

- (void)setDefaultTextColor:(UIColor *)defaultTextColor {
    
    _defaultTextColor = defaultTextColor;
    
}

- (void)setDefaultBorderColor:(UIColor *)defaultBorderColor {
    
    _defaultBorderColor = defaultBorderColor;
    
}

- (void)setBackgroundColorOfSameHobby:(UIColor *)backgroundColorOfSameHobby {
    
    _backgroundColorOfSameHobby = backgroundColorOfSameHobby;

}

- (void)setTextColorOfSameHobby:(UIColor *)textColorOfSameHobby {
    
    _textColorOfSameHobby = textColorOfSameHobby;
    
}

- (void)setBorderColorOfSameHobby:(UIColor *)borderColorOfSameHobby {
    
    _borderColorOfSameHobby = borderColorOfSameHobby;
    
}

- (void)setTagString:(NSString *)tagString {
    
    _tagString = tagString;
    
    [self.tagButton setTitle:_tagString forState:UIControlStateNormal];
}

- (void)setIsSameHobby:(BOOL)isSameHobby {
    
    _isSameHobby = isSameHobby;
    // 更新UI
    [self updateUI];
}

/**
 *  @brief  更新UI
 */
- (void)updateUI {
    
    if (_isSameHobby) { // 有共同的兴趣爱好，底色和文字颜色要不同
        self.tagButton.backgroundColor = _backgroundColorOfSameHobby;
        self.tagButton.layer.borderColor = [_borderColorOfSameHobby CGColor];  //边框的颜色
        [self.tagButton setTitleColor:_textColorOfSameHobby forState:UIControlStateNormal];
    } else {
        self.tagButton.backgroundColor = _defaultBackgroundColor;
        self.tagButton.layer.borderColor = [_defaultBorderColor CGColor];  //边框的颜色
        [self.tagButton setTitleColor:_defaultTextColor forState:UIControlStateNormal];
    }
    
}

#pragma mark - 控件方法
/**
 *  @brief  点击标签按钮
 */
- (IBAction)didClickTagButton:(UIButton *)sender {
    
    WYLog(@"sender.title = %@",sender.titleLabel.text);
    
    if (_didClickTagButtonCallBack) {
        _didClickTagButtonCallBack(self.tagString);
    }
    
}

@end
