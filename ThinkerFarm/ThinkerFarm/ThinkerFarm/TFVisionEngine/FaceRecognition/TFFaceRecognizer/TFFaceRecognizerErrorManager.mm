//
//  TFFaceRecognizerErrorManager.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import "TFFaceRecognizerErrorManager.h"

@implementation TFFaceRecognizerErrorManager

+ (NSError*) getErrorObject:(int) erroCode {
    
    
    NSError* error;
    NSDictionary *errorDictionary;
    
    
    switch (erroCode) {
        case faceRecognizerError:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"Error in object" };
            NSLog(@"faceRecognizerError NO:0 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZER_DOMAIN code:faceRecognizerError userInfo:errorDictionary];
            break;
        case faceRecognizerMissingUIImage:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"offlineFaceRecognizer can not use image you provided make sure UIImage you pass is not nil or data is not corrupted" };
            NSLog(@"faceRecognizerMissingUIImage NO:1 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZER_DOMAIN code:faceRecognizerMissingUIImage userInfo:errorDictionary];
            break;
        case faceRecognizerMissingpretrainedFilePath:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"offlineFaceRecognizer : provided file path is not correct or empty" };
            NSLog(@"faceRecognizerMissingpretrainedFilePath NO:2 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFACERECOGNIZER_DOMAIN code:faceRecognizerMissingpretrainedFilePath userInfo:errorDictionary];
            break;
        default:
            break;
    }
    
    
    return error;
}

@end
