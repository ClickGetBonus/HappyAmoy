//
//  WYCarouselView.m
//  ImageCarouselDemo
//
//  Created by apple on 16/10/13.
//  Copyright © 2016年 apple. All rights reserved.
//

#import "WYCarouselView.h"
// 滑动方向
typedef enum{
    DirectionNone,
    DirectionLeft,
    DirectionRight,
}Direction;

@interface WYCarouselView () <UIScrollViewDelegate>

// 滚动视图
@property (nonatomic, strong) UIScrollView *scrollView;
// 轮播的图片数组
@property (nonatomic, strong) NSMutableArray *images;
// 下载的图片字典
@property (nonatomic, strong) NSMutableDictionary *imageDic;
// 下载图片的操作
@property (nonatomic, strong) NSMutableDictionary *operationDic;
// 当前显示的imageview
@property (nonatomic, strong) UIImageView *currentImgView;
// 下一个将要显示的imageview
@property (nonatomic, strong) UIImageView *otherImageView;

// 滚动方向
@property (nonatomic, assign) Direction direction;

// 当前显示的索引
@property (nonatomic, assign) NSInteger currentIndex;
// 下一个将要显示的索引
@property (nonatomic, assign) NSInteger nextIndex;

// 定时器
@property (nonatomic, strong) NSTimer *timer;
// 任务队列
@property (nonatomic, strong) NSOperationQueue *queue;

@end

@implementation WYCarouselView

#pragma mark - 构造方法

+ (instancetype)wy_carouselWithFrame:(CGRect)frame imgArray:(NSArray *)imgArray imageClickBlock:(ImgClickBlock)imageClickBlock
{
    return [self wy_carouselWithFrame:frame imgArray:imgArray describeArray:nil imageClickBlock:imageClickBlock];
}

+ (instancetype)wy_carouselWithFrame:(CGRect)frame imgArray:(NSArray *)imgArray describeArray:(NSArray *)describeArray imageClickBlock:(ImgClickBlock)imageClickBlock
{
    return [[self alloc] initWithFrame:frame imgArray:imgArray describeArray:describeArray imageClickBlock:imageClickBlock];
}

- (instancetype)initWithFrame:(CGRect)frame imgArray:(NSArray *)imgArray describeArray:(NSArray *)describeArray imageClickBlock:(ImgClickBlock)imageClickBlock
{
    if (self = [super initWithFrame:frame])
    {
        self.imageArray = imgArray;
        self.describeArray = describeArray;
        self.imgClickBlock = imageClickBlock;
    }
    
    return self;
}

- (instancetype)initWithFrame:(CGRect)frame {
    
    if (self = [super initWithFrame:frame]) {
        self.isAutoSizeImage = YES;
    }
    
    return self;
}

#pragma mark - 初始化方法
// 创建用来缓存图片的文件夹
+ (void)initialize
{
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WYCarousel"];
    BOOL isDir = NO;
    BOOL isExists = [[NSFileManager defaultManager] fileExistsAtPath:cache isDirectory:&isDir];
    
    if (!isExists || !isDir)
    {
        [[NSFileManager defaultManager] createDirectoryAtPath:cache withIntermediateDirectories:YES attributes:nil error:nil];
    }
}

- (void)dealloc
{
    [self removeObserver:self forKeyPath:@"direction"];
}

#pragma mark- frame相关
- (CGFloat)height {
    return self.scrollView.frame.size.height;
}

- (CGFloat)width {
    return self.scrollView.frame.size.width;
}

#pragma mark - 懒加载
- (NSMutableDictionary *)imageDic
{
    if (!_imageDic)
    {
        _imageDic = [NSMutableDictionary dictionary];
    }
    return _imageDic;
}

- (NSMutableDictionary *)operationDic
{
    if (!_operationDic)
    {
        _operationDic = [NSMutableDictionary dictionary];
    }
    
    return _operationDic;
}

- (NSOperationQueue *)queue
{
    if (!_queue)
    {
        _queue = [[NSOperationQueue alloc] init];
    }
    return _queue;
}

- (UIScrollView *)scrollView
{
    if (!_scrollView)
    {
        _scrollView = [[UIScrollView alloc] init];
        _scrollView.pagingEnabled = YES;
        _scrollView.bounces = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.delegate = self;
        _currentImgView = [[UIImageView alloc] init];
        _currentImgView.userInteractionEnabled = YES;
        // 为当前显示的图片添加手势点击
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageClick)];
        [_currentImgView addGestureRecognizer:tap];
//        _currentImgView.backgroundColor = [UIColor redColor];
        [_scrollView addSubview:_currentImgView];
        _otherImageView = [[UIImageView alloc] init];
