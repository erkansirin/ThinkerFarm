//
//  SelectModelView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 16.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift


public struct ModelMenu:Codable {
    let modelType: String
    let whoTrained: String
    let modelName: String
    let modelFileName : String
    let modelProtoTxtName : String
    let modelLabelsFileName : String
    let inputWidth :String
    let inputHeight :String
    let imageBlobScalefactor :String
    let imageBlobMeanScalar1 :String
    let imageBlobMeanScalar2 :String
    let imageBlobMeanScalar3 :String
    let imageBlobSwapRB :Bool
    let imageBlobCrop :Bool
    
    
}




class SelectModelView: UIViewController,UICollectionViewDataSource,UICollectionViewDelegate,UICollectionViewDelegateFlowLayout,ModelDownloaderDelegate {
    func downloadProgess(currentProgress: Float) {
        downloadProgess = currentProgress
        DispatchQueue.main.async {
            self.modelList.reloadData()
        }
    }
    
    func downloadCompleted(){
        DispatchQueue.main.async {
            if self.downloadmodelType == "Caffe"{
                self.downloadFileCount -= 1
                self.downloadManager(fileCount: self.downloadFileCount, modelType: self.downloadmodelType , modelFileName : self.downloadFileName)
            }else{
                self.downloadFileCount -= 1
                self.downloadManager(fileCount: self.downloadFileCount, modelType: self.downloadmodelType , modelFileName : self.downloadFileName)
            }
            
        }
        
    }
    
    
    
    
    
    var modelMenuList: [ModelMenu] = []
    let modelDownloader:ModelDownloader = ModelDownloader()
    var downloadProgess : Float = 0.01
    var downloadingCell = -1
    var downloadBusy : Bool = false
    var downloadFileCount = 0
    var downloadmodelType = ""
    var downloadFileName = ""
    
    @IBOutlet weak var modelList: UICollectionView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let layout = modelList.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.sectionHeadersPinToVisibleBounds = true
        
        //modelList.backgroundColor = UIColor.clear
        layout!.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        
        modelList.register(UINib(nibName: "ModelSelectCell", bundle: nil), forCellWithReuseIdentifier: "ModelSelectCell")
        
        modelDownloader.delegate = self
        generateModelList()
        
    }
    
    func generateModelList(){
        
        let settingsURL: URL = Bundle.main.url(forResource: "ModelMenuList", withExtension: "plist")!
        
        
        do {
            let data = try Data(contentsOf: settingsURL)
            let decoder = PropertyListDecoder()
            modelMenuList = try decoder.decode([ModelMenu].self, from: data)
        } catch {
            // Handle error
            print(error)
        }
        
        modelList.reloadData()
        
        
    }
    
    func checkFilesExisted(modelType : String, fileName:String) -> Bool{
        
        var fileExistence : Bool = false
        var modelCheckCount = 0
        if modelType == "TensorFlow"{
            
            if checkIfFileExits(filename: "\(fileName).tflite") {
                modelCheckCount += 1
            }
            
            if checkIfFileExits(filename: "\(fileName).txt") {
                modelCheckCount += 1
            }
            
            if checkIfFileExitsInBundle(filename: "\(fileName)", fileType: "tflite") {
                modelCheckCount += 1
            }
            
            if checkIfFileExitsInBundle(filename: "\(fileName)", fileType: "txt") {
                modelCheckCount += 1
            }
            
            if modelCheckCount == 2{
                fileExistence = true
            }
            
        }else{
            
            if checkIfFileExits(filename: "\(fileName).caffemodel") {
                modelCheckCount += 1
            }
            if checkIfFileExits(filename: "\(fileName).txt") {
                modelCheckCount += 1
            }
            if checkIfFileExits(filename: "\(fileName).prototxt") {
                modelCheckCount += 1
            }
            if checkIfFileExitsInBundle(filename: "\(fileName)", fileType: "caffemodel") {
                modelCheckCount += 1
            }
            if checkIfFileExitsInBundle(filename: "\(fileName)", fileType: "txt") {
                modelCheckCount += 1
            }
            if checkIfFileExitsInBundle(filename: "\(fileName)", fileType: "prototxt") {
                modelCheckCount += 1
            }
            
            if modelCheckCount == 3{
                fileExistence = true
            }
            
            
            
        }
        
    
    
    
    
    
    return fileExistence
}


