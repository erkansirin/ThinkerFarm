# ThinkerFarm  


### ThinkerFarm V1.0.4

##### Table of Contents  
1 - [Introduction](#introduction)  
2 - [Features](#Features)  
3 - [Installation](#Installationt)  
4 - [Documentation](#Documentation)   
5 - [Licence](#Licence)  


## Introduction  
Computer Vision Framework for iOS.  

ThinkerFarm is a framework contains sets of wrappers of OpenCV DNN module and Tensorflow Lite. Object Detection module supports Tensorflow model file and Tensorflow Lite model files, Caffe models, ONNX models, Torch model files. ThinkerFarm gives you easy to use iOS Speech Recognition and Speech Synthesizer. On Text recognition i use SwiftyTesseract.

## Features    

[✓] - Object Detection module supports Caffe, ONNX, Torch, Tensorflow model files   
[✓] - Face Recognition module (OpenCV Face Recognition Module) This module deprecated i no longer update or fix it was experimental purposes only but [here](https://github.com/erkansirin/OpenCVFaceRecognitioniOS) is fully functional example app feel free to clone and play with it  
[✓] - Speech Recognition  
[✓] - Speech Synthesizer   
[✓] - Custom camer view for real-time detection  


## Third party frameworks used in project
[✓] - [OpenCV DNN](https://docs.opencv.org/master/d2/d58/tutorial_table_of_content_dnn.html)  
[✓] - [OpenCV Face Recognition](https://docs.opencv.org/2.4/modules/contrib/doc/facerec/facerec_tutorial.html)  
[✓] - [TensorFlowLiteSwift](https://www.tensorflow.org/lite/guide/ios)  


##  Installation  
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
lipo -create \
simulator/ThinkerFarm.framework/ThinkerFarm \
devices/ThinkerFarm.framework/ThinkerFarm \
-output universal/ThinkerFarm.framework/ThinkerFarm

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

## Documentation
## Using Caffe Module

First of all you can find fully functional example app source code here in [ThinkerFarmExample](https://github.com/erkansirin/ThinkerFarmExample) repository and fully functional ThinkerFarm Application available on Apple Store here 

### CaffeDetector  

####  Create Caffe detector   

Create and intitilize caffe detector CaffeDetectorDelegate  
```
import ThinkerFarm.Swift  

var caffeDetection : CaffeDetector?  
caffeDetection = CaffeDetector()
caffeDetection!.delegate = self

```

```
 func detectionResuslts(result: [DetectionResults]) {
 
 }
 
 ```
 

 After detector detect something on frame it will return strutured data in detectionResuslts function  

 ```
 public struct DetectionResults {
    public let className: String
     public let classId: String
     public let borderRect: CGRect
     public let confidence: Float
     public let color: UIColor
     public let croppedImage : UIImage?
     public let detectionDate : Date
 }
 ```
####   Set caffe model settings   

Your model file name assuming you already trained one or using pretrained model and added to your bundle. Do not include extention name framework handles for you.   
```
ModelSettings.caffeModelFile  = "YOUR CAFFE MODEL FILE NAME"   
```

Your caffe model protoText file name  
```
ModelSettings.protoText = "YOUR CAFFE PROTOTEXT FILE NAME"   
```
Text file contains your class names  
```
ModelSettings.caffeLabelMap = "YOUR CAFFE MODEL CLASSES FILE NAME"  
```
Set scale factor default 1.0  
```
ModelSettings.imageBlobScalefactor = 1.0  
```
Set mean scalar default ["104.0", "177.0", "123.0"]  
```
ModelSettings.imageBlobMeanScalar = ["104.0", "177.0", "123.0"]  
```
Set SwapRB default false  
```
ModelSettings.imageBlobSwapRB = false   
```
Set Blob Crop default false  
```
ModelSettings.imageBlobCrop = false  
```

If you want cropped images in detection delegate response set this true cropped images will return in response as UIImage format  
```  
ModelSettings.returnCroppedImages = true  
```  
Set input size width default 300  
```
ModelSettings.inputWidth = 300  
```
Set input size height default 300  
```
ModelSettings.inputHeight = 300  
```

If you want to hide detection boxes overlay set this true default false   
```
ModelSettings.hideOverlay = false  
```

####  Start detection  
Finally start detection call function detectionWithResults it accepts UIImage and returns structured data  DetectionResults   
```
caffeDetection!.detectionWithResults(withUIImage: image)  
```

### CaffeCamera

CaffeCamera is a camera module ready to use with UIView on Storyboard or just create programaticly. It returns strutured data in detectionResuslts function 

```
@IBOutlet weak var previewView: CaffeCamera!   
```

```
override func viewDidLayoutSubviews() {
    super.viewDidLayoutSubviews()
    
    previewView.setup(frame:self.previewView.frame)
    
}

override func viewDidLoad() {
super.viewDidLoad()

resourceReport.delegate = self


}
```





### TensorFlowDetection  

####  Create TensorFlow detector   

Create and intitilize TensorFlow detector TensorFlowDetectionDelegate  
```
import ThinkerFarm.Swift  

var detector : TensorFlowDetection?
detector = TensorFlowDetection()
detector!.delegate = self

```

```
 func detectionResuslts(result: [DetectionResults]) {
 
 }
 
 ```
 

 After detector detect something on frame it will return strutured data in detectionResuslts function  

 ```
 public struct DetectionResults {
    public let className: String
     public let classId: String
     public let borderRect: CGRect
     public let confidence: Float
     public let color: UIColor
     public let croppedImage : UIImage?
     public let detectionDate : Date
 }
 ```
####   Set TensorFlow model settings   

It accept TensorFlow Lite models if you want to train and convert one using [ThinkerFarmTrainer](https://github.com/erkansirin/ThinkerFarmTrainer)    

Set your TFLite model file  
```
ModelSettings.modelFileInfo  = (name: "YOUR MODEL FILE NAME", extension: "tflite")  
```
Set your Label file 
```
ModelSettings.labelsFileInfo = (name: "YOUR LABEL FILE NAME", extension: "txt")  
```
Set detection input size default 300  
```
ModelSettings.inputWidth = 300  
```
Set detection input size default 300  
```
ModelSettings.inputHeight = 300    
```
If you want cropped images in detection delegate response set this true cropped images will return in response as UIImage format  
```
ModelSettings.returnCroppedImages = true  
```
If you want to hide detection boxes overlay set this true default false   
```
ModelSettings.hideOverlay = false  
```





####  Start detection  
Finally start detection call function detectionWithResults it accepts UIImage and returns structured data  DetectionResults   
```
self.detector!.detectionWithResults(withUIImage: image)
```

### TensorFlowCamera

TensorFlowCamera is a camera module ready to use with UIView on Storyboard or just create programaticly. It returns strutured data in detectionResuslts function 

```
@IBOutlet weak var previewView: TensorFlowCamera!
```

```
override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       
       previewView.setup(frame:self.previewView.frame)

   }

override func viewDidLoad() {
super.viewDidLoad()

previewView.delegate = self


}
```


### TensorFlowCamera

TensorFlowCamera is a camera module ready to use with UIView on Storyboard or just create programaticly. It returns strutured data in detectionResuslts function 

```
@IBOutlet weak var previewView: TensorFlowCamera!
```

```
override func viewDidLayoutSubviews() {
       super.viewDidLayoutSubviews()
       
       previewView.setup(frame:self.previewView.frame)

   }

override func viewDidLoad() {
super.viewDidLoad()

previewView.delegate = self


}
```

### VideoAnalysis   

Create and initilize VideoAnalysis. It accept video url and returns detection result in array of dictionaries, remaining job in que, video frame as UIImage format. Model settings is same as above. You have to tell network type while initilizing.  Get result from VideoPickerDelegate 

```
var videoAnalysis : VideoAnalysis?

videoAnalysis  = VideoAnalysis(networkType: "TensorFlow") or videoAnalysis  = VideoAnalysis(networkType: "Caffe")
videoAnalysis!.delegate = self

self.videoAnalysis!.processVideo(url:url)

func detectionResuslts(result: [Dictionary<String, Any>], frame: UIImage,remainingJobInQueue:Int,remainingJobCountInQueue:Int) {
}
```


# Licence
## [Licence](https://github.com/erkansirin/ThinkerFarm/blob/master/LICENSE)  
