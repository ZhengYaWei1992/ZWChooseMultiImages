//
//  ZWGroupModel.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ZWGroupModel : NSObject
@property (nonatomic, strong) NSMutableArray *kindArr;
- (void)getAllKindImagesAction;
@end
