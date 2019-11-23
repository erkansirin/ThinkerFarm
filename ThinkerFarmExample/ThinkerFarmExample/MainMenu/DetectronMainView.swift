//
//  DetectronMainView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 11.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift

public enum SelectedMenu {
    case liveCam
    case VideoAnalysis
    case ImageAnalysis
    case Heatmap
    case ObjectTracker
    case Settings
    case About
}

public enum PublicEnums {
     public static var selectedMenu: SelectedMenu = .liveCam
}


class DetectronMainView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout {
    
 
    @IBOutlet weak var versionLabel: UILabel!
    @IBOutlet weak var buttonCollection: UICollectionView!
   


//    var buttonList = [["name":"Live Camera","image":"Live Camera"],"Video Analysis",
//                      "Image Analysis",
//                      "Heatmap Analysis",
//                      "Object Tracker",
//                      "Settings",
//                      "About"
    
    
//    ]
    
    var buttonList = [["name":"Live Camera","image":"livecameraicon"],
                      ["name":"Video Analysis","image":"videoAnalysisIcon"],
                      ["name":"Image Analysis","image":"imageanalysisicon"],
                      ["name":"Heatmap Analysis","image":"heatmapicon"],
                      //["name":"Object Tracker","image":"objecttrackericon"],
    ["name":"Settings","image":"settingsicon"],
    ["name":"About","image":"abouticon"]]
    var modelList = [""]
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        if let build = Bundle.main.infoDictionary?["CFBundleVersion"] as? String {
            
            if let version = Bundle.main.infoDictionary?["CFBundleShortVersionString"] as? String {
                versionLabel.text = "ThinkerFarm Demo V\(version).\(build)"
            }
            
        }
        
        let layout = buttonCollection.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        layout!.minimumInteritemSpacing = 10
        layout!.minimumLineSpacing = 10
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        //buttonCollection.backgroundColor = UIColor.clear
        
        buttonCollection.register(UINib(nibName: "ButtonCellCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ButtonCellCollectionViewCell")
        
    }
    
    
  

    
    
   
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        
     
            return CGSize(width:self.buttonCollection.frame.size.width/2-25, height: self.buttonCollection.frame.size.width/2-25)
        
        
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
        
        return CGSize(width:0.0, height:0.0)
        
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return CGFloat(15)
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
       
            return  buttonList.count
    
        
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ButtonCellCollectionViewCell", for: indexPath) as! ButtonCellCollectionViewCell
        let buttonName = buttonList[indexPath.row]["name"]
            cell.buttonLabel.text = buttonName
        cell.iconView.image = UIImage (named: buttonList[indexPath.row]["image"]!)
            

        return cell
        
    
    }
    
    
    
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        

            if indexPath.row == 0 {
                
                PublicEnums.selectedMenu = .liveCam
                
            }
            
            if indexPath.row == 1 {
                
                PublicEnums.selectedMenu = .VideoAnalysis
                
            }
            
            if indexPath.row == 2 {
                
                PublicEnums.selectedMenu = .ImageAnalysis
                
            }
            
            if indexPath.row == 3 {
                
                PublicEnums.selectedMenu = .Heatmap

                
            }
            
          
            
            
            if indexPath.row == 4 {
                
                PublicEnums.selectedMenu = .Settings
                
            }
            
        if indexPath.row == 5 {
            
            PublicEnums.selectedMenu = .About
            
        }
        
        setupAndOpenModelSelectMenu()
        
        
    }
    
    func setupAndOpenModelSelectMenu(){
     
     
        switch PublicEnums.selectedMenu {
        case .liveCam:
            self.navigationController?.pushViewController(SelectModelView(), animated: true)
        case .VideoAnalysis:
            self.navigationController?.pushViewController(SelectModelView(), animated: true)
        case .ImageAnalysis:
            self.navigationController?.pushViewController(SelectModelView(), animated: true)
        case .Heatmap:
            ModelSettings.modelFileInfo  = (name: "person_detection_thinkerfarm", extension: "tflite")
            ModelSettings.labelsFileInfo = (name: "person_detection_thinkerfarm", extension: "txt")
            ModelSettings.detectionType = 1
            ModelSettings.inputWidth = 300
            ModelSettings.inputHeight = 300
            ModelSettings.returnCroppedImages = true
            ModelSettings.hideOverlay = false
            
            self.navigationController?.pushViewController(HeatMapView(), animated: true)
        case .ObjectTracker:
            self.navigationController?.pushViewController(SelectModelView(), animated: true)
        case .Settings:
            self.present(SettingsView(), animated: true, completion: nil)
        case .About:
            self.present(HelpView(), animated: true, completion: nil)
        }
        
        
        
    }
    
    
    @IBAction func helpAction(_ sender: Any) {
        
        self.present(HelpView(), animated: true, completion: nil)
    }
    
    
}
