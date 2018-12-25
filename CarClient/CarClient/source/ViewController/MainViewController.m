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
#import <ReactiveCocoa/ReactiveCocoa.h>
#import "UINavigationController+FDFullscreenPopGesture.h"
#import "StartEndPointView.h"
#import "UIColor+Extension.h"
#import "SideView.h"
#import "LocationPointModel.h"


@interface MainViewController ()<BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong)UIImageView *pointImage;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) UIButton *locationBtn;
@property (nonatomic, strong) UIButton *userHeadBtn;

@property (nonatomic, strong)StartEndPointView *bottomView;

@property (nonatomic, copy) NSString *startAddress;
@property (nonatomic, assign) BOOL isAlertViewPop;


@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.isAlertViewPop = NO;
    self.fd_prefersNavigationBarHidden = YES;
    
    [[BaiduMapAuthManager sharedInstance] start:^(BOOL result, NSString *errorMessage) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (result) {
                [self.mapView mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.left.right.top.equalTo(self.view);
                    if (@available(iOS 11.0, *)) {
                        make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom);
                    } else {
                        make.bottom.equalTo(self.view.mas_bottom);
                    }
                }];
                [self setupUI];
            }
            [self.locationManager startUpdatingLocation];
        });
    }];
    
}

- (void)setupUI
{
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.right.equalTo(self.view.mas_right).offset(-10);
        if (@available(iOS 11.0, *)) {
            make.bottom.equalTo(self.view.mas_safeAreaLayoutGuideBottom).offset(-10);
        } else {
             make.bottom.equalTo(self.view.mas_bottom).offset(-10);
        }
        make.height.offset(90);
    }];
    
    [self.userHeadBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        if (@available(iOS 11.0, *)) {
            make.top.equalTo(self.view.mas_safeAreaLayoutGuideTop).offset(20);
        } else {
            make.top.equalTo(self.view.mas_top).offset(20);
        }
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
    
    [self.locationBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.view.mas_left).offset(10);
        make.bottom.equalTo(self.bottomView.mas_top).offset(-20);
        make.size.mas_equalTo(CGSizeMake(40, 40));
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

- (void)reFixLocation
{
    [self.locationManager startUpdatingLocation];
}

- (void)onUserHead
{
    SideView *sideView = [[SideView alloc] initWithFrame:self.view.frame];
    
    [self.view addSubview:sideView];
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager didFailWithError:(NSError * _Nullable)error
{
    if (self.isAlertViewPop) {
        return;
    }
    
    if([CLLocationManager authorizationStatus] == kCLAuthorizationStatusDenied){
        
        self.isAlertViewPop = YES;
        
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:@"请打开手机定位使用此功能" preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *open = [UIAlertAction actionWithTitle:@"设置" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            
            if ([[UIApplication sharedApplication] canOpenURL:url]) {
                [[UIApplication sharedApplication] openURL:url];
            }
        }];
        
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
            
        }];
        
        [alert addAction:open];
        [alert addAction:cancel];
        
        [self.navigationController presentViewController:alert animated:YES completion:nil];
    }
}

- (void)BMKLocationManager:(BMKLocationManager * _Nonnull)manager
         didUpdateLocation:(BMKLocation * _Nullable)location
                   orError:(NSError * _Nullable)error
{
    [self.locationManager stopUpdatingLocation];
    [self.mapView setCenterCoordinate:location.location.coordinate];
}

- (void)mapView:(BMKMapView *)mapView regionDidChangeAnimated:(BOOL)animated
{
    self.centerCoordinate =  mapView.centerCoordinate;
    self.pointImage.hidden = NO;
    
    self.bottomView.startLocation.coordinate2D = self.centerCoordinate;
    
    BMKReverseGeoCodeSearchOption *reverseGeoCodeSearchOption = [[BMKReverseGeoCodeSearchOption alloc]init];
    reverseGeoCodeSearchOption.location = mapView.centerCoordinate;
    [self.searcher reverseGeoCode:reverseGeoCodeSearchOption];
}

- (void)onGetReverseGeoCodeResult:(BMKGeoCodeSearch *)searcher
                           result:(BMKReverseGeoCodeSearchResult *)result
                        errorCode:(BMKSearchErrorCode)error
{
    if (error == BMK_SEARCH_NO_ERROR) {
        self.startAddress = result.sematicDescription;
        self.bottomView.startLocation.address = result.sematicDescription;
    } else {
        NSLog(@"error======%d",error);
    }
}

- (BMKLocationManager *)locationManager
{
    if (_locationManager == nil) {
        _locationManager = [[BMKLocationManager alloc] init];
        _locationManager.delegate = self;
    }
    return _locationManager;
}

- (UIButton *)locationBtn
{
    if (_locationBtn == nil) {
        _locationBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        _locationBtn.backgroundColor = UIColor.whiteColor;
        _locationBtn.layer.cornerRadius = 20;
        [_locationBtn addTarget:self action:@selector(reFixLocation) forControlEvents:UIControlEventTouchUpInside];
        _locationBtn.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _locationBtn.layer.borderColor = [UIColor lz_colorWithHex:0xE5E5E5].CGColor;
        [_locationBtn setImage:[UIImage imageNamed:@"bleBox_map_fresh"] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"bleBox_map_fresh"] forState:UIControlStateHighlighted];
        [self.view addSubview:_locationBtn];
    }
    
    return _locationBtn;
}

- (UIButton *)userHeadBtn
{
    if (_userHeadBtn == nil) {
        _userHeadBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_userHeadBtn addTarget:self action:@selector(onUserHead) forControlEvents:UIControlEventTouchUpInside];
        [_userHeadBtn setImage:[UIImage imageNamed:@"small-head"] forState:UIControlStateNormal];
        [_userHeadBtn setImage:[UIImage imageNamed:@"small-head"] forState:UIControlStateHighlighted];
        [self.view addSubview:_userHeadBtn];
    }
    
    return _userHeadBtn;
}

- (UIImageView *)pointImage
{
    if (_pointImage == nil) {
        _pointImage = [[UIImageView alloc] init];
        _pointImage.image = [UIImage imageNamed:@"bleBox_map_center"];
        _pointImage.hidden = YES;
        _pointImage.bounds = CGRectMake(0, 0, 15, 25);
        _pointImage.center = self.view.center;
        [self.view addSubview:_pointImage];
    }
    
    return _pointImage;
}

- (BMKGeoCodeSearch *)searcher
{
    if (_searcher == nil) {
        _searcher =[[BMKGeoCodeSearch alloc]init];
        _searcher.delegate = self;
    }
    
    return _searcher;
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
        
        BMKLocationViewDisplayParam *param = [[BMKLocationViewDisplayParam alloc] init];
        param.isAccuracyCircleShow = NO;
        [_mapView updateLocationViewWithParam:param];
        
        [self.view addSubview:_mapView];
    }
    return _mapView;
}

- (StartEndPointView *)bottomView
{
    if (!_bottomView)
    {
        _bottomView = [[StartEndPointView alloc] init];
        [self.view addSubview:_bottomView];
    }
    return _bottomView;
}


@end
