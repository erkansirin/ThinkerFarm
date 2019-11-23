//
//  TensorFlowDetectView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 14.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift

extension TensorFlowDetectView: ImagePickerDelegate {
    
    func didSelect(image: UIImage?) {
        if (image != nil){
        runDetection(image : image!)
        }
    }
}

class TensorFlowDetectView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,CaffeDetectorDelegate,TensorFlowDetectionDelegate {
    func firstFrameForHeatMap(image: UIImage) {
        
    }
    
    func detectionResuslts(result: [DetectionResults]) {
        detectionResults = result
        
        if ModelSettings.detectionType == 1 {
                
                   
                   for vx in self.boxesView.subviews {
                       vx.removeFromSuperview()
                   }
                   
                   for i in 0..<self.detectionResults.count {
                       
                       let confidenceInt = self.detectionResults[i].confidence
                  
                       if confidenceInt > ModelSettings.threshold {
                           let rectfinal = self.detectionResults[i].borderRect
                           
                        let drectDraw = rectfinal.applying(CGAffineTransform(scaleX: self.boxesView.frame.size.width / (self.detectionResultView.image!.size.width), y: self.boxesView.frame.size.height / (self.detectionResultView.image!.size.height)))
                           
                           let k = Draw(frame: drectDraw )
                           k.backgroundColor = UIColor.clear
                           let label = UILabel(frame: CGRect(x: k.frame.origin.x, y: k.frame.origin.y, width: 200, height: k.frame.size.height))
                           label.textColor = UIColor.green
                           label.textAlignment = NSTextAlignment.center
                           
                           self.boxesView.addSubview(k)
                           self.boxesView.addSubview(label)
                       }
                       
                       
                   }
                   
                   
               }else{
               
                   
                   for vx in self.boxesView.subviews {
                       vx.removeFromSuperview()
                   }
                   
                   for i in 0..<self.detectionResults.count {

                       let confidenceInt = self.detectionResults[i].confidence
                 
                       if confidenceInt > ModelSettings.threshold {
                           
                           let rectfinal = self.detectionResults[i].borderRect
                           
                           let drectDraw = rectfinal.applying(CGAffineTransform(scaleX: self.boxesView.frame.size.width/CGFloat(ModelSettings.inputWidth) , y: self.boxesView.frame.size.height/CGFloat(ModelSettings.inputHeight)))
                           
                           let k = Draw(frame: drectDraw )
                           k.backgroundColor = UIColor.clear
                           let label = UILabel(frame: CGRect(x: k.frame.origin.x, y: k.frame.origin.y, width: 200, height: k.frame.size.height))
                           label.textColor = UIColor.green
                           label.textAlignment = NSTextAlignment.center
                           
                           self.boxesView.addSubview(k)
                           self.boxesView.addSubview(label)
                       }
                   }
               }
        
        self.resultCollection.reloadData()
    }
    
    @IBOutlet weak var detectionResultView: UIImageView!
    @IBOutlet weak var boxesView: UIView!
    @IBOutlet weak var boxViewHeight: NSLayoutConstraint!
    @IBOutlet weak var rightCornerConst: NSLayoutConstraint!
    @IBOutlet weak var imageHeightConst: NSLayoutConstraint!
    var detectionResults : [DetectionResults] = []
    var imagePicker: ImagePicker!
    @IBOutlet weak var resultCollection: UICollectionView!
    var detectitor : TensorFlowDetection?
    var caffeDetection : CaffeDetector?
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        imageHeightConst.constant = detectionResultView.frame.width
        boxViewHeight.constant = detectionResultView.frame.width
        
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        self.imagePicker = ImagePicker(presentationController: self, delegate: self)
        
        let layout = resultCollection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 15, bottom: 10, right: 15)
        
        resultCollection.backgroundColor = UIColor.clear
        
        resultCollection.register(UINib(nibName: "DetectionResultsCell", bundle: nil), forCellWithReuseIdentifier: "DetectionResultsCell")
        
        setupDetector(detectorType: ModelSettings.detectionType)
        
    }
    
    func setupDetector(detectorType:Int){
        
        ModelSettings.returnCroppedImages = true
        
        if detectorType == 1 {
            
            detectitor = TensorFlowDetection()
            detectitor!.delegate = self
        }else{
            
            caffeDetection = CaffeDetector()
            caffeDetection!.delegate = self
        }
    }
    
    func runDetection(image : UIImage){
        self.detectionResultView.image = image
        
        if ModelSettings.detectionType == 1 {
                          self.detectitor!.detectionWithResults(withUIImage: image)
  
                      }else{
                          caffeDetection!.detectionWithResults(withUIImage: image)
                          
                      }
               
    }
    
    @IBAction func helpAction(_ sender: Any) {
        self.present(HelpView(), animated: true, completion: nil)
    }
    
    @IBAction func backAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func selectPhotoAction(_ sender: UIButton) {
        
        self.imagePicker.present(from: sender)
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
        return  detectionResults.count
        
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DetectionResultsCell", for: indexPath) as! DetectionResultsCell
        
        cell.detectionImage.image = detectionResults[indexPath.row].croppedImage
        cell.classNameLabel.text = "\(detectionResults[indexPath.row].className)"
        
        let confidenceValue = Int(detectionResults[indexPath.row].confidence * 100.0)
        cell.thresholdLabel.text = "\(confidenceValue)%"
        
        return cell
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        
    }
    
}

class Draw: UIView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
        let x = rect.origin.x
        let y = rect.origin.y
        let color:UIColor = UIColor.green
        
        let drect = CGRect(x: x,y: y,width: (w * 1.0),height: (h * 1.0))
        //var drect = CGRect(x: (w),y: (h),width: (w),height: (h))
        let bpath:UIBezierPath = UIBezierPath(rect: drect)
        bpath.lineWidth = 4
        color.set()
        bpath.stroke()
        
    }
    
}
