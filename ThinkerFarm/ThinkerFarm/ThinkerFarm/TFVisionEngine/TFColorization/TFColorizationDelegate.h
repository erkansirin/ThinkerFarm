//
//  TFColorizationDelegate.h
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 19.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//


static NSString * _Nonnull const TFCOLORIZATION_DOMAIN = @"TFColorization";


@protocol TFColorizationDelegate <NSObject>


- (void) didFinishColorizing: (UIImage* _Nonnull)resultImage;


@end

