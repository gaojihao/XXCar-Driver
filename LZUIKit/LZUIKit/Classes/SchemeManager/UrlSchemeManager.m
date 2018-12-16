//
//  UrlSchemeManager.m
//  xingyujiaoyu
//
//  Created by 栗志 on 2018/4/2.
//  Copyright © 2018年 com.lizhi1026. All rights reserved.
//

#import "UrlSchemeManager.h"
#import "UINavigationController+FDFullscreenPopGesture.h"


@implementation UrlSchemeManager

+ (instancetype)sharedInstance
{
    static UrlSchemeManager *sharedinstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedinstance = [[UrlSchemeManager alloc] init];
    });
    return sharedinstance;
}

- (void)pushViewControllerWithControllerName:(NSString *)viewControllerName
                                   navigator:(UINavigationController *)navigator
                                      params:(NSDictionary *)params
{
    UIViewController *viewController = [self viewControllerWithViewControllerName:viewControllerName params:params];
    
    if (!viewController)
    {
        NSAssert(NO, @"%@不存在",viewControllerName);
        return;
    }
    else
    {
        return [navigator pushViewController:viewController animated:YES];
    }
}

- (UIViewController *)viewControllerWithViewControllerName:(NSString *)viewControllerName params:(NSDictionary *)params
{
    if (!viewControllerName) {
        return nil;
    }
    
    Class class = NSClassFromString(viewControllerName);
    UIViewController *viewController =  [(UIViewController *)[class alloc] init];
    
    if ([params.allKeys count] > 0) {
        
        for (NSString *key in params.allKeys) {
            id value = [params objectForKey:key];
            [viewController safeSetParamsValue:value forKey:key];
        }
    }
    
    return viewController;
    
}


@end
