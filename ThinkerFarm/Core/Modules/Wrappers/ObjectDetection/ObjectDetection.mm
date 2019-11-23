//
//  ObjectDetection.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 20.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ObjectDetection.h"
#import "OpenCVData.h"



NSString * tensor_model = @"ssd_mobilenet_v2_coco_2018_03_29";
NSString * tensor_prototxt = @"ssd_mobilenet_v2_coco_2018_03_29.pbtxt";
NSMutableString *text;

cv::dnn::Net net;
cv::Scalar imageBlobScalar;
BOOL SwapRB;
BOOL Crop;
NSString * caffeLabelMap =@"";
float confThreshold, nmsThreshold, modelThreshold, scalefactor;
int inputWidthLocal,inputHeightLocal;



@implementation ObjectDetection

- (instancetype)init
{
    self = [super init];
    if (self) {
        
     

    }
    
    return self;
}



-(instancetype)initWithCaffeModels:(NSString*)CaffeModel Prototext:(NSString*)Prototext Treshold:(float)treshold inputWidth:(int)inputWidth inputHeight:(int)inputHeight modelLabelMap:(NSString*)modelLabelMap imageBlobScalefactor:(float)imageBlobScalefactor imageBlobMeanScalar:(NSArray*)imageBlobMeanScalar imageBlobSwapRB:(BOOL)imageBlobSwapRB imageBlobCrop:(BOOL)imageBlobCrop
{
    self = [self init];

    if (imageBlobMeanScalar.count == 3) {
        float sc1 = [imageBlobMeanScalar[0] floatValue];
        float sc2 = [imageBlobMeanScalar[0] floatValue];
        float sc3 = [imageBlobMeanScalar[0] floatValue];

        imageBlobScalar = cv::Scalar(sc1, sc2, sc3);
    }
    
    if (imageBlobMeanScalar.count == 2) {
        int sc1 = [imageBlobMeanScalar[0] intValue];
        int sc2 = [imageBlobMeanScalar[0] intValue];

        imageBlobScalar = cv::Scalar(sc1, sc2);
    }
    
    if (imageBlobMeanScalar.count == 1) {
        int sc1 = [imageBlobMeanScalar[0] intValue];
    
        imageBlobScalar = cv::Scalar(sc1);
    }
    
    Crop = imageBlobCrop;
    SwapRB = imageBlobSwapRB;
    
    scalefactor = imageBlobScalefactor;

        
        
    
    

    
    
    modelThreshold = treshold;
    inputWidthLocal = inputWidth;
    inputHeightLocal = inputHeight;
    std::string caffePath;
    std::string protoPath;
    
    NSString *pathcaffemodel = [[NSBundle mainBundle] pathForResource:CaffeModel ofType:@"caffemodel"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathcaffemodel])
    {
        caffePath = [pathcaffemodel UTF8String];
    }
    else
    {
        NSLog(@"caffemodel not found");
    }
    
    NSString *pathprototxt = [[NSBundle mainBundle] pathForResource:CaffeModel ofType:@"prototxt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathprototxt])
    {
        protoPath =  [pathprototxt UTF8String];
    }
    else
    {
        NSLog(@"protoPath not found");
    }
    
    NSString *pathtxt = [[NSBundle mainBundle] pathForResource:CaffeModel ofType:@"txt"];
    if ([[NSFileManager defaultManager] fileExistsAtPath:pathtxt])
    {
        caffeLabelMap = pathprototxt;
    }
    else
    {
        NSLog(@"txt not found");
    }
    
    
//    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//    NSString *documentsDirectory = [paths objectAtIndex:0];
//    NSString *filePath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caffemodel",CaffeModel]];
//    NSString *content = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:NULL];
    
    
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentsDirectory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    NSString *caffepath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.caffemodel",CaffeModel]];
    if([fileManager fileExistsAtPath:caffepath])
    {
        caffePath = [caffepath UTF8String];
        NSLog(@"caffemodel found");
    }else{
        NSLog(@"caffemodel not found in doc");
    }
    
    
    NSString *protopath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.prototxt",CaffeModel]];
    if([fileManager fileExistsAtPath:protopath])
    {
        protoPath = [protopath UTF8String];
        NSLog(@"protopath found");
    }else{
        NSLog(@"protopath not found in doc");
        
    }
    
    
    NSString *txtpath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"%@.txt",CaffeModel]];
    if([fileManager fileExistsAtPath:txtpath])
    {
        caffeLabelMap = txtpath;
        NSLog(@"caffeLabelMap found");
    }else{
        NSLog(@"caffeLabelMap not found in doc");
        
    }
    


