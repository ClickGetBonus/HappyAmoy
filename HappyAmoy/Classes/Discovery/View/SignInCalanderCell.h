//
//  SignInCalanderCell.h
//  HappyAmoy
//
//  Created by apple on 2018/7/16.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SignInCalanderCell : UICollectionViewCell

/**    日期    */
@property(nonatomic,copy) NSString *date;
/**    是否已经签到    */
@property(nonatomic,assign) BOOL haveSignIn;

@end
