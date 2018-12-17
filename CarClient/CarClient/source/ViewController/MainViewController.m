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


@interface MainViewController ()<BMKMapViewDelegate,BMKLocationManagerDelegate,BMKGeoCodeSearchDelegate>

@property (nonatomic, strong) BMKMapView *mapView;
@property (nonatomic, strong) BMKLocationManager *locationManager;
@property (nonatomic) CLLocationCoordinate2D centerCoordinate;
@property (nonatomic, strong)BMKPointAnnotation *point;
@property (nonatomic, strong)BMKGeoCodeSearch *searcher;
@property (nonatomic, strong) UIButton *locationBtn;

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
    self.point.coordinate = self.centerCoordinate;
    
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
    } else {
        NSLog(@"error======%d",error);
    }
}


- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id <BMKAnnotation>)annotation
{
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        BMKAnnotationView *newAnnotationView = [[BMKAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:@"myAnnotation"];
        newAnnotationView.image = [UIImage imageNamed:@"bleBox_map_center"];
        return newAnnotationView;
    }
    return nil;
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
        [_locationBtn setImage:[UIImage imageNamed:@"bleBox_map_fresh"] forState:UIControlStateNormal];
        [_locationBtn setImage:[UIImage imageNamed:@"bleBox_map_fresh"] forState:UIControlStateHighlighted];
        [self.view addSubview:_locationBtn];
    }
    
    return _locationBtn;
}

- (BMKPointAnnotation *)point
{
    if (_point == nil) {
        _point = [[BMKPointAnnotation alloc] init];
        
        [self.mapView addAnnotation:_point];
    }
    
    return _point;
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


@end
