//
//  ModelDownloader.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 19.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import Foundation


public protocol ModelDownloaderDelegate : class{
    func downloadProgess(currentProgress: Float)
    func downloadCompleted()
    
}


open class ModelDownloader: NSObject,URLSessionTaskDelegate, URLSessionDownloadDelegate {
    
    private lazy var urlSession: URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "\(Bundle.main.bundleIdentifier ?? "").backgrouns")
        config.isDiscretionary = true
        config.sessionSendsLaunchEvents = true
        return URLSession(configuration: config, delegate: self, delegateQueue: nil)
    }()
    
    
    var fileNameToSave = ""
    public weak var delegate: ModelDownloaderDelegate?
    
    
    func downloadFileWithUrl(url:String,fileToName :String){
        fileNameToSave = fileToName
       let task = urlSession.downloadTask(with: URL(string: url)!)

        task.resume()
        
    }
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didWriteData bytesWritten: Int64, totalBytesWritten: Int64, totalBytesExpectedToWrite: Int64) {
        
        print(totalBytesExpectedToWrite)
        print(totalBytesWritten)
        let progress = Float(totalBytesWritten) / Float(totalBytesExpectedToWrite)
        delegate?.downloadProgess(currentProgress: progress)
        debugPrint("Progress \("") \(progress)")
    }
    
    
    public func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask,
                      didFinishDownloadingTo location: URL) {
          guard let httpResponse = downloadTask.response as? HTTPURLResponse,
              (200...299).contains(httpResponse.statusCode) else {
                  print ("server error")
                  return
          }
          do {
              let documentsURL = try
                  FileManager.default.url(for: .documentDirectory,
                                          in: .userDomainMask,
                                          appropriateFor: nil,
                                          create: false)
              let savedURL = documentsURL.appendingPathComponent(
                  fileNameToSave)
              print("location :",location)
              print("savedURL :",savedURL)
            
        try FileManager.default.copyItem(at: location, to: savedURL)
            delegate!.downloadCompleted()
          } catch {
              print ("file error: \(error)")
            delegate!.downloadCompleted()
          }
      }
   
    
    func clearTempFolder() {
        let fileManager = FileManager.default
        let tempFolderPath = NSTemporaryDirectory()
        do {
            let filePaths = try fileManager.contentsOfDirectory(atPath: tempFolderPath)
            for filePath in filePaths {
                try fileManager.removeItem(atPath: tempFolderPath + filePath)
            }
        } catch {
            print("Could not clear temp folder: \(error)")
        }
    }
    
    func deleteFileAtPath(fileNameToDelete:String){
        
         
               var filePath = ""
               
               // Fine documents directory on device
                let dirs : [String] = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.allDomainsMask, true)
               
               if dirs.count > 0 {
                   let dir = dirs[0] //documents directory
                   filePath = dir.appendingFormat("/" + fileNameToDelete)
                   print("Local path = \(filePath)")
        
               } else {
                   print("Could not find local directory to store file")
                   return
               }
               
               
               do {
                    let fileManager = FileManager.default
                   
                   // Check if file exists
                   if fileManager.fileExists(atPath: filePath) {
                       // Delete file
                       try fileManager.removeItem(atPath: filePath)
                   } else {
                       print("File does not exist")
                   }
        
               }
               catch let error as NSError {
                   print("An error took place: \(error)")
               }
    }

}
