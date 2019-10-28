//
//  FaceRecognizerErrorManager.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import "FaceRecognizerErrorManager.h"

@implementation FaceRecognizerErrorManager

+ (NSError*) getErrorObject:(int) erroCode {
    
    
    NSError* error;
    NSDictionary *errorDictionary;
    
    
    switch (erroCode) {
        case FACERECOGNIZER_ERROR:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"Error in object" };
            NSLog(@"FACERECOGNIZER_ERROR NO:0 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:FACERECOGNIZER_DOMAIN code:FACERECOGNIZER_ERROR userInfo:errorDictionary];
            break;
        case FACEDETECT_ERROR:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"Face detector can not find any face in provided image." };
            NSLog(@"FACEDETECT_ERROR NO:1 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:FACERECOGNIZER_DOMAIN code:FACEDETECT_ERROR userInfo:errorDictionary];
            break;
        default:
            break;
    }
    
    
    return error;
}


@end

