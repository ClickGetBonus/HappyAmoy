//
//  GlobalSearchShareController.h
//  HappyAmoy
//
//  Created by apple on 2018/7/26.
//  Copyright © 2018年 apple. All rights reserved.
//

#import "BaseViewControll.h"

@class TaoBaoSearchItem;
@class TaoBaoSearchDetailItem;

@interface GlobalSearchShareController : BaseViewControll

/**    列表数据模型    */
@property (strong, nonatomic) TaoBaoSearchItem *listItem;
/**    详情数据模型    */
@property (strong, nonatomic) TaoBaoSearchDetailItem *detailItem;


@end
