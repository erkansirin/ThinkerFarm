//
//  Colorization.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 16.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/dnn.hpp>
#import <opencv2/imgcodecs/ios.h>


#import <iostream>

@interface Colorization : NSObject
{
}

- (cv::Mat)colorizeFromImage:(cv::Mat&)image;

@end
