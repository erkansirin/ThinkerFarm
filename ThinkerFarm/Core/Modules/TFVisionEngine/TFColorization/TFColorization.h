//
//  TFColorization.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 19.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
#import "TFColorizationDelegate.h"




NS_ASSUME_NONNULL_BEGIN

@interface TFColorization : NSObject

- (UIImage*)imageColorizer:(UIImage*)image;


@property id <TFColorizationDelegate> _Nonnull delegate;

@end

NS_ASSUME_NONNULL_END


