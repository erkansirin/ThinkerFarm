//
//  TFFaceRecognizerLiveDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 13.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#ifndef TFFaceRecognizerLiveDelegate_h
#define TFFaceRecognizerLiveDelegate_h


#endif /* TFFaceRecognizerLiveDelegate_h */

static NSString * _Nonnull const TFFACERECOGNIZERLIVE_DOMAIN = @"TFFaceRecognizerLive";

typedef enum TFFaceRecognizerLiveStatus {
    TFFaceRecognizerLiveError = 0,
    TFFaceRecognizerLiveMissingUIImage = 1,
    TFFaceDetectionRecognizerLiveNoFaceFound = 2,
    TFFaceRecognizerLiveModileFileMissing = 3,
    TFFaceTrainerLiveError = 4,
    TFFaceTrainerLiveNSNumberTypeError = 5,
    TFFaceTrainerLiveNSStringTypeError = 6,
    TFFaceTrainerLiveUIImageTypeError = 7,
}TFFaceRecognizerLiveStatus;

@protocol TFFaceRecognizerLiveDelegate <NSObject>

- (void) errorInFaceRecognition: (NSError* _Nonnull)error;

- (void) didFinishRecognizingFace: (NSDictionary* _Nonnull)recognizerData;

- (void) didFinishUnRecognized: (UIImage* _Nonnull)unknownPersonImage andFullFrame:(UIImage* _Nonnull)fullFrame isUpdate:(BOOL)isUpdate;

- (void) didFinishTrainingFace: (NSDictionary* _Nonnull)trainedData;

@end
