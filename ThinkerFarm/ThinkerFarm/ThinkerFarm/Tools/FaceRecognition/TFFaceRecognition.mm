//
//  TFFaceRecognizer.m
//  TFFaceRecognizer
//
//  Created by Erkan SIRIN on 5.12.2018.
//  Copyright © 2018 Erkan Sirin. All rights reserved.
//

#import "TFFaceRecognition.h"
#import "OpenCVData.h"

@implementation TFFaceRecognition

- (id)init
{
    self = [super init];
    if (self) {
    
    }
    
    return self;
}

- (instancetype)initWithEigenFaceRecognizer
{
    self = [self init];
    _model = cv::face::EigenFaceRecognizer::create();
    faceDetector = [[FaceDetector alloc] init];
    
    
    
    return self;
}

- (instancetype)initWithFisherFaceRecognizer
{
    self = [self init];
    //_model = cv::createFisherFaceRecognizer();
    _model = cv::face::FisherFaceRecognizer::create();
    faceDetector = [[FaceDetector alloc] init];
    
    return self;
}

- (instancetype)initWithLBPHFaceRecognizer
{
    self = [self init];
    //_model = cv::createLBPHFaceRecognizer();
    _model = cv::face::LBPHFaceRecognizer::create();
    faceDetector = [[FaceDetector alloc] init];
    
    return self;
}



- (NSDictionary*)trainFaceWithImages:(NSArray*)imagesAndLabels isUpdate:(BOOL)isUpdate
{

    NSMutableArray*trainedFaceDataArray = [[NSMutableArray alloc ] init];
    NSString *fileContent = @"";
    std::vector<cv::Mat> images;
    std::vector<int> labels;
    
    for (int i = 0; i < imagesAndLabels.count; i++){
        
        NSDictionary * tempDict = imagesAndLabels[i];
        
        int labelId = [tempDict[@"imageLabelId"] intValue];
        
        cv::Mat matImg;
        UIImageToMat(tempDict[@"imageData"], matImg);

       
        std::vector<cv::Rect> facesRect = [faceDetector facesFromImage:matImg];
        
        cv::Rect faceRect = facesRect[0];
        if (facesRect.size() <= 0) {
            if (self.delegate != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate errorInFaceRecognition:[FaceRecognizerErrorManager getErrorObject:FACEDETECT_ERROR]];
                });
            }
             return @{
                            @"serializedtrainedData": trainedFaceDataArray,
                            @"trainedModelData": fileContent
                            };;;
        }
        
        cv::Mat faceData = [self pullStandardizedFace:faceRect fromImage:matImg];
    
    
        NSData *serialized = UIImagePNGRepresentation(MatToUIImage(faceData));
        NSMutableDictionary * finalSerializedDataWithLabelId = [[NSMutableDictionary alloc] init];
        [finalSerializedDataWithLabelId setObject:serialized forKey:@"serializedFace"];
        [finalSerializedDataWithLabelId setObject:[NSString stringWithFormat:@"%d",labelId] forKey:@"serializedFaceId"];
        
        [trainedFaceDataArray addObject:finalSerializedDataWithLabelId];
    
        images.push_back(faceData);
        labels.push_back(labelId);

    }
    
    if (images.size() > 0 && labels.size() > 0) {
        
        if (isUpdate){
            _model->update(images, labels);
        }else{
             _model->train(images, labels);
        }
       
        
        _model->save("trainedfaces_at.xml");
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePathStr = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trainedfaces_at.xml"]];
        std::string filePath = std::string([filePathStr UTF8String]);
        _model->write(filePath);
        
        fileContent = [[NSString alloc] initWithContentsOfFile:filePathStr];
        NSLog(@"fileContent : %@",fileContent);

        
         return @{
                        @"serializedtrainedData": trainedFaceDataArray,
                        @"trainedModelData": fileContent
                        };
    }
    else {
        
        if (self.delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate errorInFaceRecognition:[FaceRecognizerErrorManager getErrorObject:FACERECOGNIZER_ERROR]];
            });
        }
        return @{
                 @"serializedtrainedData": trainedFaceDataArray,
                 @"trainedModelData": fileContent
                 };
    }
}




