//
//  TFFaceRecognizerLiveErrorManager.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 13.12.2018.
//  Copyright © 2018 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFFaceRecognizerLiveDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFFaceRecognizerLiveErrorManager : NSObject

+ (NSError*) getErrorObject:(int) erroCode;

@end

NS_ASSUME_NONNULL_END
