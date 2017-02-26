//
//  ZWImageHelper.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface ZWImageHelper : NSObject

//单列对象
+ (ZWImageHelper *)shareImageHelper;

//所有相片集合 (里面是多个PHAsset)
@property (nonatomic, strong) NSMutableArray *phassetArr;

//所有被选择的PHAsset    使用单例对象的这个属性，全局记录选中的图片
@property (nonatomic, strong) NSMutableArray *phassetChoosedArr;


//获取一个相册里面所有照片的操作
- (void)getAllImageActionWithCollection:(PHFetchResult *)result;


@end
