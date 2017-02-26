//
//  ZWPhotoFullViewController.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/23.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPhotoFullViewController.h"
#import "ZWFullImageHeaderView.h"
#import "ZWFullImageFooterView.h"
#import "ZWFullImageCollectionViewCell.h"
#import "ZWImageHelper.h"
#import "ZWChooseMultiImagesConfig.h"

@interface ZWPhotoFullViewController ()<UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout,  UIScrollViewDelegate, ZWFullImageHeaderViewDelegate,ZWFullImageFooterViewDelegate>

@property (nonatomic,strong)UICollectionView *collectionView;
//顶部视图
@property (nonatomic,strong)ZWFullImageHeaderView *topView;
//底部视图
@property(nonatomic,strong)ZWFullImageFooterView *footerView;

//这里弄一个临时变量，保存最初进入该界面时，原本选中的资源。否为始终操作[ZWImageHelper shareImageHelper].phassetChoosedArr这一个数据源，collectionView在滚动的时候会更新数据，取消选中某个数据之后，原本的数据就不见了。总结：collectionView的数据源最好是固定不变的，否则一边改变数据源，一边显示也会跟着变化。
@property(nonatomic,strong)NSMutableArray *tempPhassetChoosedArr;

//@property (nonatomic, assign) NSInteger scrollFlag;
//是否展示原图
@property (nonatomic, assign) BOOL isOriginal;
//是否隐藏topView和bottomView
@property(nonatomic,assign)BOOL isHidden;

@end

@implementation ZWPhotoFullViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.collectionView];
    [self.view addSubview:self.topView];
    [self.view addSubview:self.footerView];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(collectionViewTapGesture:)];
    [self.collectionView addGestureRecognizer:tap];
    
    self.isOriginal = NO;

    if (self.previewType == ZWFullImageTypeAllPreview) {//展示分组中所有照片  点击上页面的collectionViewCell，执行这里
        [self.topView displayHeaderWihtDataSource:[ZWImageHelper shareImageHelper].phassetArr withIndexPath:[NSIndexPath indexPathForItem:self.previewIndex inSection:0]];
    }else {//预览选中的几张图片 点击上页面的预览按钮，执行这里
        [self.topView displayHeaderWihtDataSource:[ZWImageHelper shareImageHelper].phassetChoosedArr withIndexPath:[NSIndexPath indexPathForItem:0 inSection:0]];
    }
    //展示选中照片的张数
     [self.footerView displayFooterWithCount:[ZWImageHelper shareImageHelper].phassetChoosedArr.count];
    
    
    if ([ZWImageHelper shareImageHelper].phassetChoosedArr.count) {
        self.footerView.sendButton.enabled = YES;
    }else{
        self.footerView.sendButton.enabled = NO;
    }
    
}
- (void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    //如果是预览分组中所有照片
    if (self.previewType == ZWFullImageTypeAllPreview ) {
        [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForRow:self.previewIndex inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:NO];
    }
}

#pragma mark -系统方法
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (BOOL)prefersStatusBarHidden {
    return YES;
}



#pragma mark -Action
#pragma mark -ZWFullImageHeaderViewDelegate
//上部是否选择按钮
- (void)fullImageHeaderViewTapChangeChooseStatusAction{
    if ([ZWImageHelper shareImageHelper].phassetChoosedArr.count) {
        self.footerView.sendButton.enabled = YES;
    }else{
        self.footerView.sendButton.enabled = NO;
    }
    [self.footerView displayFooterWithCount:[ZWImageHelper shareImageHelper].phassetChoosedArr.count];
}
//上部返回按钮
- (void)fullImageHeaderViewTapDismissAction{
    [self.navigationController popViewControllerAnimated:YES];
}
#pragma mark -ZWFullImageFooterViewDelegate
//底部发送按钮
- (void)chooseImageSendAction{
    
    [self dismissViewControllerAnimated:YES completion:nil];
    [[ZWImageHelper shareImageHelper].phassetArr removeAllObjects];
}
//collectionView上的单击手势
- (void)collectionViewTapGesture:(UITapGestureRecognizer *)tap{
    _isHidden = !_isHidden;
    if (_isHidden == YES) {
        [UIView animateWithDuration:1 animations:^{
            _topView.alpha = 0.0;
            _footerView.alpha = 0.0;
        }];
    }else{
        [UIView animateWithDuration:1 animations:^{
            _topView.alpha = 1.0;
            _footerView.alpha = 1.0;
        }];
    }
}


