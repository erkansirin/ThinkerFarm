//
//  TFObjectDetection.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "CaffeDetectionDelegate.h"




NS_ASSUME_NONNULL_BEGIN

@interface CaffeDetection : NSObject

- (NSMutableArray*)detectObject:(UIImage*)image;



-(instancetype)initWithCaffeModels:(NSString*)CaffeModel Prototext:(NSString*)Prototext Treshold:(float)treshold inputWidth:(int)inputWidth inputHeight:(int)inputHeight modelLabelMap:(NSString*)modelLabelMap imageBlobScalefactor:(float)imageBlobScalefactor imageBlobMeanScalar:(NSArray*)imageBlobMeanScalar imageBlobSwapRB:(BOOL)imageBlobSwapRB imageBlobCrop:(BOOL)imageBlobCrop;


@property id <CaffeDetectionDelegate> _Nonnull delegate;

@end

NS_ASSUME_NONNULL_END


