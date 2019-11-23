//
//  TFObjectDetection.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import "CaffeDetection.h"

#import "OpenCVData.h"
#import "ObjectDetection.h"

@interface CaffeDetection ()<CaffeDetectionDelegate>

@end

@implementation CaffeDetection   {
    
    ObjectDetection *objectDetection;
}
-(instancetype)initWithCaffeModels:(NSString*)CaffeModel Prototext:(NSString*)Prototext Treshold:(float)treshold inputWidth:(int)inputWidth inputHeight:(int)inputHeight modelLabelMap:(NSString*)modelLabelMap imageBlobScalefactor:(float)imageBlobScalefactor imageBlobMeanScalar:(NSArray*)imageBlobMeanScalar imageBlobSwapRB:(BOOL)imageBlobSwapRB imageBlobCrop:(BOOL)imageBlobCrop
{
    objectDetection = [[ObjectDetection alloc] initWithCaffeModels:CaffeModel Prototext:Prototext Treshold:treshold inputWidth:inputWidth inputHeight:inputHeight modelLabelMap:modelLabelMap imageBlobScalefactor:imageBlobScalefactor imageBlobMeanScalar:imageBlobMeanScalar imageBlobSwapRB:imageBlobSwapRB imageBlobCrop:imageBlobCrop];
    
    return self;
}
    
-(instancetype) init {
    self = [super init];
    if (self != nil) {
          
    }
    return self;
}
- (NSMutableArray*)detectObject:(UIImage*)image
{
    
    cv::Mat matImg;
    UIImageToMat(image, matImg);
    
    NSMutableArray* matReturn;
    matReturn = [objectDetection detectObjectFromImage:matImg];
   
    return matReturn;
    
}

- (void) didFinishDetectiong{
    
}

@end