func checkIfFileExits(filename : String) -> Bool {
    let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as String
    let url = NSURL(fileURLWithPath: path)
    if let pathComponent = url.appendingPathComponent(filename) {
        let filePath = pathComponent.path
        let fileManager = FileManager.default
        if fileManager.fileExists(atPath: filePath) {
            print("FILE AVAILABLE")
            return true
        } else {
            print("FILE NOT AVAILABLE")
            return false
        }
    } else {
        print("FILE PATH NOT AVAILABLE")
        return false
    }
}

func checkIfFileExitsInBundle(filename : String, fileType : String) -> Bool {
    
    guard let path = Bundle.main.path(forResource: filename, ofType: "txt") else {
        
        return false
    }
    
    
    if FileManager.default.fileExists(atPath: path) {
        NSLog("The file exists!")
        return true
    } else {
        NSLog("Better luck next time...")
        return false
    }
    
    
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
    
    return CGSize(width:self.modelList.frame.size.width, height: 70)
    
}

func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, referenceSizeForHeaderInSection section: Int) -> CGSize {
    
    return CGSize(width:0.0, height:0.0)
    
}

func numberOfSections(in collectionView: UICollectionView) -> Int {
    return 1
}

func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
    
    return  modelMenuList.count
    
}

func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
    
    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ModelSelectCell", for: indexPath) as! ModelSelectCell
    
    var buttonName :String = "\(modelMenuList[indexPath.row].modelName)"
    
    if  downloadingCell == indexPath.row {
        buttonName = "Downloading:\(Int(downloadProgess*100))%"
        cell.progressBar.progress = downloadProgess
        
    }else{
        cell.progressBar.progress = 0
    }
    cell.modelLabel.text = "\(buttonName)"
    
    cell.modelLogo.image = UIImage (named: modelMenuList[indexPath.row].whoTrained)
    
    cell.downloadStatus.image = UIImage (named: "downloadicon")
    
    if checkFilesExisted(modelType: modelMenuList[indexPath.row].modelType, fileName: modelMenuList[indexPath.row].modelFileName) {
        cell.downloadStatus.image = UIImage (named: "readyicon")
    }
    
    return cell
    
}

func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
    
    setupModelSettings(modelMenu: modelMenuList[indexPath.row], indexPathRow:indexPath.row)
    
}





@IBAction func backAction(_ sender: Any) {
    self.navigationController?.popViewController(animated: true)
}

