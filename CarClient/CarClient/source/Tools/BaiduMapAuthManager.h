//
//  BaiduMapAuthManager.h
//  CarClient
//
//  Created by 栗志 on 2018/12/16.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^BaiduMapPrepareBlock)(BOOL result, NSString *errorMessage);

NS_ASSUME_NONNULL_BEGIN

@interface BaiduMapAuthManager : NSObject

+ (instancetype)sharedInstance;

- (void)start:(BaiduMapPrepareBlock)block;

- (void)stop;

@end

NS_ASSUME_NONNULL_END
