//
//  FMGpsManager.m
//  FMGpsManger
//
//  Created by YFM on 2018/7/25.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "FMGpsManager.h"

#import <CoreLocation/CoreLocation.h>


static FMGpsManager *gps = nil;

@interface FMGpsManager ()
<
CLLocationManagerDelegate
>
@property(nonatomic ,copy) void(^succuss)(CGFloat lng, CGFloat lat , NSDictionary *addressDic) ;
@property(nonatomic ,copy) void(^failed)();
@property(nonatomic, assign) CLLocationCoordinate2D userCoordinate;
@property(nonatomic, strong) CLGeocoder  *geocoder;
@property(nonatomic ,strong) CLLocationManager * locationManager;

@end

@implementation FMGpsManager


static FMGpsManager  *_instance;

+ (instancetype)sharedGpsManager
{
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[FMGpsManager alloc] init];
    });
    return _instance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setUpLocationManager];
    }
    return self;
}


-(void)getLoctationSuccuss:(void(^)( CGFloat lng, CGFloat lat , NSDictionary *addressDic)) succuss andFaild:(void(^)()) faild
{
    gps = [[FMGpsManager alloc]init];
    if (succuss) {
        gps.succuss = succuss;
    }
    
    if (faild) {
        gps.failed =faild;
    }
}


- (void)setUpLocationManager {
    
    _locationManager = [[CLLocationManager alloc] init];
    [_locationManager requestWhenInUseAuthorization];  //requestAlwaysAuthorization  后台持续定位
    _locationManager.distanceFilter = kCLDistanceFilterNone;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    //若不设置 app会在进入后台20分钟后停止(持续定位会用到)
    //    self.locationManager.pausesLocationUpdatesAutomatically = NO;
    //    if (@available(iOS 9.0, *)) {
    //        self.locationManager.allowsBackgroundLocationUpdates = YES;
    //    }
    _geocoder = [[CLGeocoder alloc]init];
    
    [self startLoaction];
    
}


- (void)startLoaction
{
    if ([CLLocationManager locationServicesEnabled] &&
        (([CLLocationManager authorizationStatus] != kCLAuthorizationStatusRestricted) &&
         ([CLLocationManager authorizationStatus] != kCLAuthorizationStatusDenied))) {
            _locationManager.distanceFilter  = kCLDistanceFilterNone;    //距离筛选器，单位米（移动多少米才回调更新）
            _locationManager.desiredAccuracy = kCLLocationAccuracyBest; //精确度
            [_locationManager setDelegate:self];
            [_locationManager startUpdatingLocation];
        }else{
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@""
                                                            message:@"定位服务未开启\n请在系统设置中开启定位服务"
                                                           delegate:nil
                                                  cancelButtonTitle:@"确定"
                                                  otherButtonTitles:nil];
            [alert show];
        }
    
}


#pragma mark – CLLocationManagerDelegate
//定位成功回调
- (void)locationManager:(CLLocationManager *)manager
     didUpdateLocations:(NSArray<CLLocation *> *)locations
{
    CLLocation *newLocation = locations.firstObject;
    _userCoordinate = CLLocationCoordinate2DMake(newLocation.coordinate.latitude, newLocation.coordinate.longitude);
    [_locationManager stopUpdatingLocation];
    
    [_geocoder reverseGeocodeLocation:newLocation completionHandler:^(NSArray<CLPlacemark *> * _Nullable placemarks, NSError * _Nullable error) {
        // 如果解析结果的集合元素的个数大于1，表明解析得到了经度、纬度信息
        if (placemarks.count > 0) {
            // 只处理第一个解析结果，实际项目可使用列表让用户选择
            CLPlacemark* placemark = placemarks[0];
            // 获取详细地址信息
            gps.succuss(self.userCoordinate.longitude,self.userCoordinate.latitude,placemark.addressDictionary);
            self.locationManager.delegate = nil;
        }
    }];
}

//定位失败回调
- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    
    gps.failed();
    _locationManager.delegate = nil;
}
@end
