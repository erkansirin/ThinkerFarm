//
//  TFVoiceRecognition.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 15.02.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import "TFVoiceRecognition.h"
#import <AVFoundation/AVFoundation.h>
#import <Speech/Speech.h>

@interface TFVoiceRecognition ()
@end

@implementation TFVoiceRecognition{
    
    AVAudioEngine *audioEngine;
    SFSpeechRecognizer *speechRecognizer;
    SFSpeechAudioBufferRecognitionRequest *recognitionRequest;
    SFSpeechRecognitionTask *recognitionTask;
    NSString *spoken;
}

-(void)stopListening{
    if (audioEngine.isRunning) {
        [audioEngine stop];
        [recognitionRequest endAudio];
        NSLog(@"check 3");
    }
}

-(void) initCommandList:(NSArray *)commandList
{
    
    NSLog(@"commandList : %@",commandList);
}

-(instancetype) init
{
    self = [super init];
    if (self != nil) {
        
        // Initialize the AVAudioEngine
        audioEngine = [[AVAudioEngine alloc] init];
        
        // Make sure there's not a recognition task already running
        if (recognitionTask) {
            [recognitionTask cancel];
            recognitionTask = nil;
        }
        
        // Starts an AVAudio Session
        NSError *error;
        AVAudioSession *audioSession = [AVAudioSession sharedInstance];
        // [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord error:&error];
        [audioSession setCategory:AVAudioSessionCategoryPlayAndRecord
                      withOptions:AVAudioSessionCategoryOptionDefaultToSpeaker
                            error:&error];
        [audioSession setActive:YES withOptions:AVAudioSessionSetActiveOptionNotifyOthersOnDeactivation error:&error];
        
        // Starts a recognition process, in the block it logs the input or stops the audio
        // process if there's an error.
        recognitionRequest = [[SFSpeechAudioBufferRecognitionRequest alloc] init];
        AVAudioInputNode *inputNode = audioEngine.inputNode;
        recognitionRequest.shouldReportPartialResults = YES;
        recognitionTask = [speechRecognizer recognitionTaskWithRequest:recognitionRequest resultHandler:^(SFSpeechRecognitionResult * _Nullable result, NSError * _Nullable error) {
     
            if (result) {
                // Whatever you say in the mic after pressing the button should be being logged
                // in the console.
                
                spoken = result.bestTranscription.formattedString;
                // spoken = [spoken stringByReplacingOccurrencesOfString:spokenPrevious withString:@""];
                NSLog(@"spoken :%@",spoken);
                
                [self.delegate didFinsishVoiceRecognition:spoken];
                /*
                 [spokenTimer invalidate];
                 spokenTimer = nil;
                 spokenTimer=[NSTimer scheduledTimerWithTimeInterval:2 target:self selector:@selector(endOfSpokenTimer) userInfo:nil repeats:NO];
                 */
               
                
            }
            if (error) {
                [audioEngine stop];
                [inputNode removeTapOnBus:0];
                recognitionRequest = nil;
                recognitionTask = nil;
            }
        }];
        
        // Sets the recording format
        AVAudioFormat *recordingFormat = [inputNode outputFormatForBus:0];
        [inputNode installTapOnBus:0 bufferSize:1024 format:recordingFormat block:^(AVAudioPCMBuffer * _Nonnull buffer, AVAudioTime * _Nonnull when) {
            [recognitionRequest appendAudioPCMBuffer:buffer];
        }];
        
        // Starts the audio engine, i.e. it starts listening.
        [audioEngine prepare];
        [audioEngine startAndReturnError:&error];
        
        NSLog(@"Say Something, I'm listening");
        
    }
    return self;
}


@end
