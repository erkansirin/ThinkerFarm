//
//  TensorFlowCameraView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 11.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift

public struct HeatmapRawData {
    public var boxCGRect: CGRect
    public var detectionDate: Date
    public var point: CGPoint

}


class HeatMapView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TensorFlowDetectionDelegate,ResourceReportDelegate {
    func updateResourceUsage(memory: String, cpu: String) {
        
        modelList.removeAll()
        modelList.append(memory)
        modelList.append(cpu)
        resourceView.reloadData()
            
    }
    

  
    
    func detectionResuslts(result: [DetectionResults]) {
       
        if startHeatMapping {
        
        if (firstFrame != nil) {
            
            for det in result {
                       
                let convertedRect = det.borderRect
        
       
                       let point = CGPoint(x: (convertedRect.minX + convertedRect.maxX)/2, y: convertedRect.maxY)
                       
                self.detectionResults.append(HeatmapRawData(boxCGRect: det.borderRect, detectionDate: det.detectionDate, point:point))
                   }
                       
                   print("detectionResults : ",detectionResults.count)
                   if detectionResults.count > 0 {
                       print("detectionResults first item: ",detectionResults[detectionResults.count-1])
                       
                       
                   }
            
            heatmapSessionQueue.async {
                self.createHeatmap()
            }
            
        }
            
        }

    }
    
    private let heatmapSessionQueue = DispatchQueue(label: "heatmapSessionQueue")
    
    func firstFrameForHeatMap(image: UIImage){
        print("image")
        firstFrame = image
    }
    
    
    func createHeatmap(){
        
        let result = TouchHeatmapRenderer.renderTouches(image: firstFrame, touches: detectionResults)
        let touchImage = result.0
        let success = result.1
        
        if success {
            // A touch heatmap was rendered, blend it with the screenshot
            let size = self.firstFrame.size
            let rect =  CGRect(origin: CGPoint(x: 0, y :0), size: CGSize(width: size.width, height: size.height))
            
            let scale = firstFrame.scale
            UIGraphicsBeginImageContextWithOptions(size, false, scale);
            self.firstFrame.draw(in: rect)
            touchImage.draw(in: rect, blendMode: CGBlendMode.normal, alpha: 1.0)
            let renderedImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext();
            DispatchQueue.main.sync {
                //touchImage =  touchImage.rotate(radians: .pi / 2)!
                //touchImage = touchImage.withHorizontallyFlippedOrientation()
                print("touchImage width :",touchImage.size.width )
                print("touchImage height :",touchImage.size.height )
                
                finalHeatmap.image = touchImage
            }
            
            //return renderedImage
        } else {
            // This is the case when no touches were tracked, then we don't make
            // a screenshot
            //return nil
        }
        
    }

    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var previewView: TensorFlowCamera!
    @IBOutlet weak var memLabel: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    var resourceReport:ResourceReport = ResourceReport()
    
    @IBOutlet weak var finalHeatmap: UIImageView!
    @IBOutlet weak var infoView: UIView!
    
    @IBOutlet weak var resourceView: UICollectionView!
    var cpuUsage : String = ""
    var memoryUsage : String = ""
    
    var modelList = [""]
    
    var detectionResults : [HeatmapRawData] = []
    var firstFrame : UIImage!
    var startHeatMapping : Bool = true

 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        

    }
    
    override func viewDidAppear(_ animated: Bool) {
         previewView.setup(frame:self.previewView.frame)
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewView.delegate = self
        resourceReport.delegate = self
        
        let layout = resourceView.collectionViewLayout as? UICollectionViewFlowLayout
                             layout?.sectionHeadersPinToVisibleBounds = true
                             
                             //resourceView.backgroundColor = UIColor.clear
               
               layout!.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
                             resourceView.register(UINib(nibName: "resourceViewCell", bundle: nil), forCellWithReuseIdentifier: "resourceViewCell")
          
  

    }
    
    @IBAction func startButton(_ sender: Any) {
        startHeatMapping = true
        infoView.isHidden = true
        
        resourceReport.start()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
                   
                   
                   
                   return CGSize(width:resourceView.frame.width/2-5, height: 30)
                   

               }
               
               func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
                   
                   
                   return CGSize(width:0.0, height:0.0)
                   
                   
               }
               
               
               func numberOfSections(in collectionView: UICollectionView) -> Int {
                   return 1
               }
               
               
               func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
                   return  self.modelList.count
                   
               }
               
               
               
               
               func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
                   
                   
                   let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "resourceViewCell", for: indexPath) as! resourceViewCell
                   //print("elf.modelList[indexPath.row] : ",self.modelList[indexPath.row])
                  
                   cell.resLabel.text = "\(self.modelList[indexPath.row])"
                
                if indexPath.row == 0 {
                    cell.resLabel.backgroundColor = UIDecorators.colorCodeTurkuazBlue
                }
                   
                 
                   
                   return cell
                   
                   
               }
               
               
           

               func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
                   
                   
               
                   
               }
               
         
    
    
    

    @IBAction func backAction(_ sender: Any) {
        resourceReport.stop()
        
        self.previewView.stopCameraSession()
        self.navigationController?.popViewController(animated: true)
        
    }
    @IBAction func syncAction(_ sender: Any) {
        
        if previewView.synchronousVideo == true {
                   previewView.synchronousVideo = false
               }else{
                   previewView.synchronousVideo = true
               }
    }
    
    
  

}
