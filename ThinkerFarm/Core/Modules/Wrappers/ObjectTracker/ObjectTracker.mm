//
//  ObjectTracker.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 19.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectTracker.h"



@implementation ObjectTracker

- (instancetype)init
{
    self = [super init];
    if (self) {
        
     

    }
    
    return self;
}


-(instancetype)initWithTrackerMode:(NSString*)Tracker
{
    self = [self init];
    
    
    trackerType = cv::TrackerBoosting::create();
    
    if (Tracker == @"BOOSTING") {
        
    }
    
   multiTracker = cv::MultiTracker::create();
std::vector<cv::Mat> frame;
    
   //multiTracker->add(createTrackerByName(trackerType), frame, Rect2d(bboxes[i]));
    
   
    return self;
    
}

@end
