//
//  BMKPointCell.h
//  CarClient
//
//  Created by 栗志 on 2018/12/29.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <BaiduMapAPI_Search/BMKPoiSearchType.h>


NS_ASSUME_NONNULL_BEGIN

@interface BMKPointCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

@property (nonatomic, strong) BMKPoiInfo *model;

@end

NS_ASSUME_NONNULL_END
