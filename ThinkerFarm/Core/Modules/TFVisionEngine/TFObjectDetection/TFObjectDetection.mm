//
//  TFObjectDetection.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import "TFObjectDetection.h"

//Colorization
#import "OpenCVData.h"
#import "ObjectDetection.h"
//Colorization


@interface TFObjectDetection ()<TFObjectDetectionDelegate>




@end

@implementation TFObjectDetection   {
    
    ObjectDetection *objectDetection;
}
-(instancetype) init {
    self = [super init];
    if (self != nil) {
        
        objectDetection = [[ObjectDetection alloc] init];
        NSLog(@"init started");
        
        
    }
    return self;
}
- (NSMutableArray*)detectObject:(UIImage*)image
{
    

    cv::Mat matImg;
    UIImageToMat(image, matImg);
    
    //UIImage * results_image;
    
    NSMutableArray* matReturn;
    matReturn = [objectDetection detectObjectFromImage:matImg];
    
    //results_image = MatToUIImage(matImgReturn);
    
    
    //[self.delegate didFinishColorizing:results_image];
    
    
    return matReturn;
    
    
    
}
//
- (void) didFinishDetectiong{
    
}



@end





