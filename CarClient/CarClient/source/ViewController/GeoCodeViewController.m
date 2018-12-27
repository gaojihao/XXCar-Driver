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
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"

@interface GeoCodeViewController ()<UITextFieldDelegate,UITableViewDelegate,UITableViewDataSource>

@property (nonatomic, copy) void(^completionBlock)(LocationPointModel *point);

@property (nonatomic, strong) LocationPointModel *location;
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
    [self setupUI];
}

- (void)setupUI
{
    [self.barView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.height.mas_equalTo(50);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop);
        } else {
            make.top.equalTo(self.view.mas_top);
        }
    }];
    
    [self.cancelBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.barView.mas_centerY);
        make.right.equalTo(self.barView.mas_right).offset(-4);
        make.size.mas_equalTo(CGSizeMake(44, 44));
    }];
    
    [self.textField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.barView.mas_centerY);
        make.right.equalTo(self.cancelBtn.mas_left).offset(-4);
        make.left.equalTo(self.barView.mas_left).offset(15);
        make.height.mas_equalTo(34);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.barView.mas_bottom).offset(4);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
    }];
}

- (void)onCancel
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return [UITableViewCell new];
}

- (UIView *)barView
{
    if (!_barView)
    {
        _barView = [[UIView alloc] init];
        _barView.backgroundColor = UIColor.whiteColor;
        _barView.layer.shadowColor = [UIColor colorWithWhite:0.6 alpha:0.6].CGColor;
        _barView.layer.shadowOffset = CGSizeMake(0, 1);
        _barView.layer.shadowRadius = 1;
        _barView.layer.shadowOpacity = 0.3;
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
        _textField.tintColor = [UIColor orangeColor];
        _textField.font = [UIFont systemFontOfSize:14];
        _textField.textColor = [UIColor lz_colorWithHex:0x666666];
        _textField.placeholder = @"请输入地址";
        [_textField becomeFirstResponder];
        
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
        [_cancelBtn setTitleColor:[UIColor lz_colorWithHex:0x999999] forState:UIControlStateNormal];
        _cancelBtn.titleLabel.font = [UIFont systemFontOfSize:13];
        [self.barView addSubview:_cancelBtn];
    }
    return _cancelBtn;
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:self.view.bounds style:UITableViewStylePlain];
        _tableView.separatorColor = [UIColor lz_colorWithHex:0xececec];
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44.0f;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        [self.view addSubview:_tableView];
    }
    
    return _tableView;
}



@end
