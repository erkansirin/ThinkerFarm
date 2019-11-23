//
//  ObjectTracker.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 19.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#ifndef ObjectTracker_h
#define ObjectTracker_h


#endif /* ObjectTracker_h */
#include <opencv2/opencv.hpp>
#include <opencv2/tracking.hpp>

@interface ObjectTracker : NSObject
{
    cv::Ptr<cv::Tracker> trackerType;
    cv::Ptr<cv::MultiTracker> multiTracker;
}


-(instancetype)initWithTrackerMode:(NSString*)Tracker;

@end
