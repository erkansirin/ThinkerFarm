//
//  FaceRecognizerDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#ifndef FaceRecognizerDelegate_h
#define FaceRecognizerDelegate_h

#include <Foundation/Foundation.h>
#include <UIKit/UIKit.h>

static NSString * _Nonnull const FACERECOGNIZER_DOMAIN = @"TFFaceRecognition";

typedef enum FaceRecognizerStatus {
    FACERECOGNIZER_ERROR = 0,
    FACEDETECT_ERROR = 1,
} FaceRecognizerStatus;

@protocol FaceRecognizerDelegate <NSObject>

/**
 * Handle error in FaceRecognition.
 */
- (void) errorInFaceRecognition: (NSError* _Nonnull)error;

@end


#endif /* FaceRecognizerDelegate_h */
