//
//  StartEndPointView.m
//  CarClient
//
//  Created by 栗志 on 2018/12/22.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "StartEndPointView.h"
#import <Masonry.h>
#import "UIColor+Extension.h"
#import "LocationPointModel.h"
#import <ReactiveCocoa.h>

const CGFloat LZ_TextFieldHeight = 44.0f;

@interface StartEndPointView ()<UITextFieldDelegate>

@property(nonatomic,strong)UITextField *startField;
@property(nonatomic,strong)UITextField *endField;

@end

@implementation StartEndPointView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.startLocation = [[LocationPointModel alloc] init];
        self.endLocation = [[LocationPointModel alloc] init];
        [self bindSignal];
    }
    return self;
}

- (void)bindSignal
{
    RAC(self.startField, text) = RACObserve(self.startLocation, address);
    RAC(self.endField, text) = RACObserve(self.endLocation, address);
}

- (void)willMoveToSuperview:(UIView *)newSuperview
{
    [self setupUI];
}

- (void)setupUI
{
    self.backgroundColor = UIColor.whiteColor;
    self.layer.cornerRadius = 4.0f;
    self.layer.masksToBounds = YES;
    
    UIView *line = [[UIView alloc] init];
    line.backgroundColor = [UIColor colorWithRed:0.88 green:0.88 blue:0.88 alpha:1];
    [self addSubview:line];
    
    [line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left).offset(40);
        make.right.equalTo(self.mas_right);
        make.centerY.equalTo(self.mas_centerY);
        make.height.mas_equalTo(1/[UIScreen mainScreen].scale);
    }];
    
    [self.startField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.bottom.equalTo(line.mas_top);
        make.height.mas_equalTo(LZ_TextFieldHeight);
    }];
    
    [self.endField mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.mas_left);
        make.right.equalTo(self.mas_right);
        make.top.equalTo(line.mas_bottom);
        make.height.mas_equalTo(LZ_TextFieldHeight);
    }];
}

- (UITextField *)startField
{
    if (!_startField)
    {
        _startField = [[UITextField alloc] init];
        _startField.delegate = self;
        _startField.borderStyle = UITextBorderStyleNone;
        _startField.font = [UIFont systemFontOfSize:15];
        _startField.placeholder = @"您在哪儿上车";
        _startField.textColor = UIColor.blackColor;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LZ_TextFieldHeight, LZ_TextFieldHeight)];
        leftView.backgroundColor = UIColor.greenColor;
        leftView.layer.borderColor = UIColor.whiteColor.CGColor;
        leftView.layer.borderWidth = 18;
        _startField.leftView = leftView;
        _startField.leftViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:_startField];
    }
    return _startField;
}

- (UITextField *)endField
{
    if (!_endField)
    {
        _endField = [[UITextField alloc] init];
        _endField.delegate = self;
        _endField.borderStyle = UITextBorderStyleNone;
        _endField.font = [UIFont systemFontOfSize:15];
        _endField.placeholder = @"您要去哪儿";
        _endField.textColor = UIColor.blackColor;
        
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, LZ_TextFieldHeight, LZ_TextFieldHeight)];
        leftView.backgroundColor = UIColor.orangeColor;
        leftView.layer.borderColor = UIColor.whiteColor.CGColor;
        leftView.layer.borderWidth = 18;
        _endField.leftView = leftView;
        _endField.leftViewMode = UITextFieldViewModeAlways;
        
        [self addSubview:_endField];
    }
    return _endField;
}


@end
