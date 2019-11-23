//
//  VideoAnalysis.swift
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 16.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

import Foundation
import AVFoundation
import VideoToolbox

public protocol VideoAnalysisDelegate : class{
    func detectionResuslts(result: [Dictionary<String, Any>], frame:UIImage,remainingJobInQueue:Int,remainingJobCountInQueue:Int)
    
}

public class VideoAnalysis: NSObject {
    
    private let videoAnalysissessionQueue = DispatchQueue(label: "videoAnalysissessionQueue")
    public weak var delegate: VideoAnalysisDelegate?
    var processBusy : Bool = false
    private var modelDataHandler: ModelDataHandler?
    private var objectDetection : CaffeDetection?
    private var result: Result?
    private var NetworkType  = ""
    
    public init(networkType : String) {
        super.init()
        NetworkType = networkType
        
        if NetworkType == "TensorFlow"{
            modelDataHandler =
                ModelDataHandler(modelFileInfo: ModelSettings.modelFileInfo, labelsFileInfo: ModelSettings.labelsFileInfo)
        }else{
            objectDetection  = CaffeDetection(caffeModels: ModelSettings.caffeModelFile, prototext: ModelSettings.protoText, treshold: ModelSettings.threshold, inputWidth: Int32(ModelSettings.inputWidth), inputHeight: Int32(ModelSettings.inputHeight), modelLabelMap: ModelSettings.caffeLabelMap, imageBlobScalefactor:ModelSettings.imageBlobScalefactor, imageBlobMeanScalar:ModelSettings.imageBlobMeanScalar, imageBlobSwapRB: ModelSettings.imageBlobSwapRB, imageBlobCrop:ModelSettings.imageBlobCrop)
        }
        
    }
    
    public func processVideo(url:URL){
        self.videoUrl = url
        let asset = AVAsset(url: url)
        let duration = asset.duration
        var frameCount = (Int(duration.value) / Int(duration.timescale))*ModelSettings.videoAnalysisFrameRate
        let numberOfLoop = frameCount / jobScale
        
        for _ in 0...numberOfLoop {
            if frameCount > jobScale{
                frameCount -= jobScale
                frameReadJobList.append(jobScale)
            }else{
                frameReadJobList.append(frameCount)
            }
            
        }
        
        frameReaderJobHandler(url: url)
        
    }
    
    var frameReadJob : Bool = false
    var framecounter = 0
    var frameReadJobList : [Int] = []
    var videoUrl:URL?
    var frameCountStart = 0
    var jobScale = 150
    
    func frameReaderJobHandler(url: URL){
        sleep(5)
        if frameReadJobList.count > 0 {
            
            startFrameReader(frameCount: frameReadJobList[0]+frameCountStart, url: url)
            
        }
        
    }
    func startFrameReader(frameCount : Int, url:URL){
        for i in frameCountStart...frameCount {
            videoAnalysissessionQueue.async {
                self.framecounter += 1
                
                if self.NetworkType == "TensorFlow"{
                    let image = self.thumbnailImageForFileUrl(url, timeScale: i)
                    
                    self.detectionWithResults(withUIImage: image!,remainingJob : (frameCount-self.frameCountStart)-self.framecounter, completion: { (success) -> Void in
                        
                        if success {
                            print("true")
                        } else {
                            print("false")
                        }
                    })
                }else{
                    
                    let image = self.thumbnailImageForFileUrl(url, timeScale: i)
                    self.detectionWithResultsCaffe(withUIImage: image!,remainingJob : (frameCount-self.frameCountStart)-self.framecounter, completion: { (success) -> Void in
                        
                        if success {
                            print("true")
                        } else {
                            print("false")
                        }
                    })
                    
                }
                
                
            }
            
        }
        
        
    }
    
    
    func thumbnailImageForFileUrl(_ fileUrl: URL, timeScale : Int) -> UIImage? {
        let asset = AVAsset(url: fileUrl)
        let imageGenerator = AVAssetImageGenerator(asset: asset)
        imageGenerator.appliesPreferredTrackTransform = true
        
        do {
            
            let thumbnailCGImage = try imageGenerator.copyCGImage(at: CMTimeMake(value: Int64(timeScale), timescale: 10), actualTime: nil)
            return UIImage(cgImage: thumbnailCGImage)
            
        } catch let err {
            print(err)
        }
        
        return nil
    }
    
