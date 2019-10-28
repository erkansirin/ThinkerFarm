//
//  FaceRecognizerErrorManager.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FaceRecognizerDelegate.h"

#define TFFACERECOGNIZER_DOMAIN @"TFFaceRecognition"
NS_ASSUME_NONNULL_BEGIN

@interface FaceRecognizerErrorManager : NSObject

+ (NSError*) getErrorObject:(int) erroCode;

@end

NS_ASSUME_NONNULL_END

