//
//  ViewController.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ViewController.h"
//框架
#import <Photos/Photos.h>
//全局单例类
#import "ZWImageHelper.h"
//本页面自定义cell
#import "ZWChoosedCollectionViewCell.h"
//进入相册,模态弹进的页面
#import "ZWPhotosListViewController.h"
#import "ZWPhotoGroupsViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>

@property (nonatomic,strong) UICollectionView *collectionView;
//此页面选择的图片
@property (nonatomic, strong) NSMutableArray *chooseImages;
//前往选择图片按钮
@property(nonatomic,strong)UIButton *chooseImagesBtn;

@end

@implementation ViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    [self.view addSubview:self.chooseImagesBtn];
    [self.view addSubview:self.collectionView];
    
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self.chooseImages removeAllObjects];
    [self.chooseImages addObjectsFromArray:[ZWImageHelper shareImageHelper].phassetChoosedArr];
    NSLog(@"%ld",[ZWImageHelper shareImageHelper].phassetChoosedArr.count);
    //每次选完照片回来后，全局选中图片清空。
    [[ZWImageHelper shareImageHelper].phassetChoosedArr removeAllObjects];
    
    [self.collectionView reloadData];
}

#pragma mark - action
- (void)goToChooseImages:(UIButton *)chooseImagesBtn{
    /*
     访问图片资源库要在plist中添加如下字段
     <key>NSPhotoLibraryUsageDescription</key>
     <string>是否允许访问图片资源库</string>
     */
    //模态进入某个group的list页面
//    ZWPhotosListViewController *listVC = [[ZWPhotosListViewController alloc]init];
//    UINavigationController *listNav = [[UINavigationController alloc]initWithRootViewController:listVC];
//    [[ZWImageHelper shareImageHelper]getAllImageActionWithCollection:nil];
//    [self presentViewController:listNav animated:YES completion:nil];
    
    ZWPhotoGroupsViewController *groupsVC = [[ZWPhotoGroupsViewController alloc]init];
    UINavigationController *groupsNav = [[UINavigationController alloc]initWithRootViewController:groupsVC];
    [[ZWImageHelper shareImageHelper]getAllImageActionWithCollection:nil];
    [self presentViewController:groupsNav animated:YES completion:nil];
    
}

#pragma mark-collectionView代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.chooseImages.count;
}

- (UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    //UICollectionView只有通过下面的方法查找可复用cell，所以对于UICollectionView，必须注册cell
    ZWChoosedCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWChoosedCollectionViewCell" forIndexPath:indexPath];
    [cell displayCellWithDataSource:self.chooseImages withIndexPath:indexPath];
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat padding = 3.0;
    CGFloat itemW = (self.view.frame.size.width - padding * 4)/3.0;
    return CGSizeMake(itemW , itemW * 1.1);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(3, 3, 3, 3);
}


#pragma mark -懒加载
- (UIButton *)chooseImagesBtn{
    if (!_chooseImagesBtn) {
        _chooseImagesBtn = [[UIButton alloc]initWithFrame:CGRectMake(self.view.frame.size.width/2 - 100, 64, 200, 44)];
        [_chooseImagesBtn setTitle:@"点击选择多张照片" forState:UIControlStateNormal];
        [_chooseImagesBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_chooseImagesBtn setBackgroundColor:[UIColor redColor]];
        [_chooseImagesBtn addTarget:self action:@selector(goToChooseImages:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _chooseImagesBtn;
}


- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //线性布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //水平方向，元素之间的最小距离
        layout.minimumInteritemSpacing = 0;
        //行之间的最小距离
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionVertical;
        //设置元素的大小
        //layout.itemSize = CGSizeMake(100, 120);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.chooseImagesBtn.frame) + 20, self.view.frame.size.width, self.view.frame.size.height - CGRectGetMaxY(self.chooseImagesBtn.frame) - 20) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[ZWChoosedCollectionViewCell class] forCellWithReuseIdentifier:@"ZWChoosedCollectionViewCell"];
        collectionView.pagingEnabled = YES;
        collectionView.bounces = NO;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.backgroundColor = [UIColor lightGrayColor];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSMutableArray *)chooseImages{
    if (_chooseImages == nil) {
        _chooseImages = [NSMutableArray array];
    }
    return _chooseImages;
}

@end
