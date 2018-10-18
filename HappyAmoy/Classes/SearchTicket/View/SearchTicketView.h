//
//  SearchTicketView.h
//  HappyAmoy
//
//  Created by apple on 2018/4/18.
//  Copyright © 2018年 apple. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchTicketView;

@protocol SearchTicketViewDelegate <NSObject>

@optional

- (void)searchTicketView:(SearchTicketView *)searchTicketView searchWithContent:(NSString *)content;

@end

@interface SearchTicketView : UIView

/**    代理    */
@property (weak, nonatomic) id<SearchTicketViewDelegate> delegate;

@end