//    std::string caffePath = [[[NSBundle mainBundle] pathForResource:CaffeModel ofType:@"caffemodel"] UTF8String];
//    std::string protoPath = [[[NSBundle mainBundle] pathForResource:Prototext ofType:@"prototxt"] UTF8String];
//    caffeLabelMap = [[NSBundle mainBundle] pathForResource:modelLabelMap ofType:@"txt"];
    
    NSURL *fileURL = [NSURL fileURLWithPath:caffeLabelMap];
    text = [NSMutableString stringWithContentsOfURL:fileURL encoding:NSUTF8StringEncoding error:nil];
    
    net = cv::dnn::readNetFromCaffe(protoPath,caffePath);
    net.setPreferableTarget(cv::dnn::DNN_TARGET_OPENCL);
    
    return self;
    
}

- (NSMutableArray*)detectObjectFromImage:(cv::Mat&)frame
{
   
    
    NSMutableArray *detections = [[NSMutableArray alloc] init];
    NSArray *parsed = [text componentsSeparatedByCharactersInSet:[NSCharacterSet newlineCharacterSet]];
    
    

    
    cvtColor(frame, frame, cv::COLOR_BGR2GRAY);
    cvtColor(frame, frame, cv::COLOR_GRAY2RGB);
    

    resize(frame, frame, cv::Size(inputWidthLocal, inputHeightLocal));

    UIImage * uiimage;
    uiimage = MatToUIImage(frame);
    

    
    cv::Mat inputBlob;


    
    
    cv::dnn::blobFromImage(frame,inputBlob,scalefactor, cv::Size(inputWidthLocal,inputHeightLocal), imageBlobScalar,SwapRB,Crop);

    
    std::vector<cv::String> outNames = net.getUnconnectedOutLayersNames();
    std::vector<cv::Mat> outs;

    
    net.setInput(inputBlob);
    net.forward(outs,outNames);
    
    
    static std::vector<int> outLayers = net.getUnconnectedOutLayers();
    static std::string outLayerType = net.getLayer(outLayers[0])->type;
    
    std::vector<int> classIds;
    std::vector<float> confidences;
    std::vector<cv::Rect> boxes;
    //NSLog(@"caffeLabelMap 2: %@",caffeLabelMap);
    if (outLayerType == "DetectionOutput")
    {
        
 
        CV_Assert(outs.size() > 0);
        for (size_t k = 0; k < outs.size(); k++)
        {
            float* data = (float*)outs[k].data;
            for (size_t i = 0; i < outs[k].total(); i += 7)
            {
                float confidence = data[i + 2];
                if (confidence > modelThreshold)
                {
                    int left   = (int)data[i + 3];
                    int top    = (int)data[i + 4];
                    int right  = (int)data[i + 5];
                    int bottom = (int)data[i + 6];
                    int width  = right - left + 1;
                    int height = bottom - top + 1;
                    if (width * height <= 1)
                    {
                        left   = (int)(data[i + 3] * frame.cols);
                        top    = (int)(data[i + 4] * frame.rows);
                        right  = (int)(data[i + 5] * frame.cols);
                        bottom = (int)(data[i + 6] * frame.rows);
                        width  = right - left + 1;
                        height = bottom - top + 1;
                    }
                    
                    NSMutableDictionary * detectionObjects;
                    detectionObjects = [[NSMutableDictionary alloc] init];
                    
                    int classid;
                    classid = (int)(data[i + 1]) - 1;
                    classIds.push_back((int)(data[i + 1]) - 1);  // Skip 0th background class id.
                    
                    cv::Rect rectt(left, top, width, height);
                    CGRect objectRect;
                    objectRect = [OpenCVData faceToCGRect:rectt];
                    
                    boxes.push_back(rectt);
                    confidences.push_back(confidence);
                    
                    
                    
                    
                    [detectionObjects setObject:[NSString stringWithFormat:@"%d",classid] forKey:@"classId"];
                    
                    [detectionObjects setObject:[NSString stringWithFormat:@"%@",parsed[classid]] forKey:@"className"];
                    
                    
                    [detectionObjects setObject:NSStringFromCGRect(objectRect) forKey:@"boxCGRect"];
                    [detectionObjects setObject:[NSString stringWithFormat:@"%f",confidence] forKey:@"confidence"];
                    
                   
                    
                    
                    [detections addObject:detectionObjects];
                    
                    
            
                }
            }
        }
    }
    
     else
         CV_Error(cv::Error::StsNotImplemented, "Unknown output layer type: " + outLayerType);
    
    
    std::vector<int> indices;
    cv::dnn::NMSBoxes(boxes, confidences, confThreshold, nmsThreshold, indices);
    for (size_t i = 0; i < indices.size(); ++i)
    {
        int idx = indices[i];
        cv::Rect box = boxes[idx];

     
    }
    
    
 
    
    return detections;
    
}

@end

