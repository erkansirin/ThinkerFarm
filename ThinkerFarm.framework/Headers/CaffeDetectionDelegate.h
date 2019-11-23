//
//  TFObjectDetectionDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

static NSString * _Nonnull const TFOBJECTDETECTION_DOMAIN = @"TFObjectDetection";


@protocol CaffeDetectionDelegate <NSObject>


- (void) didFinishDetectiong;


@end
