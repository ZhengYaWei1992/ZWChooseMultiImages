//
//  ZWImageHelper.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWImageHelper.h"

@implementation ZWImageHelper
+ (ZWImageHelper *)shareImageHelper {
    static ZWImageHelper *helper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (helper == nil) {
            helper = [[ZWImageHelper alloc] init];
        }
    });
    return helper;
}



//获取一个相册里面所有照片的操作
- (void)getAllImageActionWithCollection:(PHFetchResult *)result {
    if (result) {
        for (id obj in result) {//获取标识符
            [self.phassetArr addObject:obj];
        }
    }else {
        // 获取所有资源的集合，并按资源的创建时间排序
        ///获取资源时的参数
        PHFetchOptions *options = [[PHFetchOptions alloc] init];
        options.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:YES]];
        //表示一系列的资源的集合,也可以是相册的集合
        PHFetchResult *assetsFetchResults = [PHAsset fetchAssetsWithOptions:options];
        for (id obj in assetsFetchResults) {//获取标识符
            
            [self.phassetArr addObject:obj];
            
            
        //============================================
        //重点说明：如果不采用标志符方式，而是按照如下方式，读取太慢会导致拖动卡顿
        //            PHAsset *asset = obj;
        //            if ([asset.localIdentifier isKindOfClass:[NSString class]]) {
        //                [self.phassetArr addObject:asset.localIdentifier];
        //            }
        }
        for (NSInteger i = 0; i < assetsFetchResults.count; i++) {
//            if (assetsFetchResults[i]) {
//                
//            }
            
        }
    }
}


#pragma mark - 懒加载
- (NSMutableArray *)phassetArr {
    if (!_phassetArr) {
        _phassetArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _phassetArr;
}
- (NSMutableArray *)phassetChoosedArr  {
    if (!_phassetChoosedArr) {
        _phassetChoosedArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _phassetChoosedArr;
}


@end
