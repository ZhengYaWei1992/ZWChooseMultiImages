//
//  PHAsset+addFlag.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "PHAsset+addFlag.h"
#import <objc/runtime.h>


static const char *CHOOSEFLAG = "CHOOSEFLAG";

@implementation PHAsset (addFlag)
- (void)setChooseFlag:(BOOL)chooseFlag {
    objc_setAssociatedObject(self, CHOOSEFLAG, @(chooseFlag), OBJC_ASSOCIATION_ASSIGN);
}

- (BOOL)chooseFlag {
    return [objc_getAssociatedObject(self, CHOOSEFLAG) integerValue];
}
@end
