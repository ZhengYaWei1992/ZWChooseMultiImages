//
//  ZWGroupModel.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWGroupModel.h"
//要导入这个框架
#import <Photos/Photos.h>

@implementation ZWGroupModel

- (void)getAllKindImagesAction {
    PHFetchResult *kindAlbum = [PHAssetCollection fetchAssetCollectionsWithType:PHAssetCollectionTypeSmartAlbum subtype:PHAssetCollectionSubtypeAlbumRegular options:nil];
    for (PHAssetCollection *colllection  in kindAlbum) {
        NSString *kindName = colllection.localizedTitle;
        PHFetchResult *result = [PHAsset fetchAssetsInAssetCollection:colllection options:nil];
        NSString *imageCount = [@(result.count) stringValue];
        NSDictionary *resultDic = @{@"count" : imageCount, @"title" : kindName, @"result" : result};
        //过滤掉照片个数为0的分组
        NSString *countStr = resultDic[@"count"];
        if (![countStr isEqualToString:@"0"]) {
            [self.kindArr addObject:resultDic];
        }
    }
}

- (NSMutableArray *)kindArr {
    if (!_kindArr) {
        _kindArr = [NSMutableArray arrayWithCapacity:0];
    }
    return _kindArr;
}
@end
