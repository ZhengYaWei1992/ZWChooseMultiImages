//
//  ZWPhotosListViewController.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPhotosListViewController.h"
#import "ZWImageHelper.h"
#import "ZWGroupModel.h"
#import "ZWPhotoListFooterView.h"
#import "ZWListCollectionViewCell.h"
#import "ZWPhotoFullViewController.h"
#import "ZWChooseMultiImagesConfig.h"

//显示各个分组的页面
#import "ZWPhotoGroupsViewController.h"

@interface ZWPhotosListViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ZWPhotoListFooterViewDelegate,ZWListCollectionViewCellDelegate>

@property (nonatomic,strong) UICollectionView *collectionView;
//是否取消所选择的全部照片
@property (nonatomic, assign) BOOL cancelAllAction;
//底部视图
@property (nonatomic,strong) ZWPhotoListFooterView *fooerView;
//顶部视图
@property(nonatomic,strong)UIView *topView;


@end

@implementation ZWPhotosListViewController

#pragma mark -lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.fooerView];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
   
    self.navigationController.navigationBarHidden = YES;
    self.cancelAllAction = NO;
    [self.fooerView displayFooterWithCount:[ZWImageHelper shareImageHelper].phassetChoosedArr.count];
    [self.collectionView reloadData];
    
    if ([ZWImageHelper shareImageHelper].phassetChoosedArr.count) {
        self.fooerView.previewButton.enabled = YES;
        self.fooerView.sendButton.enabled = YES;
    }else{
        self.fooerView.previewButton.enabled = NO;
        self.fooerView.sendButton.enabled = NO;
    }
}


#pragma mark -systemMethod系统其他方法（非生命周期）
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}



- (void)showError:(NSString *)errorString{
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示" message:errorString preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *action = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:nil];
    [alert addAction:action];
    [self presentViewController:alert animated:YES completion:nil];
}



#pragma mark - action
//取消按钮点
- (void)cancleButtonClick:(UIButton *)cancleButton{
    [[ZWImageHelper shareImageHelper].phassetChoosedArr removeAllObjects];
    [self dismissViewControllerAnimated:YES completion:^{
        [[ZWImageHelper shareImageHelper].phassetArr removeAllObjects];
    }];
}
//左上角分组按钮
- (void)groupsBtnClick:(UIButton *)groupsBtn{
    //跳转进入分组界面，移除所有照片，因为不知道下一步可能在那里选择照片
    [[ZWImageHelper shareImageHelper].phassetChoosedArr removeAllObjects];
    [[ZWImageHelper shareImageHelper].phassetArr removeAllObjects];
    
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark - ZWListCollectionViewCellDelegate点击cell上选择图片按钮的回调
//Cell上选中或取消按钮
- (void)imageHelperGetImageCount:(NSInteger)count {
   
    
    [self.fooerView displayFooterWithCount:count];
    
    if ([ZWImageHelper shareImageHelper].phassetChoosedArr.count) {
        self.fooerView.previewButton.enabled = YES;
        self.fooerView.sendButton.enabled = YES;
    }else{
        self.fooerView.previewButton.enabled = NO;
        self.fooerView.sendButton.enabled = NO;
    }
}
#pragma mark- ZWPhotoListFooterViewDelegate底部两个按钮点击回调
//发送或预览
- (void)photoListFooterViewTapWithType:(ZWPhotoListFooterViewTapType)type {
    if (type == ZWPhotoListFooterViewTapTypeSend) {
        [self dismissViewControllerAnimated:YES completion:nil];
        [[ZWImageHelper shareImageHelper].phassetArr removeAllObjects];
    }else {
        ZWPhotoFullViewController *fullVC = [[ZWPhotoFullViewController alloc]init];
        fullVC.previewType = ZWFullImageTypeSomePreview;
        [self.navigationController pushViewController:fullVC animated:YES];
    }
}






#pragma mark    UICollectionViewDelegate, UICollectionViewDataSource
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [ZWImageHelper shareImageHelper].phassetArr.count;
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZWListCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWListCollectionViewCell" forIndexPath:indexPath];
    [cell displayCellWithDataSource:[ZWImageHelper shareImageHelper].phassetArr withIndexPath:indexPath isCancleAction:self.cancelAllAction];
    cell.delegate = self;
    return cell;
    
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
        ZWPhotoFullViewController *fullVC = [[ZWPhotoFullViewController alloc]init];
        //预览所有照片
        fullVC.previewType = ZWFullImageTypeAllPreview;
        fullVC.previewIndex = indexPath.item;
        [self.navigationController pushViewController:fullVC animated:YES];
}


#pragma mark    UICollectionViewDelegateFlowLayout
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat padding = 3.0;
    CGFloat itemW = (self.view.frame.size.width - padding * 5)/4.0;
    return CGSizeMake(itemW , itemW * 1.1);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3, 3, 3, 3);
}







#pragma mark- 懒加载
//底部视图
- (ZWPhotoListFooterView *)fooerView{
    if (_fooerView == nil) {
        _fooerView = [[ZWPhotoListFooterView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
        _fooerView.delegate = self;
        _fooerView.backgroundColor = ZWChooseMultiImagesTopViewColor;
    }
    return _fooerView;
}
- (UIView *)topView{
    if (_topView == nil) {
        _topView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
        _topView.backgroundColor = ZWChooseMultiImagesTopViewColor;
        //取消按钮
        UIButton *cancleBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
        [cancleBtn addTarget:self action:@selector(cancleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        cancleBtn.titleLabel.font = ZWChooseMultiImagesTopAndBottomFont;
        cancleBtn.frame = CGRectMake(CGRectGetMaxX(_topView.frame)-70, 20, 70, 44);
        [_topView addSubview:cancleBtn];
        //显示所有groups的按钮
        UIButton *groupsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [groupsBtn setImage:[UIImage imageNamed:@"zw_choosePhotos_back"] forState:UIControlStateNormal];
//         [groupsBtn setTitle:@"<" forState:UIControlStateNormal];
//        groupsBtn.titleLabel.font = [UIFont systemFontOfSize:30];
        [groupsBtn addTarget:self action:@selector(groupsBtnClick:) forControlEvents:UIControlEventTouchUpInside];
        groupsBtn.frame = CGRectMake(0, 20, 70, 44);
        [_topView addSubview:groupsBtn];
    }
    return _topView;
}

- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //线性布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //水平方向，元素之间的最小距离
        layout.minimumInteritemSpacing = 0;
        //行之间的最小距离
        layout.minimumLineSpacing = 3;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置元素的大小
        //layout.itemSize = CGSizeMake(100, 120);
        
        //        CGRect frame = CGRectMake(0, CGRectGetMaxY(self.channelView.frame), ScreenWidth, ScreenHeight - CGRectGetMaxY(self.channelView.frame));
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64 - 49) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[ZWListCollectionViewCell class] forCellWithReuseIdentifier:@"ZWListCollectionViewCell"];
        //collectionView.pagingEnabled = YES;
        collectionView.bounces = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.backgroundColor = [UIColor whiteColor];
        _collectionView = collectionView;
    }
    return _collectionView;
}

@end
