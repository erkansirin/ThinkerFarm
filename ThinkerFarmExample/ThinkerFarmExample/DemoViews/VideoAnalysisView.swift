//
//  VideoAnalysisView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 15.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift
import AVFoundation
import VideoToolbox

extension UIImage {
    func toCVPixelBuffer() -> CVPixelBuffer? {
        let attrs = [kCVPixelBufferCGImageCompatibilityKey: kCFBooleanTrue, kCVPixelBufferCGBitmapContextCompatibilityKey: kCFBooleanTrue] as CFDictionary
        var pixelBuffer : CVPixelBuffer?
        let status = CVPixelBufferCreate(kCFAllocatorDefault, Int(self.size.width), Int(self.size.height), kCVPixelFormatType_32BGRA, attrs, &pixelBuffer)
        guard status == kCVReturnSuccess else {
            return nil
        }
        
        if let pixelBuffer = pixelBuffer {
            CVPixelBufferLockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            let pixelData = CVPixelBufferGetBaseAddress(pixelBuffer)
            
            let rgbColorSpace = CGColorSpaceCreateDeviceRGB()
            let context = CGContext(data: pixelData, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: 8, bytesPerRow: CVPixelBufferGetBytesPerRow(pixelBuffer), space: rgbColorSpace, bitmapInfo: CGImageAlphaInfo.noneSkipFirst.rawValue)
            
            context?.translateBy(x: 0, y: self.size.height)
            context?.scaleBy(x: 1.0, y: -1.0)
            
            UIGraphicsPushContext(context!)
            self.draw(in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
            UIGraphicsPopContext()
            CVPixelBufferUnlockBaseAddress(pixelBuffer, CVPixelBufferLockFlags(rawValue: 0))
            
            return pixelBuffer
        }
        
        return nil
    }
}

public struct DetResults {
    public let className: String
    public let classId: Int
    public let borderRect: CGRect
    public let confidence: Float
    public let color: UIColor
    public let croppedImage : UIImage?
}


extension UIImage {
    public convenience init?(pixelBuffer: CVPixelBuffer) {
        var cgImage: CGImage?
        VTCreateCGImageFromCVPixelBuffer(pixelBuffer, options: nil, imageOut: &cgImage)
        
        if let cgImage = cgImage {
            self.init(cgImage: cgImage)
        } else {
            return nil
        }
    }
}


extension VideoAnalysisView: VideoPickerDelegate {
    
    func didSelect(url: URL?) {
        guard let url = url else {
            return
        }

        self.videoAnalysis!.processVideo(url:url)
   
    }
    
}


class VideoAnalysisView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,VideoAnalysisDelegate {
    
