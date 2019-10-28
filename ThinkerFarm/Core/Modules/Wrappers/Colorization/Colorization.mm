
//
//  Colorization.m
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 16.08.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Colorization.h"

NSString * const colorization_caffe_model = @"colorization_release_v2";
NSString * const colorization_caffe_prototxt = @"colorization_deploy_v2";
NSString * const colorization_image = @"ansel_adams3";

@implementation Colorization

- (instancetype)init
{
    self = [super init];
    if (self) {

    }
    
    return self;
}

- (cv::Mat)colorizeFromImage:(cv::Mat&)image
{
    NSLog(@"starting to load netwrok");
    
    
    static float hull_pts[] = {
        -90., -90., -90., -90., -90., -80., -80., -80., -80., -80., -80., -80., -80., -70., -70., -70., -70., -70., -70., -70., -70.,
        -70., -70., -60., -60., -60., -60., -60., -60., -60., -60., -60., -60., -60., -60., -50., -50., -50., -50., -50., -50., -50., -50.,
        -50., -50., -50., -50., -50., -50., -40., -40., -40., -40., -40., -40., -40., -40., -40., -40., -40., -40., -40., -40., -40., -30.,
        -30., -30., -30., -30., -30., -30., -30., -30., -30., -30., -30., -30., -30., -30., -30., -20., -20., -20., -20., -20., -20., -20.,
        -20., -20., -20., -20., -20., -20., -20., -20., -20., -10., -10., -10., -10., -10., -10., -10., -10., -10., -10., -10., -10., -10.,
        -10., -10., -10., -10., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 0., 10., 10., 10., 10., 10., 10., 10.,
        10., 10., 10., 10., 10., 10., 10., 10., 10., 10., 10., 20., 20., 20., 20., 20., 20., 20., 20., 20., 20., 20., 20., 20., 20., 20.,
        20., 20., 20., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 30., 40., 40., 40., 40.,
        40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 40., 50., 50., 50., 50., 50., 50., 50., 50., 50., 50.,
        50., 50., 50., 50., 50., 50., 50., 50., 50., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60., 60.,
        60., 60., 60., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 70., 80., 80., 80.,
        80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 80., 90., 90., 90., 90., 90., 90., 90., 90., 90., 90.,
        90., 90., 90., 90., 90., 90., 90., 90., 90., 100., 100., 100., 100., 100., 100., 100., 100., 100., 100., 50., 60., 70., 80., 90.,
        20., 30., 40., 50., 60., 70., 80., 90., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90., -20., -10., 0., 10., 20., 30., 40., 50.,
        60., 70., 80., 90., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90., 100., -40., -30., -20., -10., 0., 10., 20.,
        30., 40., 50., 60., 70., 80., 90., 100., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90., 100., -50.,
        -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90., 100., -60., -50., -40., -30., -20., -10., 0., 10., 20.,
        30., 40., 50., 60., 70., 80., 90., 100., -70., -60., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90.,
        100., -80., -70., -60., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90., -80., -70., -60., -50.,
        -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., 90., -90., -80., -70., -60., -50., -40., -30., -20., -10.,
        0., 10., 20., 30., 40., 50., 60., 70., 80., 90., -100., -90., -80., -70., -60., -50., -40., -30., -20., -10., 0., 10., 20., 30.,
        40., 50., 60., 70., 80., 90., -100., -90., -80., -70., -60., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70.,
        80., -110., -100., -90., -80., -70., -60., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., -110., -100.,
        -90., -80., -70., -60., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., 80., -110., -100., -90., -80., -70.,
        -60., -50., -40., -30., -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., -110., -100., -90., -80., -70., -60., -50., -40., -30.,
        -20., -10., 0., 10., 20., 30., 40., 50., 60., 70., -90., -80., -70., -60., -50., -40., -30., -20., -10., 0.
    };
    
    
    
    NSString *colorization_caffe_model_path = [[NSBundle mainBundle] pathForResource:colorization_caffe_model ofType:@"caffemodel"];
    
    
    
    NSString *colorization_caffe_prototxt_path = [[NSBundle mainBundle] pathForResource:colorization_caffe_prototxt ofType:@"prototxt"];
    
    NSString *colorization_image_path = [[NSBundle mainBundle] pathForResource:colorization_image ofType:@"jpg"];
    
    
    
    NSLog(@"colorization_caffe_model_path : %@",colorization_caffe_model_path);
    NSLog(@"colorization_caffe_prototxt_path : %@",colorization_caffe_prototxt_path);
    NSLog(@"colorization_image_path : %@",colorization_image_path);

    
    std::string modelTxt = [colorization_caffe_prototxt_path UTF8String];
    std::string modelBin = [colorization_caffe_model_path UTF8String];
    std::string imageFile = [colorization_image_path UTF8String];
    
    cv::Mat img;
    
    //cv::Mat img = cv::imread(imageFile);
    //cvtColor(image, image, cv::COLOR_BGR2GRAY);
    //cvtColor(image, image, cv::COLOR_GRAY2BGR);
    
    img = image;

    

    
    const int W_in = 224;
    const int H_in = 224;
    
    cv::dnn::Net net;
    net = cv::dnn::readNetFromCaffe(modelTxt,modelBin);
    net.setPreferableTarget(cv::dnn::DNN_TARGET_CPU);
    
    
    
    int sz[] = {2, 313, 1, 1};
    const cv::Mat pts_in_hull(4, sz, CV_32F, hull_pts);
    cv::Ptr<cv::dnn::Layer> class8_ab = net.getLayer("class8_ab");
    class8_ab->blobs.push_back(pts_in_hull);
    cv::Ptr<cv::dnn::Layer> conv8_313_rh = net.getLayer("conv8_313_rh");
    conv8_313_rh->blobs.push_back(cv::Mat(1, 313, CV_32F, cv::Scalar(2.606)));
    
    
    // extract L channel and subtract mean
    cv::Mat lab, L, input, output;
    img.convertTo(output, CV_32F, 1.0/255);
    return output;
    //cvtColor(img, output, cv::COLOR_BGR2RGB);
    //cvtColor(output, output, cv::COLOR_GRAY2RGB);
    //cvtColor(output, output, cv::COLOR_RGB2BGR);
    
    
    cvtColor(output, lab, cv::COLOR_BGR2Lab);
    
    extractChannel(lab, L, 0);
    resize(L, input, cv::Size(W_in, H_in));
    input -= 50;
    
    
    // run the L channel through the network
    cv::Mat inputBlob = cv::dnn::blobFromImage(input);
    net.setInput(inputBlob);
    cv::Mat result;
    net.forward(result);
    //sleep(10);
    
    // retrieve the calculated a,b channels from the network output
    cv::Size siz(result.size[2], result.size[3]);
    cv::Mat a = cv::Mat(siz, CV_32F, result.ptr(0,0));
    cv::Mat b = cv::Mat(siz, CV_32F, result.ptr(0,1));
    resize(a, a, img.size());
    resize(b, b, img.size());
    
    // merge, and convert back to BGR
    cv::Mat color, chn[] = {L, a, b};
    merge(chn, 3, lab);
    //print(chn[2]);
    
    cvtColor(lab, color, cv::COLOR_Lab2BGR);
    
    return color;

}

@end
