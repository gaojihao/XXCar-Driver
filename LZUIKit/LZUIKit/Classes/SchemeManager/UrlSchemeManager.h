//
//  UrlSchemeManager.h
//  xingyujiaoyu
//
//  Created by 栗志 on 2018/4/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

#import <Foundation/Foundation.h>

#define LZ_Push(vcName,navigator,params) \
[[UrlSchemeManager sharedInstance] pushViewControllerWithControllerName:(vcName) navigator:(navigator) params:(params)];

#define LZ_Scheme   [UrlSchemeManager sharedInstance]

@interface UrlSchemeManager : NSObject

+ (instancetype)sharedInstance;

- (void)pushViewControllerWithControllerName:(NSString *)viewControllerName
                                   navigator:(UINavigationController *)navigator
                                      params:(NSDictionary *)params;

@end
