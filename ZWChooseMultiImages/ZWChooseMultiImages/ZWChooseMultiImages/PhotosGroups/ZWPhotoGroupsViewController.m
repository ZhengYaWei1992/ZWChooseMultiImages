//
//  ZWPhotoGroupsViewController.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPhotoGroupsViewController.h"
#import "ZWPhotosListViewController.h"
#import "ZWPhotoGroupTableViewCell.h"
#import <Photos/Photos.h>
#import "ZWImageHelper.h"

@interface ZWPhotoGroupsViewController ()<UITableViewDelegate, UITableViewDataSource>

@property(nonatomic,strong)UITableView *tableView;

//特定分组对应的照片多选界面
@property(nonatomic,strong)ZWPhotosListViewController *listVC;
//照片分组groups模型(groupModle.kindArr包含多个分组信息)
@property (nonatomic, strong) ZWGroupModel *groupModle;


@end

@implementation ZWPhotoGroupsViewController

#pragma mark - lifeCycle
- (void)viewDidLoad {
    [super viewDidLoad];
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.title = @"照片";
    self.view.backgroundColor = [UIColor whiteColor];
    //首次进入直接跳转到下一界面
    [self.navigationController pushViewController:self.listVC animated:NO];
    
    //设置navBar
    [self setUpNavBar];
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    //这句设置才起作用 ？？？？？
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    //这句设置不起作用
     //[UIApplication sharedApplication].statusBarStyle = UIStatusBarStyleLightContent;
    //[self setNeedsStatusBarAppearanceUpdate];
    self.navigationController.navigationBarHidden = NO;
}
- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.navigationBarHidden = YES;
}
#pragma mark -systemMethod系统其他方法（非生命周期）
//再次返回界面的时候，设置状态栏不起作用，应该在将要进入界面的时候设置
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}


#pragma mark - Action
- (void)dismissAction:(UIBarButtonItem *)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}


#pragma mark -tableView代理方法
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.groupModle.kindArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    ZWPhotoGroupTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ZWPhotoGroupTableViewCell" forIndexPath:indexPath];
    [cell displayCellWithDataSource:self.groupModle.kindArr indexPath:indexPath];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    __weak ZWPhotoGroupsViewController *weakSelf = self;
    NSDictionary *data = self.groupModle.kindArr[indexPath.row];
    PHFetchResult *result = data[@"result"];
    //if (result.count > 0) {
        [[ZWImageHelper shareImageHelper] getAllImageActionWithCollection:result];
        [weakSelf.navigationController pushViewController:self.listVC animated:YES];
    //}
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 65;
}


#pragma mark - private
- (void)setUpNavBar{
    //bar的背景色
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    //左右item颜色
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    NSDictionary *att = @{NSForegroundColorAttributeName:[UIColor whiteColor]};
    //title颜色
    self.navigationController.navigationBar.titleTextAttributes = att;
    //是否半透明
    self.navigationController.navigationBar.translucent = YES;
    
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"" style:UIBarButtonItemStyleDone target:self action:nil];
    self.navigationItem.rightBarButtonItem =[[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(dismissAction:)];
}
#pragma mark -懒加载
- (UITableView *)tableView{
    if(_tableView == nil){
        _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 64, self.view.frame.size.width, self.view.frame.size.height - 64) style:UITableViewStylePlain];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        [_tableView registerClass:[ZWPhotoGroupTableViewCell class] forCellReuseIdentifier:@"ZWPhotoGroupTableViewCell"];
    }
    return _tableView;
}

- (ZWGroupModel *)groupModle{
    if (_groupModle == nil) {
        _groupModle = [[ZWGroupModel alloc]init];
        [_groupModle getAllKindImagesAction];
    }
    return _groupModle;
}

- (ZWPhotosListViewController *)listVC{
    if (_listVC == nil) {
        _listVC = [[ZWPhotosListViewController alloc]init];
    }
    return _listVC;
}


@end
