# ThinkerFarm  


### ThinkerFarm V1.0.3  

## Introduction  
Computer Vision Framework for iOS.  

ThinkerFarm is a framework contains sets of wrappers of OpenCV DNN module and Tensorflow Lite. Object Detection module supports Tensorflow model file and Tensorflow Lite model files, Caffe models, ONNX models, Torch model files. ThinkerFarm gives you easy to use iOS Speech Recognition and Speech Synthesizer. On Text recognition i use SwiftyTesseract.

## Features    

[✓] - Object Detection module supports Caffe, ONNX, Torch, Tensorflow model files   
[✓] - Face Recognition module (OpenCV Face Recognition Module)  
[✓] - Speech Recognition  
[✓] - Speech Synthesizer   
[✓] - Custom camer view for real-time detection  
[✓] - Tesseract text recognition  

## Third party frameworks used in project
[✓] - [OpenCV DNN](https://docs.opencv.org/master/d2/d58/tutorial_table_of_content_dnn.html)  
[✓] - [OpenCV Face Recognition](https://docs.opencv.org/2.4/modules/contrib/doc/facerec/facerec_tutorial.html)  
[✓] - [TensorFlowLiteSwift](https://www.tensorflow.org/lite/guide/ios)  
[✓] - [SwiftyTesseract](https://github.com/SwiftyTesseract/SwiftyTesseractl)  

## Usage and Installation  
ThinkerFarm distributed on CocoaPods. If you want to download and use source code it's open source feel free to do whatever you want to do. If you want to use frameowrk on your project follow pod installation below.

## Podfile    
```
use_frameworks!  

target 'YOUR_TARGET_NAME' do  
    use_frameworks!  
    pod 'ThinkerFarm'
end  
Replace YOUR_TARGET_NAME and then, in the Podfile directory, type:  
```
```
$ pod install  
```


## - Preparing ThinkerFarm Universal Framework -  

1 : First build for both simulator and generic device (release)  
2 : Go project root / build/ Products folder  
3 : type :  
```
mkdir ThinkerFarm  
lipo -create -output “ThinkerFarm” “Release-iphonesimulator/ThinkerFarm.framework/ThinkerFarm” “Release-iphoneos/ThinkerFarm.framework/ThinkerFarm”  
```
4 : type :  
```
$ cp -R Release-iphoneos/ThinkerFarm.framework ./ThinkerFarm.framework  
```
5 : type :  
```
$ mv ThinkerFarm ./ThinkerFarm.framework/ThinkerFarm  
```


## [Licence](https://github.com/erkansirin/ThinkerFarm/blob/master/LICENSE)  
