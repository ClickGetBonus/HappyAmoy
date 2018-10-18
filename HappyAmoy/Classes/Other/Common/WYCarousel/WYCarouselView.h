//
//  WYCarouselView.h
//  ImageCarouselDemo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYCarouselView;

@protocol WYCarouselViewDelegate <NSObject>

@optional

- (void)carouselView:(WYCarouselView *)carouselView didScrollToIndex:(NSInteger)index;

@end

typedef void(^ImgClickBlock)(NSInteger currentIndex);

@interface WYCarouselView : UIView

// 轮播的图片数组，可以是UIImage，也可以是网络路径
@property (nonatomic, strong) NSArray *imageArray;
// 图片描述的字符串数组，要与图片顺序对应
@property (nonatomic, strong) NSArray *describeArray;
// 分页控件，默认位置在底部控件
@property (nonatomic, strong) UIPageControl *pageControl;
// 图片描述控件，默认在底部，黑色透明背景，13号白色字体
@property (nonatomic, strong) UILabel *describeLab;
// 每一页的停留时间，默认为3s，设置该属性会重新开启定时器
@property (nonatomic, assign) NSTimeInterval time;
/**    图片是否自适应,默认是    */
@property (assign, nonatomic) BOOL isAutoSizeImage;
// 点击图片后要执行的操作，会返回点击图片在数组中的索引
@property (nonatomic, copy) ImgClickBlock imgClickBlock;

/**    代理    */
@property (weak, nonatomic) id<WYCarouselViewDelegate> delegate;

// 构造方法
+ (instancetype)wy_carouselWithFrame:(CGRect)frame imgArray:(NSArray *)imgArray imageClickBlock:(ImgClickBlock)imageClickBlock;

+ (instancetype)wy_carouselWithFrame:(CGRect)frame imgArray:(NSArray *)imgArray describeArray:(NSArray *)describeArray imageClickBlock:(ImgClickBlock)imageClickBlock;

// 设置pageControl的图片
- (void)setPageImage:(UIImage *)pageImage currentImage:(UIImage *)currentImage;

@end
