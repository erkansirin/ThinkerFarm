//
//  TFFaceRecognizer.h
//  TFFaceRecognizer
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <opencv2/highgui/highgui_c.h>
#import <opencv2/face.hpp>
#import <opencv2/videoio/cap_ios.h>
#import "sqlite3.h"
#import "FaceRecognizerDelegate.h"
#import "FaceRecognizerErrorManager.h"
#import "FaceDetector.h"
#import <opencv2/imgcodecs/ios.h>
@interface TFFaceRecognition : NSObject
{

    cv::Ptr<cv::face::FaceRecognizer> _model;
    FaceDetector *faceDetector;
}

- (instancetype _Nonnull)initWithEigenFaceRecognizer;
- (instancetype _Nonnull)initWithFisherFaceRecognizer;
- (instancetype _Nonnull)initWithLBPHFaceRecognizer;
- (cv::Mat)pullStandardizedFace:(cv::Rect)face fromImage:(cv::Mat&)image;
- (NSDictionary *_Nonnull)offlineFaceRecognizer:(cv::Rect)face inImage:(cv::Mat&)image inModelFilePath:(std::string&) modelFilePath;
- (NSDictionary* _Nullable)trainFaceWithImages:(NSArray* _Nonnull)imagesAndLabels isUpdate:(BOOL)isUpdate;

- (NSMutableDictionary* _Nullable)trainFaceWithFilePaths:(NSArray* _Nonnull)imagePathsAndLabels;
@property id <FaceRecognizerDelegate> _Nonnull delegate;
@end
