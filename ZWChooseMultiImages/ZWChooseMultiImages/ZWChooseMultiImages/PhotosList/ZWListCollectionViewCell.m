//
//  ZWListCollectionViewCell.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWListCollectionViewCell.h"
#import <Photos/Photos.h>
#import "ZWChooseMultiImagesConfig.h"
//为PHAsset增加chooseFlag属性的类别
#import "PHAsset+addFlag.h"
#import "ZWImageHelper.h"

#define CELL_COLLECTION_WIDTH   [UIScreen mainScreen].bounds.size.width / 4.0

@interface ZWListCollectionViewCell ()
//imageView
@property (nonatomic,strong)UIImageView *photoImage;
//选择按钮
@property (nonatomic,strong)UIButton *chooseState;
//每一个cell都有这样一个属性，这个对象包含一个chooseFlag属性，用于记录是否被选中
@property (nonatomic, strong) PHAsset *tempAsset;
@end

@implementation ZWListCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        _photoImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _photoImage.image = [UIImage imageNamed:@"zw_choosePhotos_placeholder"];
        _photoImage.userInteractionEnabled = YES;
        [self.contentView addSubview:_photoImage];
        
        _chooseState = [UIButton buttonWithType:UIButtonTypeCustom];
        [_chooseState addTarget:self action:@selector(chooseStateClick:) forControlEvents:UIControlEventTouchUpInside];
        _chooseState.frame = CGRectMake(CGRectGetMaxX(self.photoImage.frame)-30, 0, 30, 30);
        [_chooseState setImage:[UIImage imageNamed:@"zw_icon_image_no"] forState:UIControlStateNormal];
         [_chooseState setImage:[UIImage imageNamed:@"zw_icon_image_yes"] forState:UIControlStateSelected];
        [self.photoImage addSubview:self.chooseState];
    }
    return self;
}

- (void)showTip:(NSString *)tipStr{
     UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:tipStr delegate:nil cancelButtonTitle:@"确定" otherButtonTitles: nil];
    [alertView show];
}

#pragma mark- action
- (void)chooseStateClick:(UIButton *)chooseState{
    //注意：可以取消选择，即按钮处于非选择状态，才执行这个分支
    if (chooseState.isSelected == NO) {
        if([ZWImageHelper shareImageHelper].phassetChoosedArr.count >= ZWChooseMaxPhotosCount){
            NSInteger count = ZWChooseMaxPhotosCount;
            [self showTip:[NSString stringWithFormat:@"最多只能选择%ld张照片",count]];
            return;
        }
    }
    
    
    self.chooseState.selected = !self.chooseState.selected;
    if (self.chooseState.selected) {
        [self.chooseState setImage:[UIImage imageNamed:@"zw_icon_image_yes"] forState:UIControlStateSelected];
        self.tempAsset.chooseFlag = YES;
        [[ZWImageHelper shareImageHelper].phassetChoosedArr addObject:self.tempAsset];
        [self animationAction];
    }else {
        [self.chooseState setImage:[UIImage imageNamed:@"zw_icon_image_no"] forState:UIControlStateNormal];
        self.tempAsset.chooseFlag = NO;
        [[ZWImageHelper shareImageHelper].phassetChoosedArr removeObject:self.tempAsset];
    }
    if ([self.delegate respondsToSelector:@selector(imageHelperGetImageCount:)]) {
        [self.delegate imageHelperGetImageCount:[ZWImageHelper shareImageHelper].phassetChoosedArr.count];
    }
    [self.chooseState setNeedsLayout];
}

#pragma mark - public
- (void)displayCellWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath isCancleAction:(BOOL)cancleAction {
    if (dataSource.count > indexPath.row) {
        PHAsset *assetString = dataSource[indexPath.row];
        [self displayCellWithAssetString:assetString isCancleAction:cancleAction];
    }
}
#pragma mark-private
- (void)displayCellWithAssetString:(PHAsset *)asset  isCancleAction:(BOOL)cancleAction{
    __weak ZWListCollectionViewCell *weakSelf = self;
    self.tempAsset = (PHAsset *)asset;
    if (!cancleAction) {
        if (asset.chooseFlag ) {
            self.chooseState.selected = YES;
            [self.chooseState setImage:[UIImage imageNamed:@"zw_icon_image_yes"] forState:UIControlStateSelected];
        }else {
            self.chooseState.selected = NO;
            [self.chooseState setImage:[UIImage imageNamed:@"zw_icon_image_no"] forState:UIControlStateNormal];
        }
    }else {
        asset.chooseFlag = NO;
        self.chooseState.selected = NO;
        [self.chooseState setImage:[UIImage imageNamed:@"zw_icon_image_no"] forState:UIControlStateNormal];
    }
    
    CGSize imageSize = CGSizeMake(CELL_COLLECTION_WIDTH - 6, CELL_COLLECTION_WIDTH - 6);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.photoImage.image = result;
    }];
    
#pragma mark    不采用标志符方式.读取太慢会导致拖动卡顿
    //    PHFetchResult *result = [self getPHFetchResultFromAssetString:asset];
    //    [result enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
    //        PHAsset *asset = (PHAsset *)obj;
    //        NSLog(@"%@________________", asset.chooseFlag);
    //        weakSelf.tempAsset = asset;
    //        if ([asset.chooseFlag isEqualToString:@"1"]) {
    //            weakSelf.chooseState.selected = YES;
    //            [weakSelf.chooseState setImage:[UIImage imageNamed:@"choose"] forState:UIControlStateSelected];
    //        }else {
    //            weakSelf.chooseState.selected = NO;
    //            [self.chooseState setImage:[UIImage imageNamed:@"unChoose"] forState:UIControlStateNormal];
    //        }
    //        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
    //            weakSelf.photoImage.image = result;
    ////            NSLog(@"%@_+_+_+_+_+_+_", info);
    //        }];
    //    }];

}


#pragma mark    按钮动画
- (void)animationAction {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(1.05), @(1.1), @(1.15),@(1.1), @(1.05), @(1), @(1.05), @(1.1), @(1.15),@(1.1), @(1.05),@(1)];
    [self.chooseState.imageView.layer addAnimation:animation forKey:@"animation"];
    
}

@end
