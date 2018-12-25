//
//  LocationPointModel.h
//  CarClient
//
//  Created by 栗志 on 2018/12/25.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LocationPointModel : NSObject

@property(nonatomic,copy)NSString *address;
@property(nonatomic,assign)CLLocationCoordinate2D coordinate2D;

@end

NS_ASSUME_NONNULL_END
