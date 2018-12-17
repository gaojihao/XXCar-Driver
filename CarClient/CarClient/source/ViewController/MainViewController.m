//
//  MainViewController.m
//  CarClient
//
//  Created by 栗志 on 2018/12/16.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "MainViewController.h"
#import "BaiduMapAuthManager.h"
#import <BaiduMapKit/BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Cloud/BMKCloudSearchComponent.h>
#import <BMKLocationkit/BMKLocationManager.h>
#import <Masonry.h>
#import "UINavigationController+FDFullscreenPopGesture.h"


@interface MainViewController ()<BMKMapViewDelegate,BMKLocationManagerDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.fd_prefersNavigationBarHidden = YES;
    
    [[BaiduMapAuthManager sharedInstance] start:^(BOOL result, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.edges.equalTo(self.view);
                }];
            }
            [self.locationManager startUpdatingLocation];
        });
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    if (_mapView) {
        [_mapView viewWillAppear];
        _mapView.delegate = self; // 此处记得不用的时候需要置nil，否则影响内存的释放
    }
    [super viewWillAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
    if (_mapView) {
        [_mapView viewWillDisappear];
        _mapView.delegate = nil; // 不用时，置nil
    }
    [super viewWillDisappear:animated];
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
         didUpdateLocation:(BMKLocation * _Nullable)location
                   orError:(NSError * _Nullable)error
{
    [self.locationManager stopUpdatingLocation];
    [self.mapView setCenterCoordinate:location.location.coordinate];
}

- (BMKLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}


- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.userTrackingMode = BMKUserTrackingModeFollow;
        _mapView.delegate = self;
        _mapView.zoomEnabled = YES;
        _mapView.zoomEnabledWithTap = YES;
        _mapView.showsUserLocation = YES;
        _mapView.scrollEnabled = YES;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.zoomLevel = 18;
        _mapView.baseIndoorMapEnabled  = YES;
        _mapView.showIndoorMapPoi = YES;
        _mapView.compassPosition = CGPointMake(15, 15);
        
        [self.view addSubview:_mapView];
    }
    return _mapView;
}


@end
