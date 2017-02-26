//
//  ZWPhotoGroupTableViewCell.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPhotoGroupTableViewCell.h"
#import <Photos/Photos.h>

@interface ZWPhotoGroupTableViewCell ()
@property (nonatomic,strong) UIImageView *kindImageView;
@property (nonatomic,strong) UILabel *kindNameLabel;
@property (nonatomic,strong) UILabel *kindCountLabel;
@property(nonatomic,strong)  UILabel *arrowLabel;

@end

@implementation ZWPhotoGroupTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _kindImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"zw_choosePhotos_placeholder"]];
       
        
        _kindNameLabel = [[UILabel alloc]init];
        _kindNameLabel.font = [UIFont boldSystemFontOfSize:17];
        _kindNameLabel.text = @"hello";
        
        
        _kindCountLabel = [[UILabel alloc]init];
        _kindCountLabel.font = [UIFont systemFontOfSize:17];
        _kindCountLabel.text = @"(5)";
        _kindCountLabel.textColor = [UIColor lightGrayColor];
        
        
        _arrowLabel.text = @">";
        _arrowLabel.font = [UIFont systemFontOfSize:20];
        _arrowLabel.textColor = [UIColor lightGrayColor];
        
        [self.contentView addSubview:self.kindImageView];
        [self.contentView addSubview:self.kindNameLabel];
        [self.contentView addSubview:self.kindCountLabel];
        [self.contentView addSubview:self.arrowLabel];
       
        
    }
    return self;
}


- (void)displayCellWithDataSource:(NSMutableArray *)dataSource indexPath:(NSIndexPath *)path {
    if (dataSource.count > path.row) {
        NSDictionary *data = dataSource[path.row];
        [self displayCellWithDataSource:data];
    }
}

- (void)displayCellWithDataSource:(NSDictionary *)dataDic {
    __weak ZWPhotoGroupTableViewCell *weakSelf = self;
    
     PHFetchResult *result = dataDic[@"result"];
    CGSize imageSize = CGSizeMake(100 , 100);
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.synchronous = YES;
    options.resizeMode = PHImageRequestOptionsResizeModeFast;
    if (result.count > 0) {
        PHAsset *asset = result.firstObject;
        [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:imageSize contentMode:PHImageContentModeAspectFill options:options resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
            weakSelf.kindImageView.image = result;
        }];
    }
    _kindImageView.frame = CGRectMake(0, 0, self.frame.size.height, self.frame.size.height);
    NSString *title = dataDic[@"title"];
    NSString *count = dataDic[@"count"];
    self.kindNameLabel.text = title;
    self.kindNameLabel.numberOfLines = 0;
    _kindNameLabel.frame = CGRectMake(CGRectGetMaxX(_kindImageView.frame) + 20, 0, 150, self.frame.size.height);
    
    
    _arrowLabel = [[UILabel alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame) - 40, 0, 40, self.frame.size.width)];
    
    self.kindCountLabel.text =[NSString stringWithFormat:@"(%@)",count];
    _kindCountLabel.frame = CGRectMake(CGRectGetMinX(_arrowLabel.frame) - 40, 0, 40, self.frame.size.height);
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
