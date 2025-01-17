//
//  SideView.m
//  CarClient
//
//  Created by 栗志 on 2018/12/19.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "SideView.h"
#import <objc/message.h>
#import "UIColor+Extension.h"
#import <Masonry.h>
#import "SideCellModel.h"
#import "UIColor+Extension.h"
#import "UrlSchemeManager.h"
#import "AppDelegate.h"


@interface SideView()<UITableViewDelegate,UITableViewDataSource>

@property(nonatomic,strong)UIControl *bg;
@property(nonatomic,strong)UITableView *tableView;

@property(nonatomic,strong)NSArray <SideCellModel*> *models;

@end

@implementation SideView

- (NSArray *)models
{
    if (!_models)
    {
        _models = @[
                    [[SideCellModel alloc] initWithImage:@"history" title:@"我的行程" action:@selector(onMyHistory)],
                    [[SideCellModel alloc] initWithImage:@"service" title:@"客服电话" action:@selector(onServiceCall)],
                    [[SideCellModel alloc] initWithImage:@"help" title:@"使用帮助" action:@selector(onHelp)],
                    [[SideCellModel alloc] initWithImage:@"setting" title:@"设置" action:@selector(onSetting)],
                    ];
    }
    return _models;
}

- (void)onMyHistory
{
    AppDelegate *delegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    
    [[UrlSchemeManager sharedInstance] pushViewControllerWithControllerName:@"RecordViewController"
                                                                  navigator:[delegate navigation]
                                                                     params:nil];
}

- (void)onServiceCall
{
    
}

- (void)onHelp
{
    
}

- (void)onSetting
{
    
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self setupSubviews];
}

- (void)setupSubviews
{
    [self.bg mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
    
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.bg);
        make.right.equalTo(self.bg.mas_right).offset(-60);
    }];
}

- (void)onDismess
{
    [self removeFromSuperview];
}

- (UIView *)headerView
{
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 0, 120)];
    header.backgroundColor = UIColor.whiteColor;
    
    UIImageView *imageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"big-head"]];
    [header addSubview:imageView];
    
    UILabel *label = [[UILabel alloc] init];
    label.text = @"136****6788";
    label.font = [UIFont systemFontOfSize:15];
    label.textColor = [UIColor lz_colorWithHex:0x333333];
    [header addSubview:label];
    
    [imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.mas_centerX);
        make.centerY.equalTo(header.mas_centerY).offset(-10);
        make.size.mas_equalTo(CGSizeMake(60, 60));
    }];
    
    [label mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(header.mas_centerX);
        make.top.equalTo(imageView.mas_bottom).offset(10);
    }];
    
    return header;
}



- (nonnull UITableViewCell *)tableView:(nonnull UITableView *)tableView
                 cellForRowAtIndexPath:(nonnull NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"UITableViewCell"];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.textLabel.textColor = [UIColor lz_colorWithHex:0x333333];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    
    SideCellModel *model = self.models[indexPath.row];
    cell.textLabel.text = model.title;
    cell.imageView.image = [UIImage imageNamed:model.imageName];
    
    return cell;
}

- (NSInteger)tableView:(nonnull UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.models.count;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    SideCellModel *model = self.models[indexPath.row];
    if ([self respondsToSelector:model.action]) {
        ((void(*)(id, SEL))objc_msgSend)(self, model.action);
    }
}

- (UITableView *)tableView
{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
        _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        _tableView.delegate = self;
        _tableView.dataSource = self;
        _tableView.rowHeight = 44;
        _tableView.showsHorizontalScrollIndicator = NO;
        _tableView.showsVerticalScrollIndicator = NO;
        _tableView.tableFooterView = [UIView new];
        _tableView.tableHeaderView = [self headerView];
        [self.bg addSubview:_tableView];
    }
    return _tableView;
}

- (UIControl *)bg
{
    if (!_bg)
    {
        _bg = [[UIControl alloc] init];
        _bg.backgroundColor = [UIColor colorWithWhite:0.7 alpha:0.3];
        [_bg addTarget:self action:@selector(onDismess) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_bg];
    }
    return _bg;
}

@end
