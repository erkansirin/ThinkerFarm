//
//  TFSpeech.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 13.02.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import "TFSpeech.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

@interface TFSpeech ()<AVSpeechSynthesizerDelegate>
@end

@implementation TFSpeech{
   
    AVSpeechSynthesizer *synthesizer;
}

-(instancetype) init
{
    self = [super init];
    if (self != nil) {
        
        synthesizer = [[AVSpeechSynthesizer alloc] init];
        synthesizer.delegate = self;
        
    }
    return self;
}

-(void)selectAndSpeak: (NSString*) stringToSpeak{
    
    if (synthesizer.speaking == NO) {
        
        
        [self.delegate didStartSpeaking:true];
        
        AVSpeechUtterance *utterance = [[AVSpeechUtterance alloc] initWithString:stringToSpeak];
        //utterance.rate = AVSpeechUtteranceMinimumSpeechRate;
        utterance.voice = [AVSpeechSynthesisVoice voiceWithLanguage:@"en-US"];
        //utterance.preUtteranceDelay = 5.0;
        //utterance.postUtteranceDelay = 5.0;
        utterance.rate = 0.43;
        NSMutableAttributedString * string = [[NSMutableAttributedString alloc] initWithString:stringToSpeak];
        [string addAttribute:NSForegroundColorAttributeName value:[UIColor whiteColor] range:NSMakeRange(0,stringToSpeak.length)];
        [string addAttribute:NSBackgroundColorAttributeName value:[UIColor blackColor] range:NSMakeRange(0,stringToSpeak.length)];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            //self.aiSubtitle.attributedText = string;
        });
        

        [synthesizer speakUtterance:utterance];
        
    }
    
}

-(void)speechSynthesizer:(AVSpeechSynthesizer *)synthesizer didFinishSpeechUtterance:(AVSpeechUtterance *)utterance {

    
    [self.delegate didFinishSpeaking:true];
    

    
}


@end
