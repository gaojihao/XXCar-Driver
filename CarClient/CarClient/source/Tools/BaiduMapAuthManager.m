//
//  BaiduMapAuthManager.m
//  CarClient
//
//  Created by 栗志 on 2018/12/16.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "BaiduMapAuthManager.h"
#import <BaiduMapAPI_Base/BMKMapManager.h>
#import <BaiduMapAPI_Base/BMKGeneralDelegate.h>

static NSString *baiduMapKey = @"6RIE3mfXViqcHGGrTjwa2CG99TYqjYyd";

@interface BaiduMapAuthManager()<BMKGeneralDelegate>

@property (nonatomic, strong) BMKMapManager *mapManager;
@property (nonatomic, copy) BaiduMapPrepareBlock prepareBlock;

@property (nonatomic, assign) BOOL isPrepareOK;

@end


@implementation BaiduMapAuthManager

+ (instancetype)sharedInstance
{
    static BaiduMapAuthManager *sharedinstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedinstance = [[BaiduMapAuthManager alloc] init];
    });
    return sharedinstance;
}

- (void)start:(BaiduMapPrepareBlock)block
{
    if (self.mapManager == nil) {
        self.mapManager = [BMKMapManager new];
    }
    
    self.prepareBlock = [block copy];
    
    if (self.isPrepareOK) {
        if(self.prepareBlock )
        {
            self.prepareBlock(YES, nil);
        }
        return;
    } else {
        BOOL ret = [self.mapManager start:baiduMapKey generalDelegate:self];
        if (!ret) {
            self.prepareBlock(NO, @"manager start failed!");
        }
    }
}

- (void)stop
{
    if (self.mapManager) {
        [self.mapManager stop];
    }
    self.isPrepareOK = NO;
    self.prepareBlock = nil;
}

- (void)onGetNetworkState:(int)iError
{
    if (iError != 0) {
        
        if(self.prepareBlock)
        {
            self.prepareBlock(NO, @"联网失败");
        }
    }
}

- (void)onGetPermissionState:(int)iError
{
    if (0 == iError) {
        if(self.prepareBlock)
        {
            self.prepareBlock(YES, nil);
        }
        self.isPrepareOK = YES;
    } else {
        if(self.prepareBlock)
        {
            self.prepareBlock(NO, @"授权失败");
        }
    }
}

@end
