//
//  TFVoiceRecognitionDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 15.02.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#ifndef TFVoiceRecognitionDelegate_h
#define TFVoiceRecognitionDelegate_h

@protocol TFVoiceRecognitionDelegate <NSObject>

- (void) didFinsishVoiceRecognition : (NSString *) spokenWords;

@end


#endif /* TFVoiceRecognitionDelegate_h */
