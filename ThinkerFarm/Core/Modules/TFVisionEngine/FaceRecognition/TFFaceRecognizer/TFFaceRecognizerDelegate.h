//
//  CASFaceRecognitionDelegation.h
//  CASDK
//
//  Created by Erkan SIRIN on 22.11.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#ifndef TFFaceRecallDelegation_h
#define TFFaceRecallDelegation_h


#endif /* TFFaceRecallDelegation_h */

static NSString * _Nonnull const TFFACERECOGNIZER_DOMAIN = @"TFFaceRecognizer";

typedef enum TFFaceRecognizerStatus {
    faceRecognizerError = 0,
    faceRecognizerMissingUIImage = 1,
    faceRecognizerMissingpretrainedFilePath = 2,
}TFFaceRecognizerStatus;


@protocol TFFaceRecognizerDelegate <NSObject>

- (void) errorInFaceRecognition: (NSError* _Nonnull)error;
@end
