//
//  TFColorization.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 19.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import "TFColorization.h"

//Colorization
#import "OpenCVData.h"
#import "Colorization.h"
//Colorization


@interface TFColorization ()<TFColorizationDelegate>




@end

@implementation TFColorization   {
    
    Colorization *colorization;
}
-(instancetype) init {
    self = [super init];
    if (self != nil) {
        
        colorization = [[Colorization alloc] init];
        
        
    }
    return self;
}
- (UIImage*)imageColorizer:(UIImage*)image
{
    
    
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *imageSubdirectory = [documentsDirectory stringByAppendingPathComponent:@"ThinkerFarmImages"];
    
    NSMutableArray * imagesAndLabels = [[NSMutableArray alloc ] init];
    
    
    
    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trainimage.png"]];
    NSData *imageData = UIImagePNGRepresentation(image);
    [imageData writeToFile:filePath atomically:YES];
    
    std::string imageFile = [filePath UTF8String];
    
    
    cv::Mat matImg = cv::imread(imageFile);
    
    if (matImg.empty())
    {
        NSLog(@"can not read image file");
        
    }
  
    
    
    //cv::Mat matImg;
    //UIImageToMat(image, matImg);
    
    //UIImage * results_image;
    
    cv::Mat matImgReturn;
    matImgReturn = [colorization colorizeFromImage:matImg];
    //results_image = MatToUIImage(matImgReturn);
    

    //[self.delegate didFinishColorizing:results_image];
        
 
    return MatToUIImage(matImgReturn);
    

    
}
//




@end




