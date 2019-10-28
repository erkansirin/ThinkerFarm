//
//  TFFaceTrainerDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#ifndef TFFaceTrainerDelegate_h
#define TFFaceTrainerDelegate_h


#endif /* TFFaceTrainerDelegate_h */
static NSString * _Nonnull const TFFaceTrainerDomain = @"TFFaceTrainer";

typedef enum TFFaceTrainerStatus {
    TFFaceTrainerError = 0,
    TFFaceTrainerNSNumberTypeError = 1,
    TFFaceTrainerNSStringTypeError = 2,
    TFFaceTrainerUIImageTypeError = 4,
}TFFaceTrainerStatus;

@protocol TFFaceTrainerDelegate <NSObject>

- (void) errorInFaceTraining: (NSError* _Nonnull)error;

- (void) didFinishTrainingFace: (NSDictionary* _Nonnull)trainedData;


@end
