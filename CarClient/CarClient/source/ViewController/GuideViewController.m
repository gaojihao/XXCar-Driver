//
//  GuideViewController.m
//  CarClient
//
//  Created by 栗志 on 2018/12/24.
//  Copyright © 2018年 lizhi.1026.com. All rights reserved.
//

#import "GuideViewController.h"
#import "UINavigationController+FDFullscreenPopGesture.h"
#import <BaiduMapKit/BaiduMapAPI_Base/BMKBaseComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Map/BMKMapComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKPoiSearch.h>
#import <BaiduMapKit/BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BMKLocationkit/BMKLocationManager.h>
#import "LocationPointModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"



@interface GuideViewController ()<BMKMapViewDelegate>

@property (nonatomic, strong) BMKMapView *mapView;

@property (nonatomic, strong)LocationPointModel *startLocation;
@property (nonatomic, strong)LocationPointModel *endLocation;

@end

@implementation GuideViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.fd_prefersNavigationBarHidden = YES;
    self.view.backgroundColor = UIColor.whiteColor;
    [self setupUI];
    
}

- (void)setupUI
{
    [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(self.view);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
        } else {
            make.bottom.equalTo(self.view.mas_bottom);
        }
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


- (void)mapViewDidFinishRendering:(BMKMapView *)mapView
{
    
}

- (BMKMapView *)mapView
{
    if (!_mapView) {
        _mapView = [[BMKMapView alloc] initWithFrame:self.view.bounds];
        _mapView.userTrackingMode = BMKUserTrackingModeNone;
        _mapView.delegate = self;
        _mapView.zoomEnabled = YES;
        _mapView.zoomEnabledWithTap = YES;
        _mapView.showMapScaleBar = YES;
        _mapView.showsUserLocation = YES;
        _mapView.scrollEnabled = YES;
        _mapView.mapType = BMKMapTypeStandard;
        _mapView.zoomLevel = 20;
        
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

@end
