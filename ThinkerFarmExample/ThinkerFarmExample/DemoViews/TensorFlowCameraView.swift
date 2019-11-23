//
//  TensorFlowCameraView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 11.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift



class TensorFlowCameraView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,TensorFlowDetectionDelegate,ResourceReportDelegate {
    func detectionResuslts(result: [DetectionResults]) {
        
    }
    
    func firstFrameForHeatMap(image: UIImage) {
        
    }
    
    func updateResourceUsage(memory: String, cpu: String) {
        
        modelList.removeAll()
        modelList.append(memory)
        modelList.append(cpu)
        resourceView.reloadData()
            
    }
        


    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var previewView: TensorFlowCamera!
    @IBOutlet weak var memLabel: UILabel!
    @IBOutlet weak var cpuLabel: UILabel!
    var resourceReport:ResourceReport = ResourceReport()
    
    
    @IBOutlet weak var resourceView: UICollectionView!
    var cpuUsage : String = ""
    var memoryUsage : String = ""
    
    var modelList = [""]

 
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        previewView.setup(frame:self.previewView.frame)

    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
 
    override func viewDidLoad() {
        super.viewDidLoad()
        
        previewView.delegate = self
        resourceReport.delegate = self
        
        resourceReport.start()
        
        
        let layout = resourceView.collectionViewLayout as? UICollectionViewFlowLayout
                             layout?.sectionHeadersPinToVisibleBounds = true
                             
                             //resourceView.backgroundColor = UIColor.clear
               
               layout!.sectionInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)

        
                             resourceView.register(UINib(nibName: "resourceViewCell", bundle: nil), forCellWithReuseIdentifier: "resourceViewCell")
          
   

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
