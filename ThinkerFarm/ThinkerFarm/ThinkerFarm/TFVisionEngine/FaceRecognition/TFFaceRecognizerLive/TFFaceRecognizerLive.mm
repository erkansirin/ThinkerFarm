//
//  TFFaceRecognizerLive.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import "TFFaceRecognizerLive.h"

//Face Recognition
#import "TFFaceRecognizerLiveErrorManager.h"
#import "OpenCVData.h"
#import "FaceDetector.h"
#import "TFFaceRecognition.h"
#define CAPTURE_FPS 30
//Face Recognition


@interface TFFaceRecognizerLive ()<CvVideoCameraDelegate,FaceRecognizerDelegate>


@end

@implementation TFFaceRecognizerLive   {
    
    FaceDetector *faceDetector;
    TFFaceRecognition *faceRecognizer;
    CALayer *featureLayer;
    NSInteger frameNum;
    CvVideoCamera* videoCamera;
    BOOL recognitionStarted;
    
}
-(instancetype) init {
    self = [super init];
    if (self != nil) {
        
        [self initSetup];
        
    }
    return self;
}

-(instancetype) initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self != nil) {
        
        [self initSetup];

        
    }
    return self;
}


- (instancetype) initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self != nil) {
        
        //self.view.frame = frame;
        [self initSetup];
        
    }
    return self;
}

-(void)initSetup
{
    faceDetector = [[FaceDetector alloc] init];

    videoCamera = [[CvVideoCamera alloc] initWithParentView:self];
    videoCamera.delegate = self;
    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    videoCamera.defaultAVCaptureSessionPreset = AVCaptureSessionPreset352x288;
    videoCamera.defaultAVCaptureVideoOrientation = AVCaptureVideoOrientationLandscapeLeft;
    videoCamera.defaultFPS = CAPTURE_FPS;

    videoCamera.grayscaleMode = NO;
    recognitionStarted = NO;
    
}

-(void) startRecognitionWithMode:(enum TFFaceRecognizerLiveRecognitionMode)recognitionMode{

        switch (recognitionMode) {
            case FaceRecognizerLiveWithEigenFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithEigenFaceRecognizer];
                
                break;
            case FaceRecognizerLiveWithFisherFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithFisherFaceRecognizer];
                
                break;
            case FaceRecognizerLiveWithLBPHFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithLBPHFaceRecognizer];
                break;
            default:
                break;
        }
        faceRecognizer.delegate = self;
        recognitionStarted = YES;
    
}

-(void) startRecognition
{
    faceRecognizer = [[TFFaceRecognition alloc] initWithLBPHFaceRecognizer];
    faceRecognizer.delegate = self;
    recognitionStarted = YES;
}

-(void) stopRecogniton
{
    faceRecognizer = nil;
    //faceRecognizer.delegate = nil;
    //[faceRecognizer dealloc];
}



-(void) errorInFaceRecognition:(NSError *)error {
    NSLog(@"errorInFaceRecognition : %@",error.localizedDescription);
}


- (void)stopCamera
{
    [videoCamera stop];
}

- (void)startCamera
{
    [self stopCamera];

    videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
    
    [videoCamera start];
}

- (void)startCameraWithDevicePosition :(enum TFCameraPosition)cameraPosition{

    [self stopCamera];
    switch (cameraPosition) {
        case FRONT_CAMERA:
            videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
            break;
        case BACK_CAMERA:
            videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionBack;
            break;
        default:
            videoCamera.defaultAVCaptureDevicePosition = AVCaptureDevicePositionFront;
            break;
    }
    [videoCamera start];
    
}


- (void)processImage:(cv::Mat&)image
{
    // Only process every CAPTURE_FPS'th frame (every 1s)
    if (recognitionStarted){
    if (frameNum == CAPTURE_FPS) {
        [self parseFaces:[faceDetector facesFromImage:image] forImage:image];
        frameNum = 0;
    }
    
    frameNum++;
    }
}

