//
//  BMKPointCell.m
//  CarClient
//
//  Created by 栗志 on 2018/12/29.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "BMKPointCell.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"

@interface BMKPointCell()

@property (nonatomic, strong)UILabel *nameLabel;
@property (nonatomic, strong)UILabel *distanceLabel;
@property (nonatomic, strong)UILabel *addressLabel;
@property (nonatomic, strong)UIImageView *poiIcon;

@end

@implementation BMKPointCell

+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    BMKPointCell *cell = [tableView dequeueReusableCellWithIdentifier:NSStringFromClass([BMKPointCell class])];
    if (cell == nil) {
        cell = [[BMKPointCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:NSStringFromClass([BMKPointCell class])];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setupSubviews];
    }
    
    return self;
}

- (void)setupSubviews
{
    [self.poiIcon mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.contentView.mas_centerY);
        make.left.equalTo(self.contentView.mas_left).with.offset(15);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
    
    
    [self.nameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.poiIcon.mas_right).with.offset(10);
        make.bottom.equalTo(self.contentView.mas_centerY).offset(-4);
    }];
    
    [self.distanceLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.poiIcon.mas_right).with.offset(10);
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
    }];
    
    [self.addressLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.distanceLabel.mas_right).with.offset(4);
        make.right.equalTo(self.contentView.mas_right).offset(-2);
        make.top.equalTo(self.contentView.mas_centerY).offset(4);
    }];
    
    
}

- (void)setModel:(BMKPoiInfo *)model
{
    _model = model;
    
    self.nameLabel.text = model.name;
    self.addressLabel.text = model.address;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel)
    {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.font = [UIFont systemFontOfSize:15];
        _nameLabel.textColor = [UIColor lz_colorWithHex:0x333333];
        [self.contentView addSubview:_nameLabel];
    }
    return _nameLabel;
}

- (UILabel *)distanceLabel
{
    if (!_distanceLabel)
    {
        _distanceLabel = [[UILabel alloc] init];
        _distanceLabel.font = [UIFont systemFontOfSize:12];
        _distanceLabel.textColor = [UIColor lz_colorWithHex:0x999999];
        [self.contentView addSubview:_distanceLabel];
    }
    return _distanceLabel;
}

- (UILabel *)addressLabel
{
    if (!_addressLabel)
    {
        _addressLabel = [[UILabel alloc] init];
        _addressLabel.font = [UIFont systemFontOfSize:12];
        _addressLabel.textColor = [UIColor lz_colorWithHex:0x999999];
        [self.contentView addSubview:_addressLabel];
    }
    return _addressLabel;
}

- (UIImageView *)poiIcon
{
    if (!_poiIcon)
    {
        _poiIcon = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"FFPangu/choice"]];
        [self.contentView addSubview:_poiIcon];
    }
    return _poiIcon;
}

@end
