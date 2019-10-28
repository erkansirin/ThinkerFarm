# ThinkerFarm


###ThinkerFarm V1.0.2

##Introduction
Deep Learning &amp; Computer Vision Framework iOS.

Thinker Farm is a framework contains sets of wrappers of OpenCV DNN module and Tensorflow Lite. Object Detection module supports Tensorflow model file and Tensorflow Lite model files, Caffe models, ONNX models, Torch model files. 

##Installation
CocoaPods

##Podfile
use_frameworks!

target 'YOUR_TARGET_NAME' do
    use_frameworks!
    pod 'ThinkerFarm', :git => "https://github.com/erkansirin/ThinkerFarm.git", :tag => "1.0.2"
end
Replace YOUR_TARGET_NAME and then, in the Podfile directory, type:

$ pod install


##Features

[✓] - Object Detection module supports Caffe, ONNX, Torch, Tensorflow model files ([OpenCV DNN](https://docs.opencv.org/master/d2/d58/tutorial_table_of_content_dnn.html) module and Tensorflow Lite wrapper)
[✓] - Face Recognition module (OpenCV Face Recognition Module)
[✓] - Speech Recognition
[✓] - Speech Synthesizer 
[✓] - Custom camer view for real-time detection 
[✓] - Tesseract text recognition ( [SwiftyTesseract](https://github.com/SwiftyTesseract/SwiftyTesseractl)wrapper)  



##[Licence](https://github.com/erkansirin/ThinkerFarm/blob/master/LICENSE)
