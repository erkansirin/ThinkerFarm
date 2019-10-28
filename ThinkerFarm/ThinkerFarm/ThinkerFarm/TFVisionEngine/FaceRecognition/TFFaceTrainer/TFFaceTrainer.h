//
//  TFFaceTrainer.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFFaceTrainerDelegate.h"

NS_ASSUME_NONNULL_BEGIN

@interface TFFaceTrainer : NSObject

enum TFFaceTrainerTrainingMode {
    FaceTrainerWithEigenFace,
    FaceTrainerWithFisherFace,
    FaceTrainerWithLBPHFace,
};

-(instancetype) initWithTrainingMode:(enum TFFaceTrainerTrainingMode)trainingMode;

- (void)trainFaceWithFilePaths:(NSArray*)imagePathsAndLabels;

- (void)trainFaceWithImages:(NSArray*)imagesAndLabels;

@property id <TFFaceTrainerDelegate> _Nonnull delegate;

@end

NS_ASSUME_NONNULL_END