- (void)parseFaces:(const std::vector<cv::Rect> &)faces forImage:(cv::Mat&)image
{
    
    
        // No faces found
        if (faces.size() != 1) {
            [self noFaceToDisplay];
            return;
        }
        
        // We only care about the first face
        cv::Rect face = faces[0];
        
        // By default highlight the face in red, no match found
        CGColor *highlightColor = [[UIColor redColor] CGColor];
        NSString *message = @"No match found";
        NSString *confidence = @"";
        NSString *personID = @"";
        
        // Unless the database is empty, try a match
        
        //NSDictionary *match = [self.faceRecognizer recognizeFace:face inImage:image];
        
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePathStr = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trainedfaces_at.xml"]];
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    // All changes to the UI have to happen on the main thread
    dispatch_sync(dispatch_get_main_queue(), ^{
        //instructionLabel.text = message;
        NSLog(@"person found : %@ and person id : %@",confidence ,personID);
        
        //confidenceLabel.text = confidence;
        [self highlightFace:[OpenCVData faceToCGRect:face] withColor:highlightColor];
    });
    
    
    if (![fileManager fileExistsAtPath:filePathStr]){
    
    
        
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            [self.delegate didFinishUnRecognized:MatToUIImage([self pullStandardizedFace:face fromImage:image]) andFullFrame:MatToUIImage(image) isUpdate:NO];
            
            return;
        });
        
    }else{
    
    
        std::string modelFilePath = std::string([filePathStr UTF8String]);
        
        
        NSDictionary *match = [faceRecognizer offlineFaceRecognizer:face inImage:image inModelFilePath:modelFilePath];
        
    
    
    
    
    
        // Match found
        if ([match objectForKey:@"faceID"] != [NSNumber numberWithInt:-1]) {
            
            personID = [match objectForKey:@"faceID"];
            highlightColor = [[UIColor greenColor] CGColor];
            
            NSNumberFormatter *confidenceFormatter = [[NSNumberFormatter alloc] init];
            [confidenceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            confidenceFormatter.maximumFractionDigits = 2;
            
            confidence = [NSString stringWithFormat:@"Confidence: %@",
                          [confidenceFormatter stringFromNumber:[match objectForKey:@"confidence"]]];
            
            // All changes to the UI have to happen on the main thread
            dispatch_sync(dispatch_get_main_queue(), ^{
                //instructionLabel.text = message;
                NSLog(@"person found : %@ and person id : %@",confidence ,personID);
                [self.delegate didFinishRecognizingFace:match];
                //confidenceLabel.text = confidence;
                [self highlightFace:[OpenCVData faceToCGRect:face] withColor:highlightColor];
            });
            
            
            
            
        }else{
            
            dispatch_sync(dispatch_get_main_queue(), ^{
                
                [self.delegate didFinishUnRecognized:MatToUIImage([self pullStandardizedFace:face fromImage:image]) andFullFrame:MatToUIImage(image) isUpdate:YES];
                
                return;
            });
            
        }
        
        
       
        
    
    
    }
}