func setupModelSettings(modelMenu:ModelMenu, indexPathRow : Int){
    
    
    
    if modelMenu.modelType == "TensorFlow" {
        
        if checkFilesExisted(modelType: modelMenu.modelType, fileName: modelMenu.modelFileName) {
            ModelSettings.modelFileInfo  = (name: modelMenu.modelFileName, extension: "tflite")
            ModelSettings.labelsFileInfo = (name: modelMenu.modelFileName, extension: "txt")
            ModelSettings.detectionType = 1
            ModelSettings.inputWidth = 300
            ModelSettings.inputHeight = 300
            ModelSettings.returnCroppedImages = true
            ModelSettings.hideOverlay = false
           
            
            openDetectionView()
        }else{
            
            if downloadBusy {
                openAlert(title: "Download Info", message: "A download in progress please wait for finish before start new one.")
            }else{
                
                downloadManager(fileCount: 2, modelType: modelMenu.modelType , modelFileName : modelMenu.modelFileName)
                downloadingCell = indexPathRow
                self.modelList.reloadData()
            }
            
        }
        
        
        
    }else{
        
            
            if checkFilesExisted(modelType: modelMenu.modelType, fileName: modelMenu.modelFileName) {
                
                ModelSettings.caffeModelFile  = modelMenu.modelFileName
                ModelSettings.protoText = modelMenu.modelFileName
                ModelSettings.caffeLabelMap = modelMenu.modelFileName
                ModelSettings.imageBlobScalefactor = Float(modelMenu.imageBlobScalefactor)!
                ModelSettings.imageBlobMeanScalar = [modelMenu.imageBlobMeanScalar1, modelMenu.imageBlobMeanScalar2, modelMenu.imageBlobMeanScalar3]
                ModelSettings.imageBlobSwapRB = modelMenu.imageBlobSwapRB
                ModelSettings.imageBlobCrop = modelMenu.imageBlobCrop
                ModelSettings.returnCroppedImages = true
                ModelSettings.inputWidth = Int(modelMenu.inputWidth)!
                ModelSettings.inputHeight = Int(modelMenu.inputHeight)!
                ModelSettings.detectionType = 2
                ModelSettings.hideOverlay = false
                
               openDetectionView()
            }else{
                if downloadBusy {
                    openAlert(title: "Download Info", message: "A download in progress please wait for finish before start new one.")
                }else{
                    downloadManager(fileCount: 3, modelType: modelMenu.modelType , modelFileName : modelMenu.modelFileName)
                    downloadingCell = indexPathRow
                    self.modelList.reloadData()
                }
            }
 
        
    }
    
    
 
}
    
    func downloadManager(fileCount:Int, modelType:String, modelFileName:String){
        downloadBusy = true
        downloadmodelType = modelType
        downloadFileName = modelFileName
        downloadFileCount = fileCount
        
        if downloadmodelType == "Caffe"{
            if downloadFileCount == 3 {
                
                modelDownloader.deleteFileAtPath(fileNameToDelete: "\(downloadFileName).caffemodel")
                
                modelDownloader.downloadFileWithUrl(url: "https://github.com/erkansirin/ModelFarm/raw/master/ThinkerFarmCompatibleModels/\(downloadFileName).caffemodel", fileToName: "\(downloadFileName).caffemodel")
                
            }else if downloadFileCount == 2 {
                
                modelDownloader.deleteFileAtPath(fileNameToDelete: "\(downloadFileName).prototxt")
                
                modelDownloader.downloadFileWithUrl(url: "https://github.com/erkansirin/ModelFarm/raw/master/ThinkerFarmCompatibleModels/\(downloadFileName).prototxt", fileToName: "\(downloadFileName).prototxt")
                
            }else if downloadFileCount == 1 {
                modelDownloader.deleteFileAtPath(fileNameToDelete: "\(downloadFileName).txt")
                
                modelDownloader.downloadFileWithUrl(url: "https://github.com/erkansirin/ModelFarm/raw/master/ThinkerFarmCompatibleModels/\(downloadFileName).txt", fileToName: "\(downloadFileName).txt")
            }else{
                self.downloadingCell = -1
                self.downloadBusy = false
                downloadFileCount = 0
                downloadmodelType = ""
                downloadFileName = ""
                self.modelList.reloadData()
            }
            
            
        }else{
            
            if downloadFileCount == 2 {
                
                modelDownloader.deleteFileAtPath(fileNameToDelete: "\(downloadFileName).tflite")
                
                modelDownloader.downloadFileWithUrl(url: "https://github.com/erkansirin/ModelFarm/raw/master/ThinkerFarmModel/\(downloadFileName).tflite", fileToName: "\(downloadFileName).tflite")
                
            }else if downloadFileCount == 1 {
                
                modelDownloader.deleteFileAtPath(fileNameToDelete: "\(downloadFileName).txt")
                
                modelDownloader.downloadFileWithUrl(url: "https://github.com/erkansirin/ModelFarm/raw/master/ThinkerFarmModel/\(downloadFileName).txt", fileToName: "\(downloadFileName).txt")
                
            }else{
                self.downloadingCell = -1
                self.downloadBusy = false
                downloadFileCount = 0
                downloadmodelType = ""
                downloadFileName = ""
                self.modelList.reloadData()
            }
            
        }
        
   
        
        
        
        
        
        
    }


func openAlert(title:String, message:String){
    let alert = UIAlertController(title: title, message: message, preferredStyle: .alert)
    alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { action in
        switch action.style{
        case .default:
            print("default")
            
        case .cancel:
            print("cancel")
            
        case .destructive:
            print("destructive")
            
            
        }}))
    self.present(alert, animated: true, completion: nil)
}


func openDetectionView(){
    
    switch PublicEnums.selectedMenu {
    case .liveCam:
        if ModelSettings.detectionType == 1 {
            self.navigationController?.pushViewController(TensorFlowCameraView(), animated: true)
        }else{
            self.navigationController?.pushViewController(CaffeCameraView(), animated: true)
        }
        
        
    case .ImageAnalysis:
        self.navigationController?.pushViewController(TensorFlowDetectView(), animated: true)
    case .VideoAnalysis:
        self.navigationController?.pushViewController(VideoAnalysisView(), animated: true)
    case .Heatmap:
        print("")
    case .ObjectTracker:
        print("")
    case .Settings:
        print("")
    case .About:
        print("")
    }
    
    
}
    @IBAction func helpAction(_ sender: Any) {
        self.present(HelpView(), animated: true, completion: nil)
    }
    
}
