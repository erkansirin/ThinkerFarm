//
//  CaffeCamera.swift.swift
//  ThinkerFarm
//
//  Created by Erkan SIRIN on 11.11.2019.
//  Copyright © 2019 Thinker Farm. All rights reserved.
//

import Foundation

import UIKit
import AVFoundation


public class CaffeCamera: UIView,CameraFeedManagerDelegate, UIGestureRecognizerDelegate {
    
    func presentCameraPermissionsDeniedAlert() {
        
    }
    
    func presentVideoConfigurationErrorAlert() {
        
    }
    
    func sessionRunTimeErrorOccured() {
        
    }
    
    func sessionWasInterrupted(canResumeManually resumeManually: Bool) {
        
    }
    
    func sessionInterruptionEnded() {
        
    }
    
    
    var previewView: PreviewView!
    var overlayView: OverlayView!
    
    
    
    public var synchronousVideo : Bool = false
    var syncView = UIImageView()
    var usingFrontCamera : Bool = false
    let isoLabel = UILabel()
    let pinchImageViewer = UIImageView()
    var detectedObjects : NSMutableArray = []
    
    var isCameraSwitched : Bool = false
    
    
    var pinchimage : UIImage!
    var button : UIButton!
    var buttonimage : UIImage!
    var buttonimage2 : UIImage!
    var buttonLight : UIButton!
    let slider = UISlider()
    
    
    let minimumZoom: CGFloat = 1.0
    let maximumZoom: CGFloat = 4.0
    var lastZoomFactor: CGFloat = 1.0
    
    var countdownTimer: Timer!
    var totalTime = 5
    
    private let displayFont = UIFont.systemFont(ofSize: 14.0, weight: .medium)
    private let edgeOffset: CGFloat = 2.0
    private let delayBetweenInferencesMs: Double = 10
    private var previousInferenceTimeMs: TimeInterval = Date.distantPast.timeIntervalSince1970 * 1000
    
