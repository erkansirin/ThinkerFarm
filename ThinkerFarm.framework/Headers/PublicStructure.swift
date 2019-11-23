//
//  PublicStructure.swift
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 23.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

import Foundation

public struct DetectionResults {
   public let className: String
    public let classId: String
    public let borderRect: CGRect
    public let confidence: Float
    public let color: UIColor
    public let croppedImage : UIImage?
    public let detectionDate : Date
}

public enum ModelSettings {
    public static var modelFileInfo: FileInfo = (name: "facelandmark", extension: "tflite")
    public static var labelsFileInfo: FileInfo = (name: "facelabelmap", extension: "txt")
    
    public static var caffeModelFile = ""
    public static var protoText = ""
    public static var caffeLabelMap = ""
    public static var imageBlobScalefactor : Float = 1.0
    public static var imageBlobMeanScalar = ["104.0", "177.0", "123.0"]
    public static var imageBlobSwapRB = false
    public static var imageBlobCrop = false
    
    

    public static var batchSize = 1
    public static var inputChannels = 3
    public static var inputWidth = 300
    public static var inputHeight = 300
    public static var threshold: Float = 0.45
    
    public static var hideOverlay : Bool = false
    public static var hideClassLabels : Bool = false
    public static var hideBoxBackground : Bool = false
    public static var HideBox : Bool = false
    
    public static var returnCroppedImages : Bool = false
    public static var detectionType = 1
    public static var videoAnalysisFrameRate = 30
    
    

}
