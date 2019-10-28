//
//  TFFaceTrainer.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import "TFFaceTrainer.h"
#import "TFFaceTrainerErrorManager.h"

//Face Recognition
#import "OpenCVData.h"
#import "TFFaceRecognition.h"
//Face Recognition

@interface TFFaceTrainer ()<FaceRecognizerDelegate>

@end

@implementation TFFaceTrainer   {
    
    TFFaceRecognition *faceRecognizer;
    
}
-(instancetype) init
{
    self = [super init];
    if (self != nil) {
        
        faceRecognizer = [[TFFaceRecognition alloc] initWithLBPHFaceRecognizer];
        faceRecognizer.delegate = self;
    }
    return self;
}

-(instancetype) initWithTrainingMode:(enum TFFaceTrainerTrainingMode)trainingMode
{
    self = [super init];
    if (self != nil) {
        
        switch (trainingMode) {
            case FaceTrainerWithEigenFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithEigenFaceRecognizer];
                
                break;
            case FaceTrainerWithFisherFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithFisherFaceRecognizer];
                
                break;
            case FaceTrainerWithLBPHFace:
                faceRecognizer = [[TFFaceRecognition alloc] initWithLBPHFaceRecognizer];
                break;
            default:
                break;
        }
        faceRecognizer.delegate = self;
    }
    return self;
}

-(void) errorInFaceRecognition:(NSError *)error
{
    NSLog(@"errorInFaceRecognition : %@",error.localizedDescription);
}

- (void)trainFaceWithFilePaths:(NSArray*)imagePathsAndLabels
{
                
    for (int i = 0; i < imagePathsAndLabels.count; i++){
        
        NSDictionary* imagePathsAndLabel = imagePathsAndLabels[i];

        if (![imagePathsAndLabel[@"imageLabelId"] isKindOfClass:[NSNumber class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate errorInFaceTraining:[TFFaceTrainerErrorManager getErrorObject:TFFaceTrainerNSNumberTypeError]];
            });
            return;
        }
        
        if (![imagePathsAndLabel[@"imagePath"] isKindOfClass:[NSString class]]){
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate errorInFaceTraining:[TFFaceTrainerErrorManager getErrorObject:TFFaceTrainerNSStringTypeError]];
            });
            return;
        }
    }
    
    [self.delegate didFinishTrainingFace:[faceRecognizer trainFaceWithFilePaths:imagePathsAndLabels]];

}

- (void)trainFaceWithImages:(NSArray*)imagesAndLabels
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
                [self.delegate errorInFaceTraining:[TFFaceTrainerErrorManager getErrorObject:TFFaceTrainerNSStringTypeError]];
            });
            return;
        }
    }
    
    [self.delegate didFinishTrainingFace:[faceRecognizer trainFaceWithImages:imagesAndLabels isUpdate:NO]];
    
}

@end



