//
//  HistorySearchCell.m
//  HappyAmoy
//
//  Created by lb on 2018/9/24.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "HistorySearchCell.h"
#import "SearchDataItem.h"

static const CGFloat kSearchHistorySubViewHeight = 24.0f; // Item 高度
static const CGFloat kSearchHistorySubViewTopSpace = 7.0f; // 上下间距
static const NSInteger kSearchHistoryContentViewTag = 1400;

static  NSString *const kSearchHistoryRowKeyIden = @"kSearchHistoryRowKeyIden";

@interface HistorySearchCell()
@property (nonatomic, strong) NSArray *historyArray;
@property (nonatomic, assign) float rowHeight;
@end
@implementation HistorySearchCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+ (CGFloat)historyCellHeightWithData:(NSArray *)historyArray {
    NSInteger countRow = 0; // 第几行数
    countRow = [[NSUserDefaults standardUserDefaults] integerForKey:kSearchHistoryRowKeyIden];
    countRow = (historyArray.count > 0) ? (countRow + 1) : 0;
    return countRow * (kSearchHistorySubViewHeight + kSearchHistorySubViewTopSpace) + kSearchHistorySubViewTopSpace;
}



- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

#pragma mark - Method
- (void)setHistroyViewWithArray:(NSArray *)historyArray {
//    self.historyArray = historyArray;
    self.contentView.userInteractionEnabled = YES;
    [self.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    // 计算位置
    CGFloat leftSpace = 8.0f;  // 左右空隙
    CGFloat topSpace = 7.0f; // 上下空隙
    CGFloat margin = 15.0f;  // 两边的间距
    CGFloat currentX = margin; // X
    CGFloat currentY = 0; // Y
    NSInteger countRow = 0; // 第几行数
    CGFloat lastLabelWidth = 0; // 记录上一个宽度
    _rowHeight = 0;
    for (int i = 0; i < historyArray.count; i++) {
        // 最多显示10个
//        if (i > 9) {
//            break;
//        }
        /** 计算Frame */
        SearchDataItem *item = [historyArray objectAtIndex:i];
        CGFloat nowWidth = [self textWidth:item.keyword];
        if (i == 0) {
            currentX = currentX + lastLabelWidth;
        }
        else {
            currentX = currentX + leftSpace + lastLabelWidth;
        }
        currentY = countRow * kSearchHistorySubViewHeight + (countRow + 1) * topSpace;
        // 换行
        if (currentX + leftSpace + margin + nowWidth >= SCREEN_WIDTH) {
            countRow++;
            currentY = currentY + kSearchHistorySubViewHeight + topSpace;
            currentX = margin;
        }
        if (countRow > 2) {
            break;
        }
        lastLabelWidth = nowWidth;
        // 文字内容
        
        UILabel *contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(currentX, currentY, nowWidth, kSearchHistorySubViewHeight)];
        /** Label 具体显示 */
        contentLabel.userInteractionEnabled = YES;
        contentLabel.text = item.keyword;
        contentLabel.font = TextFont(11);
        contentLabel.textAlignment = NSTextAlignmentCenter;
        contentLabel.backgroundColor = ViewControllerBackgroundColor;
        [contentLabel addGestureRecognizer:[[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tagDidClick:)]];
//        UILongPressGestureRecognizer *longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressClick:)];
//        longPress.minimumPressDuration = 1.5f;
//        [contentLabel addGestureRecognizer:longPress];
        contentLabel.tag = kSearchHistoryContentViewTag + i;
        [self.contentView addSubview:contentLabel];
        _rowHeight = contentLabel.bottom_WY + 10;
    }
//    [[NSUserDefaults standardUserDefaults] setInteger:countRow forKey:kSearchHistoryRowKeyIden];
}

- (CGFloat)textWidth:(NSString *)text {
    CGFloat width = [text boundingRectWithSize:CGSizeMake(SCREEN_WIDTH, kSearchHistorySubViewHeight) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName : [UIFont systemFontOfSize:11]} context:nil].size.width + 20;
    // 防止 宽度过大
    if (width > SCREEN_WIDTH - 20) {
        width = SCREEN_WIDTH - 20;
    }
    return width;
}

#pragma mark -
- (void)setHistoryArray:(NSArray *)historyArray
{
    _historyArray = historyArray;
    [self setHistroyViewWithArray:_historyArray];
}

- (float)getRowHeight
{
    return _rowHeight;
}
#pragma mark - Private Method
- (void)tagDidClick:(UITapGestureRecognizer *)tapGesture {
    UILabel *clickLabel = (UILabel *)tapGesture.view;
    NSInteger index = clickLabel.tag - kSearchHistoryContentViewTag;
    NSLog(@"history == %lu",index);
    if (self.searchTapHistoryBlock) {
        self.searchTapHistoryBlock(index);
    }
}

//- (void)longPressClick:(UILongPressGestureRecognizer *)panGesture {
//    CanCancelLabel *clickLabel = (CanCancelLabel *)panGesture.view;
//    NSInteger index = clickLabel.tag - kSearchHistoryContentViewTag;
//    if(panGesture.state == UIGestureRecognizerStateBegan) {
//        NSLog(@"long Press == %lu",index);
//        clickLabel.showCancel = NO;
//        __weak typeof(self) weakSelf = self;
//        clickLabel.clearOneHistroyBlock = ^{
//            __strong typeof(self) strongSelf = weakSelf;
//            if (strongSelf.searchLongPressClearHistoryBlock) {
//                strongSelf.searchLongPressClearHistoryBlock(index);
//            }
//        };
//    }
//}

@end
