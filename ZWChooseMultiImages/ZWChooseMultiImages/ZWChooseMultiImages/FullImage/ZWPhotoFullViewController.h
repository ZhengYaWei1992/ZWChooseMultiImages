//
//  ZWPhotoFullViewController.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
typedef NS_ENUM(NSInteger, ZWFullImageType) {
    ZWFullImageTypeSomePreview,//预览一部分，即点击预览按钮
    ZWFullImageTypeAllPreview//预览全部，即点击图片
};
@interface ZWPhotoFullViewController : UIViewController

//预览类型
@property (nonatomic, assign) ZWFullImageType previewType;
//预览索引
@property (nonatomic, assign) NSInteger previewIndex;

@end