//        _otherImageView.backgroundColor = [UIColor blueColor];
        _otherImageView.userInteractionEnabled = YES;
        [_otherImageView addGestureRecognizer:tap];

        [_scrollView addSubview:_otherImageView];
        [self addSubview:_scrollView];
    }
    
    return _scrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl)
    {
        _pageControl = [[UIPageControl alloc] init];
        _pageControl.hidesForSinglePage = YES;
        _pageControl.userInteractionEnabled = NO;
        [self addSubview:_pageControl];
    }
    
    return _pageControl;
}

- (UILabel *)describeLab
{
    if (!_describeLab)
    {
        _describeLab = [[UILabel alloc] init];
        _describeLab.backgroundColor = [UIColor colorWithWhite:0 alpha:0.5f];
        _describeLab.textColor = QHWhiteColor;
        _describeLab.font = [UIFont systemFontOfSize:13];
        _describeLab.textAlignment = NSTextAlignmentCenter;
        _describeLab.hidden = YES;
        [self addSubview:_describeLab];
    }
    
    return _describeLab;
}

#pragma mark - 设置控件的frame
- (void)setFrame:(CGRect)frame
{
    [super setFrame:frame];
    [self addObserver:self forKeyPath:@"direction" options:NSKeyValueObservingOptionNew | NSKeyValueObservingOptionOld context:nil];
    self.scrollView.frame = self.bounds;
    self.describeLab.frame = CGRectMake(0, self.height - 20, self.width, 20);
    self.pageControl.center = CGPointMake(self.width * 0.5, self.height - 10);
    _scrollView.contentOffset = CGPointMake(self.width, 0);
    _currentImgView.frame = CGRectMake(self.width, 0, self.width, self.height);
    [self setScrollViewContentSize];
}

#pragma mark - KVO监听
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
//    if (change[NSKeyValueChangeNewKey] == change[NSKeyValueChangeOldKey])
//    {
//        return;
//    }
    if ([change[NSKeyValueChangeNewKey] integerValue] == DirectionRight)
    {// 向左滑动的时候只执行这个代码块
        self.otherImageView.frame = CGRectMake(0, 0, self.width, self.height);
        self.nextIndex = self.currentIndex - 1;
        if (self.nextIndex < 0)
        {
            if (_images.count < 1) {
                self.nextIndex = 0;
            } else {
                self.nextIndex = _images.count - 1;
            }
        }
    }
    else if ([change[NSKeyValueChangeNewKey] integerValue] == DirectionLeft)
    {// 向右滑动的时候先执行这个代码块，再执行上面那个代码块
        self.otherImageView.frame = CGRectMake(CGRectGetMaxX(_currentImgView.frame), 0, self.width, self.height);
        self.nextIndex = (self.currentIndex + 1) % _images.count;
        
    }
    if (self.nextIndex < 0) {
        if (_images.count < 1) {
            self.nextIndex = 0;
        } else {
            self.nextIndex = _images.count - 1;
        }
    }
    self.otherImageView.image = self.isAutoSizeImage ? [UIImage scaleAcceptFitWithImage:self.images[self.nextIndex] imageView:self.otherImageView] : self.images[self.nextIndex];

}

#pragma mark - 图片的点击事件

- (void)imageClick
{
    if (self.imgClickBlock)
    {
        self.imgClickBlock(self.currentIndex);
    }
}