- (void)offlineFaceRecognizer:(UIImage*)image
{
    cv::Mat matImg;
    UIImageToMat(image, matImg);
    
    std::vector<cv::Rect> faces = [faceDetector facesFromImage:matImg];
    cv::Rect face = faces[0];
    
    
    
    NSString *message = @"No match found";
    NSString *confidence = @"";
    NSString *personID = @"";
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *filePathStr = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trainedfaces_at.xml"]];
    std::string modelFilePath = std::string([filePathStr UTF8String]);
    
    
    NSDictionary *match = [faceRecognizer offlineFaceRecognizer:face inImage:matImg inModelFilePath:modelFilePath];
    
    
    
    
    [self.delegate didFinishRecognizingFace:match];
    
    // Match found
    if ([match objectForKey:@"personID"] != [NSNumber numberWithInt:-1]) {
        
        personID = [match objectForKey:@"personID"];
        
        NSNumberFormatter *confidenceFormatter = [[NSNumberFormatter alloc] init];
        [confidenceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        confidenceFormatter.maximumFractionDigits = 2;
        
        confidence = [NSString stringWithFormat:@"Confidence: %@",
                      [confidenceFormatter stringFromNumber:[match objectForKey:@"confidence"]]];

        NSLog(@"person found : %@ and person id : %@",confidence ,personID);

    }
    
    
}
- (void)highlightFace:(CGRect)faceRect
{
    if (featureLayer == nil) {
        featureLayer = [[CALayer alloc] init];
        featureLayer.borderColor = [[UIColor redColor] CGColor];
        featureLayer.borderWidth = 4.0;
        [self.layer addSublayer:featureLayer];
    }
    
    featureLayer.hidden = NO;
    featureLayer.frame = faceRect;
}

- (void)noFaceToDisplay
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        
        //[self.delegate errorInFaceRecognition:[TFFaceRecognizerLiveErrorManager getErrorObject:faceDetectionRecognizerLiveNoFaceFound]];
        
        featureLayer.hidden = YES;
    });
}

- (void)highlightFace:(CGRect)faceRect withColor:(CGColor *)color
{
    if (featureLayer == nil) {
        featureLayer = [[CALayer alloc] init];
        featureLayer.borderWidth = 4.0;
    }
    
    [self.layer addSublayer:featureLayer];
    
    featureLayer.hidden = NO;
    featureLayer.borderColor = color;
    featureLayer.frame = faceRect;
}


- (cv::Mat)pullStandardizedFace:(cv::Rect)face fromImage:(cv::Mat&)image
{
    // Pull the grayscale face ROI out of the captured image
    cv::Mat onlyTheFace;
    cv::cvtColor(image(face), onlyTheFace, CV_RGB2GRAY);
    
    // Standardize the face to 100x100 pixels
    cv::resize(onlyTheFace, onlyTheFace, cv::Size(100, 100), 0, 0);
    
    return onlyTheFace;
}


- (void)trainFaceWithImages:(NSArray*)imagesAndLabels  isUpdate:(BOOL)isUpdate
{
    
    for (int i = 0; i < imagesAndLabels.count; i++){
        
        NSDictionary* imagesAndLabel = imagesAndLabels[i];
        
        /*if (![imagesAndLabel[@"imageLabelId"] isKindOfClass:[NSNumber class]]){
         dispatch_async(dispatch_get_main_queue(), ^{
         [self.delegate errorInFaceTraining:[TFFaceTrainerErrorManager getErrorObject:TFFaceTrainerNSNumberTypeError]];
         });
         return;
         }*/
        
        if (![imagesAndLabel[@"imageData"] isKindOfClass:[UIImage class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
               // [self.delegate errorInFaceTraining:[TFFaceTrainerErrorManager getErrorObject:TFFaceTrainerNSStringTypeError]];
            });
            return;
        }
    }
    
    [self.delegate didFinishTrainingFace:[faceRecognizer trainFaceWithImages:imagesAndLabels isUpdate:isUpdate]];
    
}


- (void)trainFaceWithFilePaths:(NSArray*)imagePathsAndLabels
{
    
    for (int i = 0; i < imagePathsAndLabels.count; i++){
        
        NSDictionary* imagePathsAndLabel = imagePathsAndLabels[i];
        
        if (![imagePathsAndLabel[@"imageLabelId"] isKindOfClass:[NSNumber class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate errorInFaceRecognition:[TFFaceRecognizerLiveErrorManager getErrorObject:TFFaceTrainerLiveNSNumberTypeError]];
            });
            return;
        }
        
        if (![imagePathsAndLabel[@"imagePath"] isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate errorInFaceRecognition:[TFFaceRecognizerLiveErrorManager getErrorObject:TFFaceTrainerLiveNSStringTypeError]];
            });
            return;
        }
    }
    
    [self.delegate didFinishTrainingFace:[faceRecognizer trainFaceWithFilePaths:imagePathsAndLabels]];
    
}


//
@end



