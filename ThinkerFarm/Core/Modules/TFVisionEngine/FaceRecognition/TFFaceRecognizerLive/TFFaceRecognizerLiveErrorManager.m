//
//  TFFaceRecognizerLiveErrorManager.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 13.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import "TFFaceRecognizerLiveErrorManager.h"

@implementation TFFaceRecognizerLiveErrorManager

+ (NSError*) getErrorObject:(int) erroCode {
    
    
    NSError* error;
    NSDictionary *errorDictionary;
    
    
    switch (erroCode) {
        case TFFaceRecognizerLiveError:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"Error in object" };
            NSLog(@"faceRecognizerError NO:0 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZERLIVE_DOMAIN code:TFFaceRecognizerLiveError userInfo:errorDictionary];
            break;
        case TFFaceRecognizerLiveMissingUIImage:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"offlineFaceRecognizer can not use image you provided make sure UIImage you pass is not nil or data is not corrupted" };
            NSLog(@"faceRecognizerMissingUIImage NO:1 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZERLIVE_DOMAIN code:TFFaceRecognizerLiveMissingUIImage userInfo:errorDictionary];
            break;
        case TFFaceDetectionRecognizerLiveNoFaceFound:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"No Face Found" };
            NSLog(@"faceDetectionNoFaceFound NO:2 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZERLIVE_DOMAIN code:TFFaceDetectionRecognizerLiveNoFaceFound userInfo:errorDictionary];
            break;
        case TFFaceRecognizerLiveModileFileMissing:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"Model File Missing" };
            NSLog(@"fRecognizerLiveModileFileMissing NO:8 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZERLIVE_DOMAIN code:TFFaceRecognizerLiveModileFileMissing userInfo:errorDictionary];
            break;
        default:
            break;
    }
    
    
    return error;
}

@end
