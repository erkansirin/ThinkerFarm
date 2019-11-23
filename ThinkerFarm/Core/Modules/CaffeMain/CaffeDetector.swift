//
//  CaffeDetection.swift
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 14.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//


import Foundation

public protocol CaffeDetectorDelegate : class{
    func detectionResuslts(result: [DetectionResults])
}

public class CaffeDetector: NSObject {
    
    var objectDetection : CaffeDetection = CaffeDetection(caffeModels: ModelSettings.caffeModelFile, prototext: ModelSettings.protoText, treshold: ModelSettings.threshold, inputWidth: Int32(ModelSettings.inputWidth), inputHeight: Int32(ModelSettings.inputHeight), modelLabelMap: ModelSettings.caffeLabelMap, imageBlobScalefactor:ModelSettings.imageBlobScalefactor, imageBlobMeanScalar:ModelSettings.imageBlobMeanScalar, imageBlobSwapRB: ModelSettings.imageBlobSwapRB, imageBlobCrop:ModelSettings.imageBlobCrop)
    
    var detectedObjects : NSMutableArray = []
    private let edgeOffset: CGFloat = 2.0
    private var result: Result?
    public weak var delegate: CaffeDetectorDelegate?
    
    public override init() {
        super.init()
        
    }
    
    public func detectionWithResults(withUIImage image:UIImage) {
        
        self.detectedObjects = self.objectDetection.detectObject(image)
        
        var detectionResults : [DetectionResults] = []
        
        for inference in self.detectedObjects  {
            
            let dict : NSDictionary
            dict = inference as! NSDictionary
            
            var strRect : String = ""
            strRect = dict["boxCGRect"] as! String
            let rectfinal:CGRect = NSCoder.cgRect(for: strRect)
            
            let convertedCropRect = rectfinal.applying(CGAffineTransform(scaleX: image.size.width/CGFloat(ModelSettings.inputWidth) , y: image.size.height/CGFloat(ModelSettings.inputHeight) ))
            
            var confidence : String = ""
            confidence = dict["confidence"] as! String
            let confidenceInt = (confidence as NSString).floatValue
            
            let classID = (dict["classId"] as! NSString).integerValue
            
            let className = dict["className"] as! String
            
            if ModelSettings.returnCroppedImages != true{
                let detectionResultsDictionary = DetectionResults(className: "\(className)",  classId: "\(classID)", borderRect: rectfinal, confidence: confidenceInt, color:  UIDecorators.colorCodeTurkuazBlue, croppedImage: nil, detectionDate: Date())
                detectionResults.append(detectionResultsDictionary)
            }else{
                let croppedImage  = InternalFunctions().cropImage(image: image.toCVPixelBuffer()!, rect: convertedCropRect)
                let detectionResultsDictionary = DetectionResults(className: "\(className)",  classId: "\(classID)", borderRect: rectfinal, confidence: confidenceInt, color:  UIDecorators.colorCodeTurkuazBlue, croppedImage: croppedImage, detectionDate: Date())
                detectionResults.append(detectionResultsDictionary)
            }
            
        }
        
        delegate?.detectionResuslts(result: detectionResults)
    }
    
}