    func detectionResuslts(result: [Dictionary<String, Any>], frame: UIImage,remainingJobInQueue:Int,remainingJobCountInQueue:Int) {
        
        if self.detectionResultsReverse.count > 100 {
            let deleteCount = self.detectionResultsReverse.count - 100
            self.detectionResultsReverse.removeFirst(deleteCount)
        }
        
        for dict in result  {
            
            let  rectfinal = dict["borderRect"] as! CGRect
            let confidenceInt = dict["confidence"] as! Float
            let classID = dict["classId"] as! Int
            let className = dict["className"] as! String
            let croppedImage = dict["croppedImage"] as! UIImage
            
            
            let detectionResultsDictionary = DetResults(className: "\(className)",  classId: classID, borderRect: rectfinal, confidence: confidenceInt, color:  UIColor.green, croppedImage: croppedImage)
            detectionResultsReverse.append(detectionResultsDictionary)
            
        }
        self.detectionResultsReverse = detectionResultsReverse.reversed()
        
        
        DispatchQueue.main.async {
            self.currentMemory = Tools().reportMemory()
            if remainingJobInQueue <= 1{
                let jobString = "\(remainingJobCountInQueue)/\(remainingJobInQueue)"
                print("jobString : ",jobString)
                if jobString.contains(find: "1/-1") {
                    self.jobsLabel.text = "Done"
                }
                
                self.memLabel.text = "MEM:\(0)MB"
                self.cpuLabel.text = "CPU:\(0)%"
            }else{
                self.jobsLabel.text = "JOBS:\(remainingJobCountInQueue)/\(remainingJobInQueue)"
                if self.currentMemory > 500 {
                    self.memLabel.backgroundColor = .red
                }
                self.memLabel.text = "MEM:\(self.currentMemory)MB"
                self.cpuLabel.text = "CPU:\(Int(Tools().cpuUsage()))%"
            }
            
            //self.drawBoxes(image : frame, detectionResults: detectionResults)
            self.videoFrame.image = frame
            self.resultCollection.reloadData()
        }
    }
    
    
    
    
    func drawBoxes(image: UIImage?, detectionResults:[DetResults]) {
        
        
        if ModelSettings.detectionType == 1 {
            
            
            for vx in self.boxesView.subviews {
                vx.removeFromSuperview()
            }
            
            for i in 0..<detectionResults.count {
                
                
                
                let confidenceInt = self.detectionResultsReverse[i].confidence
                let classID = (self.detectionResultsReverse[i].classId as! NSString).integerValue
                
                
                
                
                
                if confidenceInt > ModelSettings.threshold {
                    //print("dict : ",dict)
                    //print("class : \(self.classes[classID])")
                    
                    let rectfinal = detectionResults[i].borderRect

                    var drectDraw = rectfinal.applying(CGAffineTransform(scaleX: self.boxesView.frame.size.width / (image?.size.width)!, y: self.boxesView.frame.size.height / (image?.size.height)!))

                    let k = Draw(frame: drectDraw )
                    k.backgroundColor = UIColor.clear
                    var label = UILabel(frame: CGRect(x: k.frame.origin.x, y: k.frame.origin.y, width: 200, height: k.frame.size.height))
                    label.textColor = UIColor.green
                    label.textAlignment = NSTextAlignment.center
                    //label.text = self.detectionResults[i].className
                    //self.view.addSubview(self.boxesView)
                    
                    self.boxesView.addSubview(k)
                    self.boxesView.addSubview(label)
                }
                
                
            }
            
            
        }else{
            
            self.videoFrame.image = image
            
            for vx in self.boxesView.subviews {
                vx.removeFromSuperview()
            }
            
            for i in 0..<detectionResults.count {
                
                
                
                let confidenceInt = detectionResults[i].confidence
                let classID = (detectionResults[i].classId as! NSString).integerValue
                
                
                
                
                
                if confidenceInt > ModelSettings.threshold {
                    //print("dict : ",dict)
                    //print("class : \(self.classes[classID])")
                    
                    let rectfinal = detectionResults[i].borderRect
                    
                    var drectDraw = rectfinal.applying(CGAffineTransform(scaleX: self.boxesView.frame.size.width/CGFloat(ModelSettings.inputWidth) , y: self.boxesView.frame.size.height/CGFloat(ModelSettings.inputHeight)))
                    
                    
                    
                    
                    let k = Draw(frame: drectDraw )
                    k.backgroundColor = UIColor.clear
                    var label = UILabel(frame: CGRect(x: k.frame.origin.x, y: k.frame.origin.y, width: 200, height: k.frame.size.height))
                    label.textColor = UIColor.green
                    label.textAlignment = NSTextAlignment.center
                    //label.text = self.detectionResults[i].className
                    //self.view.addSubview(self.boxesView)
                    
                    self.boxesView.addSubview(k)
                    self.boxesView.addSubview(label)
                }
                
                
            }
            
            
        }
        
    }
    
    
    @IBOutlet weak var boxesViewHeight: NSLayoutConstraint!
    @IBOutlet weak var boxesView: UIView!
    @IBOutlet weak var videoView: UIView!
    @IBOutlet weak var videoViewHeight: NSLayoutConstraint!
    @IBOutlet weak var videoFrame: UIImageView!
    @IBOutlet weak var resultCollection: UICollectionView!
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    
    @IBOutlet weak var jobsLabel: UILabel!
    @IBOutlet weak var memLabel: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    
    var videoAnalysis : VideoAnalysis?
    //var detectionResults : [DetResults] = []
    var detectionResultsReverse : [DetResults] = []
    var processBusy : Bool = false
    var currentMemory  = 0
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        //videoViewHeight.constant = videoView.frame.width
        //boxesViewHeight.constant = videoView.frame.width
        
    }
    
    
    var videoPicker: VideoPicker!
    
    
    func cropImage(image: CVPixelBuffer, rect: CGRect) -> UIImage {
        let newimage = UIImage(pixelBuffer: image)
        let cgImage = newimage?.cgImage
        guard let croppedCGImage = cgImage!.cropping(to: rect) else {return UIImage()}
        return UIImage(cgImage: croppedCGImage)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        
        //        self.videoView.contentMode = .scaleAspectFill
        //        self.videoView.player?.isMuted = true
        //        self.videoView.repeat = .loop
        
        let layout = resultCollection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        resultCollection.backgroundColor = UIColor.clear
        
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        
        resultCollection.register(UINib(nibName: "DetectionResultsCell", bundle: nil), forCellWithReuseIdentifier: "DetectionResultsCell")
        resultCollection.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        
        
        setupDetector(detectorType: ModelSettings.detectionType)
        
        
        
        
        
        
    }
    
    
    
    
    
    
    