- (void)downloadImages:(int)index
{
    NSString *key = _imageArray[index];
    // 从内存缓存中取图片
    UIImage *image = [self.imageDic objectForKey:key];
    if (image)
    {
        _images[index] = image;
    }
    else
    {
        // 从沙盒缓存中取图片
        NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WYCarousel"];
        NSString *path = [cache stringByAppendingPathComponent:[key lastPathComponent]];        // 从路径中获得完整的文件名（带后缀）
        NSData *data = [NSData dataWithContentsOfFile:path];
        if (data)
        {
            image = [UIImage imageWithData:data];
            _images[index] = image;
            [self.imageDic setObject:image forKey:key];
        }
        else
        {
            // 下载图片
            NSBlockOperation *download = [self.operationDic objectForKey:key];
            if (!download)
            {
                // 创建一个操作
                download = [NSBlockOperation blockOperationWithBlock:^{
                    NSURL *url = [NSURL URLWithString:key];
                    NSData *data = [NSData dataWithContentsOfURL:url];      // 要加载网络图片，必须要在info.plist文件中，添加App Transport Security Settings---->Allow Arbitrary Loads------->YES，否则会加载失败
                    if (data)
                    {
                        UIImage *image = [UIImage imageWithData:data];
                        [self.imageDic setObject:image forKey:key];
                        self.images[index] = image;
                        // 如果只有一张图片，需要在主线程主动去修改currentImageView的值
                        if (_images.count == 1)
                        {
                            [_currentImgView performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
                        }
                        [data writeToFile:path atomically:YES];
                        [self.operationDic removeObjectForKey:key];
                    }
                }];
                [self.queue addOperation:download];
                [self.operationDic setObject:download forKey:key];
            }
        }
    }
}

#pragma mark - 清除沙盒中的缓存
- (void)clearDiskCache
{
    NSString *cache = [[NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject] stringByAppendingPathComponent:@"WYCarousel"];
    
    NSArray *contents = [[NSFileManager defaultManager] contentsOfDirectoryAtPath:cache error:NULL];
    for (NSString *fileName in contents)
    {
        [[NSFileManager defaultManager] removeItemAtPath:[cache stringByAppendingPathComponent:fileName] error:nil];
    }
}

#pragma mark - 设置图片数组
- (void)setImageArray:(NSArray *)imageArray
{
    if (!imageArray.count)
    {
        return;
    }
    _imageArray = imageArray;
    _images = [NSMutableArray array];
    for (int i = 0; i < imageArray.count; i++)
    {
        if ([imageArray[i] isKindOfClass:[UIImage class]])
        {
            [_images addObject:imageArray[i]];
        }
        else if ([imageArray[i] isKindOfClass:[NSString class]])
        {// 图片的网络路径
            // 先加载占位图片，等下载完毕再替换正式图片
            [_images addObject:[UIImage imageNamed:@"placeholder"]];
            [self downloadImages:i];
        }
    }
    self.currentImgView.image = self.isAutoSizeImage ? [UIImage scaleAcceptFitWithImage:_images.firstObject imageView:self.currentImgView] : _images.firstObject;

    self.pageControl.numberOfPages = _images.count;
    
    [self setScrollViewContentSize];
}

#pragma mark - 设置图片描述数组
- (void)setDescribeArray:(NSArray *)describeArray
{
    _describeArray = describeArray;
    // 如果描述的个数与图片个数不一致，则补全空字符串
    if (describeArray && describeArray.count > 0)
    {
        if (describeArray.count < _images.count)
        {
            NSMutableArray *describes = [NSMutableArray arrayWithArray:describeArray];
            for (NSInteger i = describeArray.count; i < _images.count; i++)
            {
                [describes addObject:@""];
            }
            _describeArray = describes;
        }
        self.describeLab.hidden = NO;
        _describeLab.text = _describeArray.firstObject;
    }
}

#pragma mark - 设置scrollView的contenSize
- (void)setScrollViewContentSize
{
    if (_images.count > 1)
    {
        self.scrollView.contentSize = CGSizeMake(self.width * 3, 0);
        self.time = 3;  // 默认为3s
    }
    else
    {
        self.scrollView.contentSize = CGSizeZero;
    }
}

#pragma mark - 设置pageControl的图片
- (void)setPageImage:(UIImage *)pageImage currentImage:(UIImage *)currentImage
{
    if (pageImage)
    {
        [self.pageControl setValue:currentImage forKey:@"_currentPageImage"];
    }
    if (currentImage)
    {
        [self.pageControl setValue:pageImage forKey:@"_pageImage"];
    }
}

#pragma mark - 设置定时器时间
- (void)setTime:(NSTimeInterval)time
{
    _time = time;
    
    [self startTimer];
}

#pragma mark - 开启定时器
- (void)startTimer
{
    // 如果只有一张图片，则直接返回，不开启定时器
    if (_images.count <= 1) {
        return;
    }
    // 如果定时器已开启，先停止再重新开启
    if (self.timer)
    {
        [self stopTimer];
    }
    
    self.timer = [NSTimer timerWithTimeInterval:self.time target:self selector:@selector(nextPage) userInfo:nil repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:self.timer forMode:NSRunLoopCommonModes];
}

#pragma mark - 停止定时器
- (void)stopTimer
{
    [self.timer invalidate];
    self.timer = nil;
}

#pragma mark - 下一页
- (void)nextPage
{
    if (_images.count > 1) {
        [self.scrollView setContentOffset:CGPointMake(self.width * 2, 0) animated:YES];
    }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
//    if (_images.count > 1) {
    self.direction = scrollView.contentOffset.x > self.width?DirectionLeft : DirectionRight;
//    }
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    [self stopTimer];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self startTimer];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self pauseScroll];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self pauseScroll];
}

- (void)pauseScroll
{
    self.direction = DirectionNone;
    int index = self.scrollView.contentOffset.x / self.width;
    if (index == 1)
    {
        return;
    }
    self.currentIndex = self.nextIndex;
    self.pageControl.currentPage = self.currentIndex;
    self.currentImgView.frame = CGRectMake(self.width, 0, self.width, self.height);
    self.describeLab.text = self.describeArray[self.currentIndex];
    self.currentImgView.image = self.isAutoSizeImage ? [UIImage scaleAcceptFitWithImage:self.otherImageView.image imageView:self.currentImgView] : self.otherImageView.image;

    self.scrollView.contentOffset = CGPointMake(self.width, 0);
    
    if ([_delegate respondsToSelector:@selector(carouselView:didScrollToIndex:)]) {
        [_delegate carouselView:self didScrollToIndex:self.currentIndex];
    }
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
