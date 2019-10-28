//
//  TFFaceRecognizerLive.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>
#import "TFFaceRecognizerLiveDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFFaceRecognizerLive : UIView

enum TFCameraPosition {
    FRONT_CAMERA,
    BACK_CAMERA,
};

enum TFFaceRecognizerLiveRecognitionMode {
    FaceRecognizerLiveWithEigenFace,
    FaceRecognizerLiveWithFisherFace,
    FaceRecognizerLiveWithLBPHFace,
};

- (instancetype) initWithFrame:(CGRect)frame;

- (void) startRecognition;

- (void) stopRecogniton;

- (void) startRecognitionWithMode:(enum TFFaceRecognizerLiveRecognitionMode)recognitionMode;

- (void) startCamera;

- (void) stopCamera;

- (void)startCameraWithDevicePosition :(enum TFCameraPosition)cameraPosition;

- (void)trainFaceWithImages:(NSArray*)imagesAndLabels isUpdate:(BOOL)isUpdate;

- (void)trainFaceWithFilePaths:(NSArray*)imagePathsAndLabels;

@property id <TFFaceRecognizerLiveDelegate> delegate;

@end

NS_ASSUME_NONNULL_END

