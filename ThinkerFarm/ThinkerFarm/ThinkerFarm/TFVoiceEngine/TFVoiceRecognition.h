//
//  TFVoiceRecognition.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 15.02.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFVoiceRecognitionDelegate.h"
NS_ASSUME_NONNULL_BEGIN

@interface TFVoiceRecognition : NSObject

-(void) initCommandList:(NSArray *)commandList;

@property id <TFVoiceRecognitionDelegate> _Nonnull delegate;

@end

NS_ASSUME_NONNULL_END
