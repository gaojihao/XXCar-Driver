//
//  AppDelegate.m
//  CarClient
//
//  Created by 栗志 on 2018/12/12.
//  Copyright © 2018 lizhi.1026.com. All rights reserved.
//

#import "AppDelegate.h"
#import "MainViewController.h"

@interface AppDelegate ()

@property(nonatomic,strong)UINavigationController *navigationController;

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = UIColor.whiteColor;
    [self.window makeKeyAndVisible];
    
    MainViewController *vc = [[MainViewController alloc] init];
    
    self.navigationController = [[UINavigationController alloc] initWithRootViewController:vc];
    
    self.window.rootViewController = self.navigationController;
    
    return YES;
}

- (UINavigationController*)navigation
{
    return self.navigationController;
}


@end
