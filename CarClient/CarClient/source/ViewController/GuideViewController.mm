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
#import <BaiduMapKit/BaiduMapAPI_Search/BMKSearchComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Utils/BMKUtilsComponent.h>
#import <BaiduMapKit/BaiduMapAPI_Search/BMKGeocodeSearch.h>
#import <BMKLocationkit/BMKLocationManager.h>
#import "LocationPointModel.h"
#import <Masonry/Masonry.h>
#import "UIColor+Extension.h"



@interface GuideViewController ()<BMKMapViewDelegate,BMKRouteSearchDelegate>

@property (nonatomic, strong)BMKMapView *mapView;
@property (nonatomic, strong)BMKRouteSearch *routeSearch;
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

- (void)routePlan
{
    //起点
    BMKPlanNode *startPoint = [[BMKPlanNode alloc] init];
    startPoint.pt = self.startLocation.coordinate2D;
    
    BMKPlanNode *endPoint = [[BMKPlanNode alloc] init];
    endPoint.pt = self.endLocation.coordinate2D;
    
    
    BMKDrivingRoutePlanOption *drivingRouteSearchOption = [[BMKDrivingRoutePlanOption alloc]init];
    drivingRouteSearchOption.from = startPoint;
    drivingRouteSearchOption.to = endPoint;
    
    [self.routeSearch drivingSearch:drivingRouteSearchOption];
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
    [self routePlan];
}

- (void)onGetDrivingRouteResult:(BMKRouteSearch*)searcher
                         result:(BMKDrivingRouteResult*)result
                      errorCode:(BMKSearchErrorCode)error
{
    [_mapView removeOverlays:_mapView.overlays];
    
    if (error == BMK_SEARCH_NO_ERROR){
        
        __block NSUInteger pointCount = 0;
        
        //获取所有驾车路线中第一条路线
        BMKDrivingRouteLine *routeline = (BMKDrivingRouteLine *)result.routes[0];
        
        //遍历驾车路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取驾车路线中的每条路段
            BMKDrivingStep *step = routeline.steps[idx];
            pointCount += step.pointsCount;
        }];
        
        //+polylineWithPoints: count:指定的直角坐标点数组
        BMKMapPoint *points = new BMKMapPoint[pointCount];
        __block NSUInteger j = 0;
        //遍历驾车路线中的所有路段
        [routeline.steps enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
            //获取驾车路线中的每条路段
            BMKDrivingStep *step = routeline.steps[idx];
            //遍历每条路段所经过的地理坐标集合点
            for (NSUInteger i = 0; i < step.pointsCount; i ++) {
                //将每条路段所经过的地理坐标点赋值给points
                points[j].x = step.points[i].x;
                points[j].y = step.points[i].y;
                j ++;
            }
        }];
        
        //根据指定直角坐标点生成一段折线
        BMKPolyline *polyline = [BMKPolyline polylineWithPoints:points count:pointCount];
        /**
         向地图View添加Overlay，需要实现BMKMapViewDelegate的-mapView:viewForOverlay:方法
         来生成标注对应的View
         
         @param overlay 要添加的overlay
         */
        [_mapView addOverlay:polyline];
        //根据polyline设置地图范围
        [self mapViewFitPolyline:polyline withMapView:self.mapView];
    }
}
//根据polyline设置地图范围
- (void)mapViewFitPolyline:(BMKPolyline *)polyline withMapView:(BMKMapView *)mapView
{
    double leftTop_x, leftTop_y, rightBottom_x, rightBottom_y;
    if (polyline.pointCount < 1) {
        return;
    }
    BMKMapPoint pt = polyline.points[0];
    leftTop_x = pt.x;
    leftTop_y = pt.y;
    //左上方的点lefttop坐标（leftTop_x，leftTop_y）
    rightBottom_x = pt.x;
    rightBottom_y = pt.y;
    //右底部的点rightbottom坐标（rightBottom_x，rightBottom_y）
    for (int i = 1; i < polyline.pointCount; i++) {
        BMKMapPoint point = polyline.points[i];
        if (point.x < leftTop_x) {
            leftTop_x = point.x;
        }
        if (point.x > rightBottom_x) {
            rightBottom_x = point.x;
        }
        if (point.y < leftTop_y) {
            leftTop_y = point.y;
        }
        if (point.y > rightBottom_y) {
            rightBottom_y = point.y;
        }
    }
    BMKMapRect rect;
    rect.origin = BMKMapPointMake(leftTop_x , leftTop_y);
    rect.size = BMKMapSizeMake(rightBottom_x - leftTop_x, rightBottom_y - leftTop_y);
    UIEdgeInsets padding = UIEdgeInsetsMake(20, 10, 20, 10);
    [mapView fitVisibleMapRect:rect edgePadding:padding withAnimated:YES];
}

static NSString *annotationViewIdentifier = @"com.Baidu.BMKDrivingRouteSearch";

#pragma mark - BMKMapViewDelegate
/**
 根据anntation生成对应的annotationView
 
 @param mapView 地图View
 @param annotation 指定的标注
 @return 生成的标注View
 */
- (BMKAnnotationView *)mapView:(BMKMapView *)mapView viewForAnnotation:(id<BMKAnnotation>)annotation {
    if ([annotation isKindOfClass:[BMKPointAnnotation class]]) {
        /**
         根据指定标识查找一个可被复用的标注，用此方法来代替新创建一个标注，返回可被复用的标注
         */
        BMKPinAnnotationView *annotationView = (BMKPinAnnotationView *)[mapView dequeueReusableAnnotationViewWithIdentifier:annotationViewIdentifier];
        if (!annotationView) {
            /**
             初始化并返回一个annotationView
             
             @param annotation 关联的annotation对象
             @param reuseIdentifier 如果要重用view，传入一个字符串，否则设为nil，建议重用view
             @return 初始化成功则返回annotationView，否则返回nil
             */
            annotationView = [[BMKPinAnnotationView alloc] initWithAnnotation:annotation reuseIdentifier:annotationViewIdentifier];
            NSBundle *bundle = [NSBundle bundleWithPath:[[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:@"mapapi.bundle"]];
            NSString *file = [[bundle resourcePath] stringByAppendingPathComponent:@"images/icon_nav_bus"];
            //annotationView显示的图片，默认是大头针
            annotationView.image = [UIImage imageWithContentsOfFile:file];
        }
        return annotationView;
    }
    return nil;
}

/**
 根据overlay生成对应的BMKOverlayView
 
 @param mapView 地图View
 @param overlay 指定的overlay
 @return 生成的覆盖物View
 */
- (BMKOverlayView *)mapView:(BMKMapView *)mapView viewForOverlay:(id<BMKOverlay>)overlay {
    if ([overlay isKindOfClass:[BMKPolyline class]]) {
        //初始化一个overlay并返回相应的BMKPolylineView的实例
        BMKPolylineView *polylineView = [[BMKPolylineView alloc] initWithOverlay:overlay];
        //设置polylineView的填充色
        polylineView.fillColor = [[UIColor cyanColor] colorWithAlphaComponent:1];
        //设置polylineView的画笔（边框）颜色
        polylineView.strokeColor = [[UIColor blueColor] colorWithAlphaComponent:0.7];
        //设置polygonView的线宽度
        polylineView.lineWidth = 2.0;
        return polylineView;
    }
    return nil;
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

- (BMKRouteSearch *)routeSearch
{
    if (!_routeSearch)
    {
        _routeSearch = [[BMKRouteSearch alloc] init];
        _routeSearch.delegate = self;
    }
    return _routeSearch;
}

@end