    public weak var delegate: CaffeDetectorDelegate?
    lazy var cameraFeedManager = CameraFeedManager(previewView: previewView)
    var objectDetection : CaffeDetection?
    
    
    override init (frame: CGRect) {
        super.init(frame: frame)
        setup(frame:frame)
    }
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)!
        
    }
    
    public func setup (frame:CGRect) {
        
        
        self.translatesAutoresizingMaskIntoConstraints = false
        
        previewView = PreviewView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
        cameraFeedManager.delegate = self
        self.addSubview(previewView)
        
        syncView.frame = CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height)
        self.addSubview(syncView)
        
        
        let zoomGesture = UIPinchGestureRecognizer(target: self , action: #selector(handleZoom(_:)))
        zoomGesture.delegate = self
        self.isMultipleTouchEnabled = true
        self.isUserInteractionEnabled = true
        self.addGestureRecognizer(zoomGesture)
        
        
        
        pinchimage = UIImage (named: "pinch-to-zoom", in: Bundle(for: type(of: self)), compatibleWith: nil)
        pinchImageViewer.image = pinchimage
        
        
        
        button = UIButton(frame: CGRect(x: frame.size.width-60, y: frame.size.height-85, width: 50, height: 50))
        print("self.bounds.size.height : ",frame.size.height)
        //button.backgroundColor = .green
        buttonimage = UIImage (named: "camerachange", in: Bundle(for: type(of: self)), compatibleWith: nil)
        
        button.setImage(buttonimage, for: UIControl.State.normal)
        button.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
        
        buttonimage2 = UIImage (named: "flashlight", in: Bundle(for: type(of: self)), compatibleWith: nil)
        buttonLight = UIButton(frame: CGRect(x: 5, y: frame.size.height-85, width: 50, height: 50))
        //sbuttonLight.backgroundColor = .green
        buttonLight.setImage(buttonimage2, for: UIControl.State.normal)
        buttonLight.addTarget(self, action: #selector(lightButtonAction), for: .touchUpInside)
        
        
        if ModelSettings.hideOverlay != true{
            
            overlayView = OverlayView(frame: CGRect(x: 0, y: 0, width: frame.size.width, height: frame.size.height))
            
            
            overlayView.backgroundColor = .clear
            overlayView.clearsContextBeforeDrawing = true
            self.addSubview(overlayView)
            
            overlayView.layer.zPosition = .greatestFiniteMagnitude
        }
        
        self.addSubview(button)
        self.addSubview(buttonLight)
        
        
        slider.frame = CGRect(x: (frame.size.width/2)-75 , y: frame.size.height-85, width: 150, height: 35)
        //slider.center = self.center
        print("self.bounds.size.width : ",frame.size.width)
        
        slider.minimumTrackTintColor = .white
        slider.maximumTrackTintColor = .red
        slider.thumbTintColor = .systemBlue
        
        slider.maximumValue = 1500
        slider.minimumValue = 0
        slider.setValue(cameraFeedManager.camera!.iso, animated: false)
        
        slider.addTarget(self, action: #selector(self.changeVlaue(_:)), for: .valueChanged)
        
        self.addSubview(slider)
        
        
        isoLabel.frame = CGRect(x: (frame.size.width/2)-75 , y: frame.size.height-110, width: 150, height: 35)
        isoLabel.text = "Camera ISO : \(slider.value)"
        isoLabel.font = isoLabel.font.withSize(14)
        self.addSubview(isoLabel)
        pinchImageViewer.frame = CGRect(x: (frame.size.width/2)-125, y: 150, width: 250, height: 250)
        self.addSubview(pinchImageViewer)
        startTimer()
        
        startCameraSession()
        
        
    }
    
    func startTimer() {
        countdownTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateTime), userInfo: nil, repeats: true)
    }
    
    @objc func updateTime() {
        
        if totalTime != 0 {
            totalTime -= 1
        } else {
            
            endTimer()
            
            UIView.animate(withDuration: 1.25, delay: 0.0, options: [], animations: {
                self.pinchImageViewer.alpha = 0
            }, completion: { (finished: Bool) in
                self.pinchImageViewer.isHidden = true
            })
            
        }
    }
    
    func endTimer() {
        countdownTimer.invalidate()
    }
    
    @objc func lightButtonAction(sender: UIButton!) {
        toggleFlash()
    }
    
    @objc  func toggleFlash() {
        guard let device = AVCaptureDevice.default(for: AVMediaType.video) else { return }
        guard device.hasTorch else { return }
        
        do {
            try device.lockForConfiguration()
            
            if (device.torchMode == AVCaptureDevice.TorchMode.on) {
                device.torchMode = AVCaptureDevice.TorchMode.off
            } else {
                do {
                    try device.setTorchModeOn(level: 1.0)
                } catch {
                    print(error)
                }
            }
            
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    @objc func changeVlaue(_ sender: UISlider) {
        print("value is" , Int(sender.value));
        isoLabel.text = "Camera ISO : \(Int(sender.value))"
        
        var newiso = sender.value
        newiso = max(cameraFeedManager.camera!.activeFormat.minISO, newiso)
        newiso = min(cameraFeedManager.camera!.activeFormat.maxISO, newiso)
        
        guard newiso != cameraFeedManager.camera!.iso, (try? cameraFeedManager.camera!.lockForConfiguration()) != nil else { return }
        
        cameraFeedManager.camera!.setExposureModeCustom(duration: AVCaptureDevice.currentExposureDuration , iso: newiso) { (_) in
            
        }
        cameraFeedManager.camera!.unlockForConfiguration()
        
    }
    
    @objc func buttonAction(sender: UIButton!) {
        
        isCameraSwitched = true
        
        usingFrontCamera = !usingFrontCamera
        do{
            cameraFeedManager.session.removeInput(cameraFeedManager.session.inputs.first!)
            
            if(usingFrontCamera){
                cameraFeedManager.camera = getFrontCamera()
            }else{
                cameraFeedManager.camera = getBackCamera()
            }
            let captureDeviceInput1 = try AVCaptureDeviceInput(device: cameraFeedManager.camera!)
            cameraFeedManager.session.addInput(captureDeviceInput1)
            
            
        }catch{
            print(error.localizedDescription)
        }
        
    }
    
    func getFrontCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .front).devices.first
        return nil
    }
    
    func getBackCamera() -> AVCaptureDevice?{
        return AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera], mediaType: AVMediaType.video, position: .back).devices.first
        return nil
    }
    
    @objc func handleZoom(_ gesture: UIPinchGestureRecognizer) {
        
        guard let device = cameraFeedManager.camera else { return }
        
        // Return zoom value between the minimum and maximum zoom values
        func minMaxZoom(_ factor: CGFloat) -> CGFloat {
            return min(min(max(factor, minimumZoom), maximumZoom), device.activeFormat.videoMaxZoomFactor)
        }
        
        func update(scale factor: CGFloat) {
            do {
                try device.lockForConfiguration()
                defer { device.unlockForConfiguration() }
                device.videoZoomFactor = factor
                
            } catch {
                print("\(error.localizedDescription)")
            }
        }
        
        let newScaleFactor = minMaxZoom(gesture.scale * lastZoomFactor)
        
        switch gesture.state {
        case .began: fallthrough
        case .changed: update(scale: newScaleFactor)
        case .ended:
            lastZoomFactor = minMaxZoom(newScaleFactor)
            update(scale: lastZoomFactor)
        default: break
        }
        
    }
    
    
    public func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }
    
    public func startCameraSession(){
        
        objectDetection = CaffeDetection(caffeModels: ModelSettings.caffeModelFile, prototext: ModelSettings.protoText, treshold: ModelSettings.threshold, inputWidth: Int32(ModelSettings.inputWidth), inputHeight: Int32(ModelSettings.inputHeight), modelLabelMap: ModelSettings.caffeLabelMap, imageBlobScalefactor:ModelSettings.imageBlobScalefactor, imageBlobMeanScalar:ModelSettings.imageBlobMeanScalar, imageBlobSwapRB: ModelSettings.imageBlobSwapRB, imageBlobCrop:ModelSettings.imageBlobCrop)
        
        cameraFeedManager.checkCameraConfigurationAndStartSession()
        
    }
    
    public func stopCameraSession(){
        cameraFeedManager.stopSession()
    }
    
    func didOutput(pixelBuffer: CVPixelBuffer) {
        if isCameraSwitched == true {
            let ciimage : CIImage = CIImage(cvPixelBuffer: pixelBuffer)
            var image : UIImage = InternalFunctions().convert(cmage: ciimage)
            
            if usingFrontCamera == true {
                image = image.rotate(radians: .pi / -2)!
                let imageBuffer = InternalFunctions().pixelBufferFromImage(image: image)
                runModel(onPixelBuffer: imageBuffer)
            }else{
                image = image.rotate(radians: .pi / -2)!
                image = image.rotate(radians: .pi / -2)!
                image = image.rotate(radians: .pi / -2)!
                
                let imageBuffer = InternalFunctions().pixelBufferFromImageBack(image: image)
                runModel(onPixelBuffer: imageBuffer)
                
                
            }
            
            
        }else{
            runModel(onPixelBuffer: pixelBuffer)
        }
        
        
    }
    
    var startTime = Date().timeIntervalSince1970 * 1000
    @objc  func runModel(onPixelBuffer pixelBuffer: CVPixelBuffer) {
        
        // Run the live camera pixelBuffer through tensorFlow to get the result
        
        let currentTimeMs = Date().timeIntervalSince1970 * 1000
        
        let startTimeNow = Date().timeIntervalSince1970 * 1000
        
        print("framerate after model: ",(1.0/(startTimeNow-startTime)))
        
        
        guard  (currentTimeMs - previousInferenceTimeMs) >= delayBetweenInferencesMs else {
            return
        }
        
        previousInferenceTimeMs = currentTimeMs
        
        self.detectedObjects = self.objectDetection!.detectObject(UIImage(pixelBuffer:pixelBuffer)!)
        
        
        let width = CVPixelBufferGetWidth(pixelBuffer)
        let height = CVPixelBufferGetHeight(pixelBuffer)
        
        DispatchQueue.main.async {
            
            if self.synchronousVideo == true {
                self.syncView.image = UIImage(pixelBuffer: pixelBuffer)
                self.syncView.isHidden = false
            }else{
                self.syncView.isHidden = true
            }
            
            if ModelSettings.hideOverlay != true{
                
                self.drawAfterPerformingCalculations(onInferences: self.detectedObjects, withImageSize: CGSize(width: CGFloat(width), height: CGFloat(height)),withPixelBuffer : pixelBuffer)
                
                
            }
            
        }
    }
    
    
    
    func drawAfterPerformingCalculations(onInferences inferences: NSMutableArray, withImageSize imageSize:CGSize, withPixelBuffer pixelBuffer: CVPixelBuffer) {
        
        overlayView.objectOverlays = []
        overlayView.setNeedsDisplay()
        
        var objectOverlays: [ObjectOverlay] = []
        var detectionResults : [DetectionResults] = []
        
        for inference in inferences {
            
            let dict : NSDictionary
            dict = inference as! NSDictionary
            
            var strRect : String = ""
            strRect = dict["boxCGRect"] as! String
            let rectfinal:CGRect = NSCoder.cgRect(for: strRect)
            
            var convertedRect = rectfinal.applying(CGAffineTransform(scaleX: overlayView.bounds.size.width/CGFloat(ModelSettings.inputWidth) , y: overlayView.bounds.size.height/CGFloat(ModelSettings.inputHeight)))
            
            var convertedCropRect = rectfinal.applying(CGAffineTransform(scaleX: imageSize.width/CGFloat(ModelSettings.inputWidth) , y: imageSize.height/CGFloat(ModelSettings.inputHeight) ))
            
            if convertedRect.origin.x < 0 {
                convertedRect.origin.x = self.edgeOffset
            }
            
            if convertedRect.origin.y < 0 {
                convertedRect.origin.y = self.edgeOffset
            }
            
            if convertedRect.maxY > overlayView.bounds.maxY {
                convertedRect.size.height = overlayView.bounds.maxY - convertedRect.origin.y - self.edgeOffset
            }
            
            if convertedRect.maxX > overlayView.bounds.maxX {
                convertedRect.size.width = overlayView.bounds.maxX - convertedRect.origin.x - self.edgeOffset
            }
            
            var confidence : String = ""
            confidence = dict["confidence"] as! String
            let confidenceInt = (confidence as NSString).floatValue
            let confidenceValue = Int(confidenceInt * 100.0)
            
            let classID = (dict["classId"] as! NSString).integerValue
            
            let className = dict["className"] as! String
            
            let string = "\(classID)  (\(confidenceValue)%)"
            
            let size = string.size(usingFont: self.displayFont)
            
            let objectOverlay = ObjectOverlay(name: string, borderRect: convertedRect, nameStringSize: size, color: UIDecorators.colorCodeTurkuazBlue, font: self.displayFont)
            
            if ModelSettings.returnCroppedImages != true{
                let detectionResultsDictionary = DetectionResults(className: "\(className)",  classId: "\(classID)", borderRect: convertedRect, confidence: confidenceInt, color:  UIDecorators.colorCodeTurkuazBlue, croppedImage: nil, detectionDate: Date())
                detectionResults.append(detectionResultsDictionary)
            }else{
                let croppedImage  = InternalFunctions().cropImage(image: pixelBuffer, rect: convertedCropRect)
                let detectionResultsDictionary = DetectionResults(className: "\(className)",  classId: "\(classID)", borderRect: convertedRect, confidence: confidenceInt, color:  UIDecorators.colorCodeTurkuazBlue, croppedImage: croppedImage, detectionDate: Date())
                detectionResults.append(detectionResultsDictionary)
            }
            
            objectOverlays.append(objectOverlay)
            
        }
        
        self.draw(objectOverlays: objectOverlays)
        self.delegate?.detectionResuslts(result: detectionResults)
        
    }
    
    func draw(objectOverlays: [ObjectOverlay]) {
        overlayView.hideClassLabels = ModelSettings.hideClassLabels
        overlayView.hideBoxBackground = ModelSettings.hideBoxBackground
        overlayView.HideBox = ModelSettings.HideBox
        overlayView.objectOverlays = objectOverlays
        overlayView.setNeedsDisplay()
        self.detectedObjects.removeAllObjects()
    }
    
}
