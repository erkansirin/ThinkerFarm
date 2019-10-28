//
//  TFFaceRecognizerErrorManager.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 12.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFFaceRecognizerDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFFaceRecognizerErrorManager : NSObject

+ (NSError*) getErrorObject:(int) erroCode;

@end

NS_ASSUME_NONNULL_END
