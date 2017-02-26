//
//  ZWFullImageFooterView.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZWFullImageFooterViewDelegate <NSObject>

- (void)chooseImageSendAction;

@end

@interface ZWFullImageFooterView : UIView

@property (nonatomic, weak) id<ZWFullImageFooterViewDelegate>delegate;

//发送图片按钮
@property(nonatomic,strong)UIButton *sendButton;

- (void)displayFooterWithCount:(NSInteger)count;


@end