- (NSDictionary*)trainFaceWithFilePaths:(NSArray*)imagePathsAndLabels
{
    NSMutableArray*trainedFaceDataArray = [[NSMutableArray alloc ] init];
   
    std::vector<cv::Mat> images;
    std::vector<int> labels;
    
    for (int i = 0; i < imagePathsAndLabels.count; i++){
       
        NSDictionary * tempDict = imagePathsAndLabels[i];
        
        std::string filePath = std::string([tempDict[@"imagePath"] UTF8String]);
        int labelId = [tempDict[@"imageLabelId"] intValue];
        
        cv::Mat matImg = cv::imread(filePath, cv::COLOR_BGR2GRAY);
        
       std::vector<cv::Rect> facesRect = [faceDetector facesFromImage:matImg];
        
        cv::Rect faceRect = facesRect[0];
        if (facesRect.size() <= 0) {
            if (self.delegate != nil) {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self.delegate errorInFaceRecognition:[FaceRecognizerErrorManager getErrorObject:FACEDETECT_ERROR]];
                });
            }
            return nil;
        }
        
        cv::Mat faceData = [self pullStandardizedFace:faceRect fromImage:matImg];
        
        NSData *serialized = [OpenCVData serializeCvMat:faceData];
        
        NSMutableDictionary * finalSerializedDataWithLabelId = [[NSMutableDictionary alloc] init];
        [finalSerializedDataWithLabelId setObject:serialized forKey:@"serializedFace"];
        [finalSerializedDataWithLabelId setObject:[NSString stringWithFormat:@"%d",labelId] forKey:@"serializedFaceId"];
        
        [trainedFaceDataArray addObject:finalSerializedDataWithLabelId];
    
        images.push_back(faceData);
        labels.push_back(labelId);
        
    }
    
    if (images.size() > 0 && labels.size() > 0) {
        _model->train(images, labels);
        
        _model->save("trainedfaces_at.xml");
        
        NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
        NSString *filePathStr = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"trainedfaces_at.xml"]];
        std::string filePath = std::string([filePathStr UTF8String]);
        _model->write(filePath);
        
        
        NSString *fileContent = [[NSString alloc] initWithContentsOfFile:filePathStr];
        NSLog(@"fileContent : %@",fileContent);
        
      
        return @{
                 @"serializedtrainedData": trainedFaceDataArray,
                 @"trainedModelData": fileContent
                 };
    }
    else {
        
        if (self.delegate != nil) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.delegate errorInFaceRecognition:[FaceRecognizerErrorManager getErrorObject:FACERECOGNIZER_ERROR]];
            });
        }
        return nil;
    }
}


- (cv::Mat)pullStandardizedFace:(cv::Rect)face fromImage:(cv::Mat&)image
{
    // Pull the grayscale face ROI out of the captured image
    cv::Mat onlyTheFace;
    cv::cvtColor(image(face), onlyTheFace, CV_RGB2GRAY);
    
    // Standardize the face to 100x100 pixels
    cv::resize(onlyTheFace, onlyTheFace, cv::Size(100, 100), 0, 0);
    
    return onlyTheFace;
}

- (NSDictionary *)offlineFaceRecognizer:(cv::Rect)face inImage:(cv::Mat&)image inModelFilePath:(std::string&) modelFilePath
{
    
    _model->setThreshold(0.50);
    int predictedLabel = -1;
    double confidence = 0.0;
    
    cv::Mat faceData = [self pullStandardizedFace:face fromImage:image];
    
  
     NSData *predictingImage = UIImagePNGRepresentation(MatToUIImage(faceData));
    
    _model = cv::Algorithm::load<cv::face::LBPHFaceRecognizer>(modelFilePath);
    //_model->train();
    
    _model->predict(faceData, predictedLabel, confidence);
    NSLog(@"confidence : %f",confidence);
    if (confidence < 100.000000){
        std::string result_message = cv::format("Predicted class = %d", predictedLabel);
        std::cout << result_message << std::endl;
    }else{
        predictedLabel = -1;
        std::string result_message = cv::format("Predicted class = %d", predictedLabel);
        std::cout << result_message << std::endl;
    }
    
    
   

    
    return @{
             @"faceID": [NSNumber numberWithInt:predictedLabel],
             @"confidenceLevel": [NSNumber numberWithDouble:confidence],
             @"predictedImage": predictingImage
             };
}


@end
