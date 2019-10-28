//
//  TFSpeech.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 13.02.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TFSpeechDelegate.h"

@interface TFSpeech : NSObject

-(void)selectAndSpeak: (NSString*) stringToSpeak;

@property id <TFSpeechDelegate> _Nonnull delegate;

@end


