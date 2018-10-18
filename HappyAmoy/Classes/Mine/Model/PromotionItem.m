//
//  PromotionItem.m
//  HappyAmoy
//
//  Created by apple on 2018/5/17.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "PromotionItem.h"

@implementation PromotionItem

+ (NSDictionary *)mj_replacedKeyFromPropertyName {
    
    return @{@"promotionId":@"id"};
}

// cell的高度
- (CGFloat)cellHeight {
    
    // 如果已经有缓存，则直接返回
    if (_cellHeight) return _cellHeight;
    
    // 文字的Y值
    _cellHeight = AUTOSIZESCALEX(15);
    // 文字的高度
    
    CGSize size = CGSizeMake(SCREEN_WIDTH - AUTOSIZESCALEX(15) - AUTOSIZESCALEX(100) , MAXFLOAT);
        
    if (![_title isEqualToString:@""]) { // 内容不为空
        _cellHeight += [NSString calculateLabelHeight:_title lineSpacing:TextLineSpacing maxWidth:size.width font:TextFont(14)];
    }
    
    // 图片与文字的间距
    _cellHeight += AUTOSIZESCALEX(15);
    
    if (_images.count > 0) {
        if (_images.count == 1) { // 只有一张图片
            
            _cellHeight += AUTOSIZESCALEX(195);

        } else { // 多张图片
            CGFloat collectionViewHeight = 0;
            NSInteger row = ((_images.count - 1) / 3 + 1);
            CGFloat itemWH = ((SCREEN_WIDTH - AUTOSIZESCALEX(80) - AUTOSIZESCALEX(15) - AUTOSIZESCALEX(6) * 2) / 3);

            collectionViewHeight = row * itemWH + (row - 1) * TextLineSpacing;
            _cellHeight +=  collectionViewHeight;
        }
        
        _cellHeight += NormalMargin * 1.5;

    }
   
    _cellHeight += AUTOSIZESCALEX(30);
    
    return _cellHeight;
}

@end
