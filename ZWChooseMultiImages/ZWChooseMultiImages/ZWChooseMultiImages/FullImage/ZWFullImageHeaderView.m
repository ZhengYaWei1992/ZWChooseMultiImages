//
//  ZWFullImageHeaderView.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWFullImageHeaderView.h"
#import "PHAsset+addFlag.h"
#import "ZWImageHelper.h"
#import "ZWChooseMultiImagesConfig.h"

typedef NS_ENUM(NSInteger, ZWPreviewImageType) {
    PreviewImageTypeSome,
    PreviewImageTypeAll
};

@interface ZWFullImageHeaderView ()
//单个图片  扩展了chooseFlag属性
@property (nonatomic, strong) PHAsset *tempAsset;
//选择按钮
@property (nonatomic,strong) UIButton *chooseButton;
//返回按钮
@property (nonatomic,strong) UIButton *backButton;
//预览类型
@property (nonatomic, assign) ZWPreviewImageType previewType;

@end

@implementation ZWFullImageHeaderView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
#pragma maek- publick
- (void)displayHeaderWihtDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath {

    PHAsset *asset = dataSource[indexPath.row];
    if ([dataSource isEqual:[ZWImageHelper shareImageHelper].phassetArr]) {
        self.previewType = PreviewImageTypeAll;
    }else {
        self.previewType = PreviewImageTypeSome;
    }
    self.tempAsset = (PHAsset *)asset;
    self.chooseButton.selected  = asset.chooseFlag;
    
    [self.chooseButton setNeedsLayout];
}

- (void)showTip:(NSString *)tipStr{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark - action
//返回按钮
- (void)backButtonClick:(UIButton *)backButton{
    if ([self.delegate respondsToSelector:@selector(fullImageHeaderViewTapDismissAction)]) {
        [self.delegate fullImageHeaderViewTapDismissAction];
    }
}
//选择按钮
- (void)chooseButtonClick:(UIButton *)chooseButton{
    
    
    //注意：可以取消选择，即按钮处于非选择状态，才执行这个分支
    if (chooseButton.isSelected == NO) {
        if([ZWImageHelper shareImageHelper].phassetChoosedArr.count >= ZWChooseMaxPhotosCount){
            NSInteger count = ZWChooseMaxPhotosCount;
            [self showTip:[NSString stringWithFormat:@"最多只能选择%ld张照片",count]];
            return;
        }
    }
    
    
    self.chooseButton.selected = !self.chooseButton.selected;
    if (self.chooseButton.selected) {
       
        self.tempAsset.chooseFlag = YES;
        [self animationAction];
        if (self.previewType == PreviewImageTypeAll) {//预览所有
            [[ZWImageHelper shareImageHelper].phassetChoosedArr addObject:self.tempAsset];
        }else if (self.previewType == PreviewImageTypeSome){//预览选中的
            [[ZWImageHelper shareImageHelper].phassetChoosedArr addObject:self.tempAsset];
        }
    }else {
        self.tempAsset.chooseFlag = NO;
        if (self.previewType == PreviewImageTypeAll) {//预览所有
            [[ZWImageHelper shareImageHelper].phassetChoosedArr removeObject:self.tempAsset];
        }else if (self.previewType == PreviewImageTypeSome){//预览选中的
            [[ZWImageHelper shareImageHelper].phassetChoosedArr removeObject:self.tempAsset];
        }
    }
    
    if ([self.delegate respondsToSelector:@selector(fullImageHeaderViewTapChangeChooseStatusAction)]) {
        [self.delegate fullImageHeaderViewTapChangeChooseStatusAction];
    }

}

#pragma mark -private
- (void)setupUI{
   
    [self addSubview:self.backButton];
    [self addSubview:self.chooseButton];
    
}
//按钮动画
- (void)animationAction {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(1.05), @(1.1), @(1.15),@(1.1), @(1.05), @(1), @(1.05), @(1.1), @(1.15),@(1.1), @(1.05),@(1)];
    [self.chooseButton.imageView.layer addAnimation:animation forKey:@"animation"];
}




#pragma mark -懒加载
- (UIButton *)backButton{
    if (_backButton == nil) {
        _backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_backButton setImage:[UIImage imageNamed:@"zw_choosePhotos_back@2x"] forState:UIControlStateNormal];
        [_backButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _backButton.frame = CGRectMake(0, 0, 70, self.frame.size.height);
    }
    return _backButton;
}

- (UIButton *)chooseButton{
    if (_chooseButton == nil) {
        _chooseButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseButton setImage:[UIImage imageNamed:@"zw_icon_image_no"] forState:UIControlStateNormal];
        [_chooseButton setImage:[UIImage imageNamed:@"zw_icon_image_yes"] forState:UIControlStateSelected];
        [_chooseButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseButton addTarget:self action:@selector(chooseButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _chooseButton.frame = CGRectMake(CGRectGetMaxX(self.frame)-70, 0, 70, self.frame.size.height);
    }
    return _chooseButton;
}



- (void)dealloc {
    NSMutableArray *tempArr = [[ZWImageHelper shareImageHelper].phassetChoosedArr mutableCopy];
    for (PHAsset *asset in tempArr) {
        if (asset.chooseFlag == NO) {
            [[ZWImageHelper shareImageHelper].phassetChoosedArr removeObject:asset];
        }
    }
    [self.chooseButton.layer removeAnimationForKey:@"animation"];
    [self.chooseButton.layer removeAllAnimations];
}

@end
