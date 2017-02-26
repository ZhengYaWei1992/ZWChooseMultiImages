//
//  ZWChoosedCollectionViewCell.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWChoosedCollectionViewCell.h"

#define CELL_COLLECTION_WIDTH   [UIScreen mainScreen].bounds.size.width / 4.0

@interface ZWChoosedCollectionViewCell ()

@property(nonatomic,strong)UIImageView *chooseImage;

@end

@implementation ZWChoosedCollectionViewCell


- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        //创建对象，添加到contentView上
        _chooseImage = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        _chooseImage.image = [UIImage imageNamed:@"zw_choosePhotos_placeholder"];
        [self.contentView addSubview:_chooseImage];
    }
    return self;
}


- (void)displayCellWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath  {
    if (dataSource.count > indexPath.row) {
        PHAsset *assetString = dataSource[indexPath.row];
        [self displayCellWithAssetString:assetString ];
    }
}

/**
 asset，图像对应的 PHAsset。
 targetSize，需要获取的图像的尺寸，如果输入的尺寸大于资源原图的尺寸，则只返回原图。需要注意在 PHImageManager 中，所有的尺寸都是用 Pixel 作为单位（Note that all sizes are in pixels），因此这里想要获得正确大小的图像，需要把输入的尺寸转换为 Pixel。如果需要返回原图尺寸，可以传入 PhotoKit 中预先定义好的常量?PHImageManagerMaximumSize，表示返回可选范围内的最大的尺寸，即原图尺寸。
 contentMode，图像的剪裁方式，与?UIView 的 contentMode 参数相似，控制照片应该以按比例缩放还是按比例填充的方式放到最终展示的容器内。注意如果 targetSize 传入?PHImageManagerMaximumSize，则 contentMode 无论传入什么值都会被视为?PHImageContentModeDefault。
 options，一个?PHImageRequestOptions 的实例，可以控制的内容相当丰富，包括图像的质量、版本，也会有参数控制图像的剪裁，下面再展开说明。
 resultHandler，请求结束后被调用的 block，返回一个包含资源对于图像的 UIImage 和包含图像信息的一个 NSDictionary，在整个请求的周期中，这个 block 可能会被多次调用，关于这点连同 options 参数在下面展开说明。
 */

#warning 整张图片显示时,如果限制张数可将"imageSize"换成PHImageManagerMaximumSize; 这样会显示高清的原图;
- (void)displayCellWithAssetString:(PHAsset *)asset  {
    __weak ZWChoosedCollectionViewCell *weakSelf = self;
    
    
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    
    //小图，大小自己定义
//    CGSize imageSize = CGSizeMake(CELL_COLLECTION_WIDTH - 6, CELL_COLLECTION_WIDTH - 6);
//    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
//        weakSelf.chooseImage.image = result;
//    }];
    
    //高清图
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:PHImageManagerMaximumSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        weakSelf.chooseImage.image = result;
    }];
}

@end
