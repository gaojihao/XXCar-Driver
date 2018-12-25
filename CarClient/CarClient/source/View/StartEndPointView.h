//
//  StartEndPointView.h
//  CarClient
//
//  Created by 栗志 on 2018/12/22.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class LocationPointModel;

NS_ASSUME_NONNULL_BEGIN

@interface StartEndPointView : UIView

@property (nonatomic, strong)LocationPointModel *startLocation;
@property (nonatomic, strong)LocationPointModel *endLocation;

@end

NS_ASSUME_NONNULL_END
