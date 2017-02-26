//
//  ZWPhotoListFooterView.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//


//照片某个group的列表页面底部视图

#import <UIKit/UIKit.h>

@class ZWPhotoListFooterView;
typedef NS_ENUM(NSInteger, ZWPhotoListFooterViewTapType){
    ZWPhotoListFooterViewTapTypePreview,//预览
    ZWPhotoListFooterViewTapTypeSend//发送
};

@protocol ZWPhotoListFooterViewDelegate <NSObject>
//@required
- (void)photoListFooterViewTapWithType:(ZWPhotoListFooterViewTapType)type;
@end

@interface ZWPhotoListFooterView : UIView

//预览图片按钮
@property(nonatomic,strong)UIButton *previewButton;
//发送图片按钮
@property(nonatomic,strong)UIButton *sendButton;

@property (nonatomic, weak) id<ZWPhotoListFooterViewDelegate>delegate;

//展示底部视图选照片的张数
- (void)displayFooterWithCount:(NSInteger)count;
@end