#pragma mark    UIScrollViewDelegate代理方法
//停止滚动的时候调用的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    CGFloat offset = scrollView.contentOffset.x / self.view.frame.size.width;
    NSIndexPath *path = [NSIndexPath indexPathForItem:round(offset) inSection:0];
    //停止滚动后，根据原始数据，再次设置顶部视图显示情况。
    if (self.previewType == ZWFullImageTypeAllPreview) {
        [self.topView displayHeaderWihtDataSource:[ZWImageHelper shareImageHelper].phassetArr withIndexPath:path];
    }else {
        [self.topView displayHeaderWihtDataSource:self.tempPhassetChoosedArr withIndexPath:path];
    }
}


#pragma mark    collectionView的代理方法
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.previewType == ZWFullImageTypeAllPreview) {
        return [ZWImageHelper shareImageHelper].phassetArr.count;
    }else {
        return self.tempPhassetChoosedArr.count;
    }
}
- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    ZWFullImageCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"ZWFullImageCollectionViewCell" forIndexPath:indexPath];
    if (self.previewType == ZWFullImageTypeAllPreview) {//查看所有布局
        [cell displayCellWithDataSource:[ZWImageHelper shareImageHelper].phassetArr inedexPath:indexPath isOriginalImage:self.isOriginal];
    }else {//查看选中的数据源布局
        [cell displayCellWithDataSource:self.tempPhassetChoosedArr inedexPath:indexPath isOriginalImage:self.isOriginal];
    }
    return cell;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
}
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    return UIEdgeInsetsMake(0, 0, 0, 0);
}




#pragma mark -懒加载
- (ZWFullImageHeaderView *)topView{
    if (_topView == nil) {
        _topView = [[ZWFullImageHeaderView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 64)];
         _topView.backgroundColor = ZWChooseMultiImagesTopViewColor;
        _topView.delegate = self;
    }
    return _topView;
}
- (ZWFullImageFooterView *)footerView{
    if (_footerView == nil) {
        _footerView = [[ZWFullImageFooterView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height - 49, self.view.frame.size.width, 49)];
        _footerView.backgroundColor = ZWChooseMultiImagesBottomViewColor;
        _footerView.delegate = self;
    }
    return _footerView;
}
- (UICollectionView *)collectionView{
    if (_collectionView == nil) {
        //线性布局
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        //水平方向，元素之间的最小距离
        layout.minimumInteritemSpacing = 0;
        //行之间的最小距离
        layout.minimumLineSpacing = 0;
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        //设置元素的大小
        layout.itemSize = CGSizeMake(self.view.frame.size.width, self.view.frame.size.height);
        
        UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:layout];
        collectionView.delegate = self;
        collectionView.dataSource = self;
        [collectionView registerClass:[ZWFullImageCollectionViewCell class] forCellWithReuseIdentifier:@"ZWFullImageCollectionViewCell"];
        collectionView.pagingEnabled = YES;
        collectionView.bounces = YES;
        collectionView.showsHorizontalScrollIndicator = NO;
        collectionView.showsVerticalScrollIndicator = YES;
        collectionView.backgroundColor = [UIColor blackColor];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (NSMutableArray *)tempPhassetChoosedArr{
    if (_tempPhassetChoosedArr == nil) {
        _tempPhassetChoosedArr = [NSMutableArray arrayWithArray:[ZWImageHelper shareImageHelper].phassetChoosedArr];
    }
    return _tempPhassetChoosedArr;
}


@end
