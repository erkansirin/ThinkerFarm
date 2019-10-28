//
//  TFSpeechDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 13.02.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#ifndef TFSpeechDelegate_h
#define TFSpeechDelegate_h

@protocol TFSpeechDelegate <NSObject>

- (void) didStartSpeaking: (BOOL)speakStarted;
- (void) didFinishSpeaking: (BOOL)speakEnded;

@end
#endif /* TFSpeechDelegate_h */
