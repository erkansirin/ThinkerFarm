//
//  FaceDetector.mm
//  FaceRecognition
//
//  Created by Michael Peterson on 2012-11-16.
//
//

#import "FaceDetector.h"

NSString * const kFaceCascadeFilename = @"haarcascade_frontalface_alt2";
const int kHaarOptions =  cv::CASCADE_FIND_BIGGEST_OBJECT | cv::CASCADE_DO_ROUGH_SEARCH;

@implementation FaceDetector

- (instancetype)init
{
    self = [super init];
    if (self) {
        NSString *faceCascadePath = [[NSBundle mainBundle] pathForResource:kFaceCascadeFilename
                                                                    ofType:@"xml"];
        
        if (!_faceCascade.load([faceCascadePath UTF8String])) {
            NSLog(@"Could not load face cascade: %@", faceCascadePath);
        }
    }
    
    return self;
}

- (std::vector<cv::Rect>)facesFromImage:(cv::Mat&)image
{
    std::vector<cv::Rect> faces;
    _faceCascade.detectMultiScale(image, faces, 1.1, 2, kHaarOptions, cv::Size(60, 60));
    
    return faces;
}

@end