    //    func screenshot(handler:@escaping ((UIImage)->Void)) {
    //        guard let player = self.videoView.player ,
    //            let asset = player.currentItem?.asset else {
    //                return
    //        }
    //
    //        let imageGenerator = AVAssetImageGenerator(asset: asset)
    //        imageGenerator.appliesPreferredTrackTransform = true
    //        let times = [NSValue(time:player.currentTime())]
    //
    //        imageGenerator.generateCGImagesAsynchronously(forTimes: times) { _, image, _, _, _ in
    //            if image != nil {
    //                handler(UIImage(cgImage: image!))
    //            }
    //        }
    //    }
    //
    func setupDetector(detectorType:Int){
        
        
        
        if detectorType == 1 {
            videoAnalysis  = VideoAnalysis(networkType: "TensorFlow")
            videoAnalysis!.delegate = self
            
        }else{
            
            
            
            videoAnalysis  = VideoAnalysis(networkType: "Caffe")
            videoAnalysis!.delegate = self
        }
        
        
        
    }
    
    @IBAction func backAction(_ sender: Any) {
        
        //self.videoAnalysis!.stopVideoAnalysisSession()
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        
        self.videoPicker = VideoPicker(presentationController: self, delegate: self)
        self.videoPicker.present(from: sender)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
        
        
        return CGSize(width:resultCollection.frame.width, height: 100)
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        
        return CGSize(width:0.0, height:0.0)
        
        
    }
    
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return  self.detectionResultsReverse.count
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetectionResultsCell", for: indexPath) as! DetectionResultsCell
        
        cell.detectionImage.image = self.detectionResultsReverse[indexPath.row].croppedImage
        cell.classNameLabel.text = "\(self.detectionResultsReverse[indexPath.row].className)"
        
        let confidenceValue = Int(self.detectionResultsReverse[indexPath.row].confidence * 100.0)
        cell.thresholdLabel.text = "\(confidenceValue)%"
        
        
        
        cell.transform = CGAffineTransform(scaleX: 1, y: -1)
        
        
        return cell
        
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
        
        
        
    }
    
    
    @IBAction func helpAction(_ sender: Any) {
        
        self.present(HelpView(), animated: true, completion: nil)
        
    }
    
    
}


