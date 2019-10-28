//
//  TFFaceTrainerErrorManager.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import "TFFaceTrainerErrorManager.h"

@implementation TFFaceTrainerErrorManager

+ (NSError*) getErrorObject:(int) erroCode {
    
    
    NSError* error;
    NSDictionary *errorDictionary;
    
    
    switch (erroCode) {
        case TFFaceTrainerError:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"Error in object" };
            NSLog(@"TFFaceTrainerError NO:0 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFaceTrainerDomain code:TFFaceTrainerError userInfo:errorDictionary];
            break;
        case TFFaceTrainerNSNumberTypeError:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"imageLabelId type in given training data in trainFaceWithFilePaths function is not correct must be NSNumber" };
            NSLog(@"TFFaceTrainerNSNumberTypeError NO:1 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFaceTrainerDomain code:TFFaceTrainerNSNumberTypeError userInfo:errorDictionary];
            break;
        case TFFaceTrainerNSStringTypeError:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"imagePath type in training data in trainFaceWithFilePaths function is not correct must be NSString" };
            NSLog(@"TFFaceTrainerNSNumberTypeError NO:1 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFaceTrainerDomain code:TFFaceTrainerNSStringTypeError userInfo:errorDictionary];
            break;
        case TFFaceTrainerUIImageTypeError:
            errorDictionary = @{ NSLocalizedDescriptionKey : @"imageData type in training data in trainFaceWithImages function is not correct must be UIImage" };
            NSLog(@"TFFaceTrainerUIImageTypeError NO:2 - %@",errorDictionary);
            error = [[NSError alloc] initWithDomain:TFFaceTrainerDomain code:TFFaceTrainerUIImageTypeError userInfo:errorDictionary];
            break;
        default:
            break;
    }
    
    
    return error;
}

@end
