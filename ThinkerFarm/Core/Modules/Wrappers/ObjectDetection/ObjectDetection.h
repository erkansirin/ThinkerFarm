//
//  ObjectDetection.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 22.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/dnn.hpp>
#import <opencv2/imgcodecs/ios.h>
#include <opencv2/imgproc.hpp>
#include <opencv2/highgui.hpp>
#include <opencv2/gapi/own/types.hpp>


#import <iostream>

@interface ObjectDetection : NSObject
{
    
}





- (NSMutableArray*)detectObjectFromImage:(cv::Mat&)frame;
-(instancetype)initWithCaffeModels:(NSString*)CaffeModel Prototext:(NSString*)Prototext Treshold:(float)treshold inputWidth:(int)inputWidth inputHeight:(int)inputHeight modelLabelMap:(NSString*)modelLabelMap imageBlobScalefactor:(float)imageBlobScalefactor imageBlobMeanScalar:(NSArray*)imageBlobMeanScalar imageBlobSwapRB:(BOOL)imageBlobSwapRB imageBlobCrop:(BOOL)imageBlobCrop;




@end
