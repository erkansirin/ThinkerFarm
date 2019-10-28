//
//  TFFaceRecall.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 28.11.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFFaceRecognizerDelegate.h"



NS_ASSUME_NONNULL_BEGIN

@interface TFFaceRecognizer : NSObject

enum TFRecognitionMode {
    EigenFace,
    FisherFace,
    LBPHFace,
};


- (instancetype) initWithRecognitionMode:(enum TFRecognitionMode)recognitionMode;

- (void)offlineFaceRecognizer:(UIImage*)image pretrainedModelData:(NSString*)pretrainedModelData;

- (void)offlineFaceRecognizer:(UIImage*)image pretrainedModelFilePath:(NSString*)pretrainedModelFilePath;

@property id <TFFaceRecognizerDelegate> _Nonnull delegate;

@end

NS_ASSUME_NONNULL_END

