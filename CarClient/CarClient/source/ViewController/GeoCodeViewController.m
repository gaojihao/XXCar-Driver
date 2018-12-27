//
//  GeoCodeViewController.m
//  CarClient
//
//  Created by 栗志 on 2018/12/24.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "GeoCodeViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "LocationPointModel.h"

@interface GeoCodeViewController ()<UITextFieldDelegate>

@property (nonatomic, copy) void(^completionBlock)(LocationPointModel *point);

@property (nonatomic, copy) LocationPointModel *location;
@property (nonatomic, strong) UIView *barView;
@property (nonatomic, strong) UITextField *textField;
@property (nonatomic, strong) UIButton *cancelBtn;
@property (nonatomic, strong) UITableView *tableView;

@end

@implementation GeoCodeViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
}

- (void)onCancel
{
    
}

- (UIView *)barView
{
    if (!_barView)
    {
        _barView = [[UIView alloc] init];
        [self.view addSubview:_barView];
    }
    return _barView;
}

- (UITextField *)textField
{
    if (!_textField)
    {
        _textField = [[UITextField alloc] init];
        _textField.delegate = self;
        
        [self.barView addSubview:_textField];
    }
    return _textField;
}

- (UIButton *)cancelBtn
{
    if (!_cancelBtn)
    {
        _cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_cancelBtn addTarget:self action:@selector(onCancel) forControlEvents:UIControlEventTouchUpInside];
        [_cancelBtn setTitle:@"取消" forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.barView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}



@end
