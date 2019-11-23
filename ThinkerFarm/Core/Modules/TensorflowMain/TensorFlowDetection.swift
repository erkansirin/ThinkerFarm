//
//  RunTensorflowModel.swift
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 9.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

import Foundation

public protocol TensorFlowDetectionDelegate : class{
    func firstFrameForHeatMap(image: UIImage)
    func detectionResuslts(result: [DetectionResults])
    
}

public class TensorFlowDetection: NSObject {
    
    private var modelDataHandler: ModelDataHandler? =
        ModelDataHandler(modelFileInfo: ModelSettings.modelFileInfo, labelsFileInfo: ModelSettings.labelsFileInfo)
    
    
    private var result: Result?
    public weak var delegate: TensorFlowDetectionDelegate?
    
    
    public override init() {
        super.init()
        
        
    }
    
    public func detectionWithResults(withUIImage image:UIImage) {
        
        let pixelBuffer = InternalFunctions().buffer(from: image)
        let result = self.modelDataHandler?.runModel(onFrame: pixelBuffer!)
        
        let inferences : [Inference] =  result!.inferences
        var detectionResults : [DetectionResults] = []
        
        for inference in inferences {
            
            if ModelSettings.returnCroppedImages != true{
                let detectionResultsDictionary = DetectionResults(className: "\(inference.className)", classId: "\(inference.className)", borderRect: inference.rect, confidence: inference.confidence, color: UIDecorators.colorCodeTurkuazBlue, croppedImage: nil, detectionDate: Date())
                detectionResults.append(detectionResultsDictionary)
            }else{
                let croppedImage  = InternalFunctions().cropImage(image: pixelBuffer!, rect: inference.rect)
                let detectionResultsDictionary = DetectionResults(className: "\(inference.className)", classId: "\(inference.className)", borderRect: inference.rect, confidence: inference.confidence, color: UIDecorators.colorCodeTurkuazBlue, croppedImage: croppedImage, detectionDate: Date())
                detectionResults.append(detectionResultsDictionary)
            }
            
        }
        
        
        delegate?.detectionResuslts(result: detectionResults) 
    }
    
}
