//
//  ZWChoosedCollectionViewCell.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Photos/Photos.h>

@interface ZWChoosedCollectionViewCell : UICollectionViewCell

- (void)displayCellWithDataSource:(NSMutableArray *)dataSource withIndexPath:(NSIndexPath *)indexPath;

@end
