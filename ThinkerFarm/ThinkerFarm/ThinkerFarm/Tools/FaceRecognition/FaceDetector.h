//
//  FaceDetector.h
//  FaceRecognition
//
//  Created by Michael Peterson on 2012-11-16.
//
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/highgui_c.h>

@interface FaceDetector : NSObject
{
    cv::CascadeClassifier _faceCascade;
}

- (std::vector<cv::Rect>)facesFromImage:(cv::Mat&)image;

@end
