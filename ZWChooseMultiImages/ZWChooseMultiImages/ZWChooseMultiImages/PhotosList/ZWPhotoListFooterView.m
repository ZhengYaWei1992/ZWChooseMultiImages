//
//  ZWPhotoListFooterView.m
//  ZWChooseMultiImages
//
//  Created by 郑亚伟 on 2017/2/22.
//  Copyright © 2017年 zhengyawei. All rights reserved.
//

#import "ZWPhotoListFooterView.h"
#import "ZWChooseMultiImagesConfig.h"

@interface ZWPhotoListFooterView ()
//照片张数label
@property (nonatomic, strong) UILabel *countLable;
//
@property (nonatomic, strong) UIView *animationView;



@end

@implementation ZWPhotoListFooterView

#pragma mark -lifeCycle
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setupUI];
    }
    return self;
}
- (void)dealloc{
    [self.animationView.layer removeAnimationForKey:@"animation"];
    [self.countLable.layer removeAllAnimations];
}
#pragma mark -publick
- (void)displayFooterWithCount:(NSInteger)count {
    self.countLable.text = [@(count) stringValue];
    [self animationAction];
}

#pragma mark - Action
//预览按钮点击事件
- (void)previewButtonClick:(UIButton *)previewButton{
    if ([self.delegate respondsToSelector:@selector(photoListFooterViewTapWithType:)]) {
         [self.delegate photoListFooterViewTapWithType:ZWPhotoListFooterViewTapTypePreview];
    }
   
}
//发送按钮点击事件
- (void)sendButtonClick:(UIButton *)sendButton{
    if ([self.delegate respondsToSelector:@selector(photoListFooterViewTapWithType:)]) {
         [self.delegate photoListFooterViewTapWithType:ZWPhotoListFooterViewTapTypeSend];
    }
}

#pragma mark - private
- (void)animationAction {
    CAKeyframeAnimation *animation = [CAKeyframeAnimation animationWithKeyPath:@"transform.scale"];
    animation.repeatCount = 1;
    animation.removedOnCompletion = YES;
    animation.duration = 0.4;
    animation.fillMode = kCAFillModeForwards;
    animation.values = @[@(0.4), @(0.5), @(0.6), @(0.7), @(0.8), @(0.9),@(1), @(0.9), @(0.8), @(0.9),@(1)];
    [self.animationView.layer addAnimation:animation forKey:@"animation"];
}
- (void)setupUI{
    self.backgroundColor = [UIColor blackColor];
    [self addSubview:self.previewButton];
    [self addSubview:self.sendButton];
    [self addSubview:self.animationView];
    [self.animationView addSubview:self.countLable];
}


#pragma mark -懒加载
- (UIButton *)previewButton{
    if (_previewButton == nil) {
        _previewButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_previewButton setTitle:@"预览" forState:UIControlStateNormal];
        [_previewButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_previewButton addTarget:self action:@selector(previewButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _previewButton.titleLabel.font = ZWChooseMultiImagesTopAndBottomFont;
        _previewButton.enabled = NO;
        [_previewButton setTitleColor:[UIColor lightGrayColor] forState:UIControlStateDisabled];

        _previewButton.frame = CGRectMake(0, 0, 70, self.frame.size.height);
    }
    return _previewButton;
    
}
- (UIButton *)sendButton{
    if (_sendButton == nil) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
         _sendButton.titleLabel.font = ZWChooseMultiImagesTopAndBottomFont;
        [_sendButton setTitleColor:ZWChooseMultiImagesSendButtonNormalTitleColor forState:UIControlStateNormal];
        _sendButton.enabled = NO;
        [_sendButton setTitleColor:ZWChooseMultiImagesSendButtonDisableTitleColor forState:UIControlStateDisabled];
        [_sendButton addTarget:self action:@selector(sendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
        _sendButton.frame = CGRectMake(CGRectGetMaxX(self.frame)- 70, 0, 70, self.frame.size.height);
    }
    return _sendButton;
}

- (UILabel *)countLable{
    if (_countLable == nil) {
        _countLable = [[UILabel alloc]initWithFrame:self.animationView.bounds];
        _countLable.textColor = [UIColor whiteColor];
        _countLable.textAlignment = NSTextAlignmentCenter;
        _countLable.text = @"0";
        _countLable.userInteractionEnabled = YES;
        _countLable.backgroundColor = [UIColor clearColor];
        _countLable.font = [UIFont systemFontOfSize:12];
    }
    return _countLable;
}
- (UIView *)animationView{
    if (_animationView == nil) {
        _animationView = [[UIView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.frame)-80, 5, 20, 20)];
        _animationView.backgroundColor = [UIColor redColor];
        _animationView.clipsToBounds = YES;
        _animationView.layer.cornerRadius = 10;
    }
    return _animationView;
}
@end
