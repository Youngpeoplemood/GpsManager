//
//  FMGpsManager.h
//  FMGpsManger
//
//  Created by YFM on 2018/7/25.
//  Copyright © 2018年 iOS. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface FMGpsManager : NSObject

+ (instancetype) sharedGpsManager;

-(void)getLoctationSuccuss:(void(^)(CGFloat lng, CGFloat lat , NSDictionary *addressDic)) succuss andFaild:(void(^)()) faild;

@end
