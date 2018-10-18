//
//  WYHud.m
//  GridBaseApp
//
//  Created by apple on 16/12/23.
//  Copyright © 2016年 strongit.com. All rights reserved.
//

#import "WYHud.h"

@interface WYHud ()

/**    标题    */
@property (strong, nonatomic) UILabel *titleLab;

/**    HUD    */
@property (strong, nonatomic) UIView *hudView;

@end

@implementation WYHud

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
//        self.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.1];
        self.backgroundColor = [UIColor clearColor];

        // 设置界面
        [self setUpUI];
        
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismiss)];
        
        [self addGestureRecognizer:tap];
    }
    return self;
}

#pragma mark - 界面消失
- (void)dismiss {
    [self removeFromSuperview];
}

- (void)setUpUI {
    [self addSubview:self.hudView];
    [self.hudView addSubview:self.titleLab];
}

- (UILabel *)titleLab {
    if (!_titleLab) {
        UILabel *label = [[UILabel alloc] init];
//        label.point = CGPointMake(20, 20);
        label.numberOfLines = 0;
        label.textColor = QHWhiteColor;
        label.font = [UIFont systemFontOfSize:17.0];
        label.textAlignment = NSTextAlignmentCenter;
        label.width = SCREEN_WIDTH - 80;
        
        _titleLab = label;
    }
    return _titleLab;
}

- (UIView *)hudView {
    if (!_hudView) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(100, 200, 200, 35)];
        view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
//        view.backgroundColor = [UIColor clearColor];

        view.layer.cornerRadius = 5;
        view.center = self.center;
        
        _hudView = view;
    }
    return _hudView;
}

/**
 显示提示框
 
 @param message 提示消息，默认1.0秒后消失
 */
+ (void)showMessage:(NSString *)message {
    // 默认1.0秒
    [self showMessage:message duration:1.0];
}

/**
 显示提示框
 
 @param message 提示消息
 @param duration 显示框的显示时间
 */
+ (void)showMessage:(NSString *)message duration:(NSInteger)duration {
    
    UIWindow *keyWindow = [UIApplication sharedApplication].keyWindow;
    
    WYHud *hud = [[WYHud alloc] initWithFrame:keyWindow.frame];
    
    hud.titleLab.text = message;
    
    [hud.titleLab sizeToFit];
    
    hud.hudView.width = hud.titleLab.width + 40;
    hud.hudView.height = hud.titleLab.height + 30;

    hud.hudView.center = hud.center;
    
    // 设置字体居中
    hud.titleLab.center = CGPointMake(hud.hudView.width * 0.5, hud.hudView.height * 0.5);
    
    [keyWindow addSubview:hud];
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(duration * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [hud removeFromSuperview];
    });
}

@end
