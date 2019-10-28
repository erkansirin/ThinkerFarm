//
//  TFFaceRecall.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 28.11.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import "TFFaceRecognizer.h"
#import "TFFaceRecognizerErrorManager.h"

//Face Recognition
#import "OpenCVData.h"
#import "FaceDetector.h"
#import "TFFaceRecognition.h"
#define CAPTURE_FPS 30
//Face Recognition


@interface TFFaceRecognizer ()<FaceRecognizerDelegate>




@end

@implementation TFFaceRecognizer   {
    
    FaceDetector *faceDetector;
    TFFaceRecognition *faceRecognizer;
    CALayer *featureLayer;
    NSInteger frameNum;
    BOOL modelAvailable;

    NSInteger numPicsTaken;


    NSMutableArray * imagesAndLabels;
    NSMutableArray * images;
    
}
-(instancetype) init {
    self = [super init];
    if (self != nil) {

        faceRecognizer = [[TFFaceRecognition alloc] initWithLBPHFaceRecognizer];
        faceRecognizer.delegate = self;

    }
    return self;
}

-(instancetype) initWithRecognitionMode:(enum TFRecognitionMode)recognitionMode {
    self = [super init];
    if (self != nil) {
        
        switch (recognitionMode) {
            case EigenFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithEigenFaceRecognizer];
                
                break;
            case FisherFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithFisherFaceRecognizer];
                
                break;
            case LBPHFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithLBPHFaceRecognizer];
                break;
            default:
                break;
        }
        faceRecognizer.delegate = self;

    }
    return self;
}

-(void) errorInFaceRecognition:(NSError *)error {
    NSLog(@"errorInFaceRecognition : %@",error.localizedDescription);
}

- (void)offlineFaceRecognizer:(UIImage*)image pretrainedModelFilePath:(NSString*)pretrainedModelFilePath
{
    
    if(!image){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate errorInFaceRecognition:[TFFaceRecognizerErrorManager getErrorObject:faceRecognizerMissingUIImage]];
        });
        return;
    }
    
    
    if(!pretrainedModelFilePath || [pretrainedModelFilePath  isEqual: @""]){
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.delegate errorInFaceRecognition:[TFFaceRecognizerErrorManager getErrorObject:faceRecognizerMissingpretrainedFilePath]];
        });
        return;
    }
    
    
    cv::Mat matImg;
    UIImageToMat(image, matImg);
    
    std::vector<cv::Rect> faces = [faceDetector facesFromImage:matImg];
    cv::Rect face = faces[0];
    
    
 
    NSString *message = @"No match found";
    NSString *confidence = @"";
    NSString *personID = @"";
    
   
    std::string modelFilePath = std::string([pretrainedModelFilePath UTF8String]);
    
    NSDictionary *match = [faceRecognizer offlineFaceRecognizer:face inImage:matImg inModelFilePath:modelFilePath];
    
    
    // Match found
    if ([match objectForKey:@"personID"] != [NSNumber numberWithInt:-1]) {
        
        personID = [match objectForKey:@"personID"];
       
        NSNumberFormatter *confidenceFormatter = [[NSNumberFormatter alloc] init];
        [confidenceFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
        confidenceFormatter.maximumFractionDigits = 2;
        
        confidence = [NSString stringWithFormat:@"Confidence: %@",
                      [confidenceFormatter stringFromNumber:[match objectForKey:@"confidence"]]];
        
        
  
            NSLog(@"person found : %@ and person id : %@",confidence ,personID);
            
   
        
    }else{
        NSLog(@"person found : %@ and person id : %@",confidence ,personID);
    }
    

}
- (void)highlightFace:(CGRect)faceRect
{
    if (featureLayer == nil) {
        featureLayer = [[CALayer alloc] init];
        featureLayer.borderColor = [[UIColor redColor] CGColor];
        featureLayer.borderWidth = 4.0;
        //[self.layer addSublayer:featureLayer];
    }
    
    featureLayer.hidden = NO;
    featureLayer.frame = faceRect;
}

- (void)noFaceToDisplay
{
    dispatch_sync(dispatch_get_main_queue(), ^{
        //instructionLabel.text = @"No face in image";
        //confidenceLabel.text = @"";
        featureLayer.hidden = YES;
    });
}

- (void)highlightFace:(CGRect)faceRect withColor:(CGColor *)color
{
    if (featureLayer == nil) {
        featureLayer = [[CALayer alloc] init];
        featureLayer.borderWidth = 4.0;
    }
    
   // [self.layer addSublayer:featureLayer];
    
    featureLayer.hidden = NO;
    featureLayer.borderColor = color;
    featureLayer.frame = faceRect;
}
//
@end



