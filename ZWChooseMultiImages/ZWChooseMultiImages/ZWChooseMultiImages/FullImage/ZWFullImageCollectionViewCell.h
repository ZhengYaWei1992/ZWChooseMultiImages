//
//  ZWFullImageCollectionViewCell.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWFullImageCollectionViewCell : UICollectionViewCell

- (void)displayCellWithDataSource:(NSMutableArray *)dataSource  inedexPath:(NSIndexPath *)indexPath isOriginalImage:(BOOL)isOriginal;

@end
