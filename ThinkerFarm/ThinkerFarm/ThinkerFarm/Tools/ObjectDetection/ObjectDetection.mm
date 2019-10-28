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

NSString * caffe_model = @"res10_300x300_ssd_iter_140000";
NSString * caffe_prototxt = @"deploy";

NSString * tensor_model = @"ssd_mobilenet_v2_coco_2018_03_29";
NSString * tensor_prototxt = @"ssd_mobilenet_v2_coco_2018_03_29.pbtxt";

cv::dnn::Net net;
float confThreshold, nmsThreshold;

NSMutableArray * detections;

@implementation ObjectDetection

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        std::string caffePath = [[[NSBundle mainBundle] pathForResource:tensor_model ofType:@"pb"] UTF8String];
        std::string protoPath = [[[NSBundle mainBundle] pathForResource:tensor_prototxt ofType:@"txt"] UTF8String];
        
        //net = cv::dnn::readNet(protoPath,caffePath,"caffe");
        //net.setPreferableTarget(cv::dnn::DNN_TARGET_OPENCL);
        //net = cv::dnn::readNetFromTensorflow(protoPath,caffePath);
        net = cv::dnn::readNet(protoPath , caffePath, "tensorflow");
        //net.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
        
        detections = [[NSMutableArray alloc] init];
        
        NSLog(@"init started");

    }
    
    return self;
}


-(instancetype)initWithCaffeModels:(NSString*)CaffeModel Prototext:(NSString*)Prototext
{
    self = [self init];
    caffe_model = CaffeModel;
    caffe_prototxt = Prototext;
    
 
    std::string caffePath = [[[NSBundle mainBundle] pathForResource:caffe_model ofType:@"caffemodel"] UTF8String];
    std::string protoPath = [[[NSBundle mainBundle] pathForResource:caffe_prototxt ofType:@"prototxt"] UTF8String];

    net = cv::dnn::readNetFromCaffe(protoPath,caffePath);
    net.setPreferableTarget(cv::dnn::DNN_TARGET_OPENCL);
    
    return self;
    
}

- (NSMutableArray*)detectObjectFromImage:(cv::Mat&)frame
{
   
    
    

   // imageBlob = cv2.dnn.blobFromImage(cv2.resize(self.frame,(300,300)), 0.007843, (300, 300), (127.5, 127.5, 127.5), swapRB=False, crop=False)
    
    cvtColor(frame, frame, cv::COLOR_BGR2GRAY);
    cvtColor(frame, frame, cv::COLOR_GRAY2RGB);
    

    resize(frame, frame, cv::Size(300, 300));
    //resize(L, input, cv::Size(W_in, H_in));
    
    UIImage * uiimage;
    uiimage = MatToUIImage(frame);
    

    
    // run the L channel through the network
    //blobFromImage(frame, blob, 1.0, inpSize, Scalar(), swapRB, false, CV_8U);
    cv::Mat inputBlob = cv::dnn::blobFromImage(frame, 1, cv::Size(300,300), cv::Scalar(0, 0, 0),false,false);
    
    //cv::Mat inputBlob;
    
    //cv::dnn::blobFromImage(frame,inputBlob,1, cv::Size(300,300), cv::Scalar(104.0, 177.0, 123.0),false,false);
    //cv::Mat inputBlob = cv::dnn::blobFromImage(frame);
    //print(inputBlob);
    
    std::vector<cv::String> outNames = net.getUnconnectedOutLayersNames();
    std::vector<cv::Mat> outs;

    
    net.setInput(inputBlob);
    net.forward(outs,outNames);
    
    
    static std::vector<int> outLayers = net.getUnconnectedOutLayers();
    static std::string outLayerType = net.getLayer(outLayers[0])->type;
    
    std::vector<int> classIds;
    std::vector<float> confidences;
    std::vector<cv::Rect> boxes;
    if (outLayerType == "DetectionOutput")
    {
        
        
        // Network produces output blob with a shape 1x1xNx7 where N is a number of
        // detections and an every detection is a vector of values
        // [batchId, classId, confidence, left, top, right, bottom]
        CV_Assert(outs.size() > 0);
        for (size_t k = 0; k < outs.size(); k++)
        {
            float* data = (float*)outs[k].data;
            for (size_t i = 0; i < outs[k].total(); i += 7)
            {
                float confidence = data[i + 2];
                if (confidence > 0.01f)
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

        //drawPred(classIds[idx], confidences[idx], box.x, box.y,
                 //box.x + box.width, box.y + box.height, frame);
    }
    
    
        
        
    //sleep(10);
    

    //cvtColor(lab, color, cv::COLOR_Lab2BGR);
    
    return detections;
    
}

@end

