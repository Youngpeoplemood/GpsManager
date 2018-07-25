//
//  ViewController.m
//  FMGpsManger
//
//  Created by YFM on 2018/7/25.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import "ViewController.h"

#import "FMGpsManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *lngLabel;//经度
@property (weak, nonatomic) IBOutlet UILabel *latLabel;//纬度

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self getLocation];
}

#pragma mark === 获取当前位置(模拟器无法获取当前位置,需使用真机)
-(void)getLocation
{
    [[FMGpsManager sharedGpsManager] getLoctationSuccuss:^(CGFloat lng, CGFloat lat, NSDictionary *addressDic) {
        NSLog(@"您当前的位置是%@\n经纬度:%.6f\n%.6f",addressDic,lng,lat);
        self.lngLabel.text = [NSString stringWithFormat:@"%.6f",lng];
        self.latLabel.text = [NSString stringWithFormat:@"%.6f",lat];
    } andFaild:^{
        NSLog(@"经纬度获取失败了.....");
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
