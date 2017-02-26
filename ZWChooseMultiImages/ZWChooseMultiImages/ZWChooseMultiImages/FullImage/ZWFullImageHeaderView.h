//
//  ZWFullImageHeaderView.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWFullImageHeaderViewDelegate <NSObject>

//返回按钮
- (void)fullImageHeaderViewTapDismissAction;
//改变选择状态
- (void)fullImageHeaderViewTapChangeChooseStatusAction;

@end

@interface ZWFullImageHeaderView : UIView
@property (nonatomic, weak) id<ZWFullImageHeaderViewDelegate>delegate;

- (void)displayHeaderWihtDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath;

@end