    public func detectionWithResults(withUIImage image:UIImage,remainingJob:Int, completion: (Bool) -> ()) {
        
        let pixelBuffer = image.toCVPixelBuffer()!
        let result = self.modelDataHandler?.runModel(onFrame: pixelBuffer)
        let inferences : [Inference] =  result!.inferences
        
        var detectionResults : [Dictionary<String, Any>] = []
        
        for dict in inferences {
            
            let convertedCropRect = dict.rect
            
            let confidenceInt = dict.confidence
            let classID = 0
            let className = dict.className
            
            
            let croppedImage  = InternalFunctions().cropImage(image: image.toCVPixelBuffer()!, rect: convertedCropRect)
            
            detectionResults.append(["className":"\(className)", "classId":classID, "borderRect":convertedCropRect,"confidence": confidenceInt, "color":  UIColor.green, "croppedImage": croppedImage])
            
        }
        
        self.delegate?.detectionResuslts(result: detectionResults, frame : image, remainingJobInQueue:remainingJob, remainingJobCountInQueue:self.frameReadJobList.count)
        
        if remainingJob < 0{
            DispatchQueue.main.async {
                if self.frameReadJobList.count > 0 {
                    self.framecounter = 0
                    self.frameReadJobList.remove(at: 0)
                    if self.frameReadJobList.count > 0 {
                        self.frameCountStart += self.frameReadJobList[0]
                        print("self.frameCountStart + : ",self.frameCountStart)
                        self.frameReaderJobHandler(url: self.videoUrl!)
                    }
                    
                }
                
            }
            
        }
        
        completion(true)
    }
    
    public func detectionWithResultsCaffe(withUIImage image:UIImage,remainingJob:Int, completion: (Bool) -> ()) {
        
        var detectedObjects : NSMutableArray = []
        
        detectedObjects = self.objectDetection!.detectObject(image)
        let swiftArray = detectedObjects as NSArray as! [Dictionary<String, Any>]
        
        var detectionResults : [Dictionary<String, Any>] = []
        
        for dict in swiftArray  {
            
            let strRect = dict["boxCGRect"] as! String
            let rectfinal:CGRect = NSCoder.cgRect(for: strRect)
            let convertedCropRect = rectfinal.applying(CGAffineTransform(scaleX: image.size.width/CGFloat(ModelSettings.inputWidth) , y: image.size.height/CGFloat(ModelSettings.inputHeight) ))
            
            let confidence = dict["confidence"] as! String
            let confidenceInt = (confidence as NSString).floatValue
            let classID = (dict["classId"] as! NSString).integerValue
            let className = dict["className"] as! String
            
            
            let croppedImage  = InternalFunctions().cropImage(image: image.toCVPixelBuffer()!, rect: convertedCropRect)
            
            detectionResults.append(["className":"\(className)", "classId":classID, "borderRect":rectfinal,"confidence": confidenceInt, "color":  UIColor.green, "croppedImage": croppedImage])
            
        }
        
        self.delegate?.detectionResuslts(result: detectionResults, frame : image, remainingJobInQueue:remainingJob, remainingJobCountInQueue:self.frameReadJobList.count)
        
        if remainingJob < 0{
            DispatchQueue.main.async {
                if self.frameReadJobList.count > 0 {
                    self.framecounter = 0
                    self.frameReadJobList.remove(at: 0)
                    if self.frameReadJobList.count > 0 {
                        self.frameCountStart += self.frameReadJobList[0]
                        print("self.frameCountStart + : ",self.frameCountStart)
                        self.frameReaderJobHandler(url: self.videoUrl!)
                    }
                    
                }
                
                
            }
            
        }
        
        completion(true)
    }
    
}
