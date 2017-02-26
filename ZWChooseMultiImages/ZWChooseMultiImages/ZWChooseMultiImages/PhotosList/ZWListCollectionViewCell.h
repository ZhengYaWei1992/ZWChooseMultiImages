//
//  ZWListCollectionViewCell.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>


@protocol ZWListCollectionViewCellDelegate <NSObject>
//将选择的图片个数传递出去
- (void)imageHelperGetImageCount:(NSInteger)count;

@end


@interface ZWListCollectionViewCell : UICollectionViewCell
@property (nonatomic, weak) id<ZWListCollectionViewCellDelegate>delegate;

- (void)displayCellWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath isCancleAction:(BOOL)cancleAction;
@end
