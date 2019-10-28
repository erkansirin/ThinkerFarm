//
//  TFObjectDetection.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFObjectDetectionDelegate.h"




NS_ASSUME_NONNULL_BEGIN

@interface TFObjectDetection : NSObject

- (NSMutableArray*)detectObject:(UIImage*)image;


@property id <TFObjectDetectionDelegate> _Nonnull delegate;

@end

NS_ASSUME_NONNULL_END


