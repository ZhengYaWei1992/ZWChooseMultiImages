//
//  ZWPhotoGroupTableViewCell.h
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZWPhotoGroupTableViewCell : UITableViewCell
- (void)displayCellWithDataSource:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)path;
@end
