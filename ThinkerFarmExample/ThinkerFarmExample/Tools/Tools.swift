//
//  InspectableTools.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 11.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import Foundation
import UIKit




extension UIImage {
    func rotate(radians: Float) -> UIImage? {
        var newSize = CGRect(origin: CGPoint.zero, size: self.size).applying(CGAffineTransform(rotationAngle: CGFloat(radians))).size
        // Trim off the extremely small float value to prevent core graphics from rounding it up
        newSize.width = floor(newSize.width)
        newSize.height = floor(newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, self.scale)
        let context = UIGraphicsGetCurrentContext()!
        
        // Move origin to middle
        context.translateBy(x: newSize.width/2, y: newSize.height/2)
        // Rotate around middle
        context.rotate(by: CGFloat(radians))
        // Draw the image at its center
        self.draw(in: CGRect(x: -self.size.width/2, y: -self.size.height/2, width: self.size.width, height: self.size.height))
        
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage
    }
    
    
   
}

   
 
public struct Tools {
    
    
        func cpuUsage() -> Double {
          var kr: kern_return_t
          var task_info_count: mach_msg_type_number_t

          task_info_count = mach_msg_type_number_t(TASK_INFO_MAX)
          var tinfo = [integer_t](repeating: 0, count: Int(task_info_count))

          kr = task_info(mach_task_self_, task_flavor_t(TASK_BASIC_INFO), &tinfo, &task_info_count)
          if kr != KERN_SUCCESS {
              return -1
          }

          var thread_list: thread_act_array_t? = UnsafeMutablePointer(mutating: [thread_act_t]())
          var thread_count: mach_msg_type_number_t = 0
          defer {
              if let thread_list = thread_list {
                  vm_deallocate(mach_task_self_, vm_address_t(UnsafePointer(thread_list).pointee), vm_size_t(thread_count))
              }
          }

          kr = task_threads(mach_task_self_, &thread_list, &thread_count)

          if kr != KERN_SUCCESS {
              return -1
          }

          var tot_cpu: Double = 0

          if let thread_list = thread_list {

              for j in 0 ..< Int(thread_count) {
                  var thread_info_count = mach_msg_type_number_t(THREAD_INFO_MAX)
                  var thinfo = [integer_t](repeating: 0, count: Int(thread_info_count))
                  kr = thread_info(thread_list[j], thread_flavor_t(THREAD_BASIC_INFO),
                                   &thinfo, &thread_info_count)
                  if kr != KERN_SUCCESS {
                      return -1
                  }

                  let threadBasicInfo = convertThreadInfoToThreadBasicInfo(thinfo)

                  if threadBasicInfo.flags != TH_FLAGS_IDLE {
                      tot_cpu += (Double(threadBasicInfo.cpu_usage) / Double(TH_USAGE_SCALE)) * 100.0
                  }
              } // for each thread
          }

          return tot_cpu
      }

       func convertThreadInfoToThreadBasicInfo(_ threadInfo: [integer_t]) -> thread_basic_info {
          var result = thread_basic_info()

          result.user_time = time_value_t(seconds: threadInfo[0], microseconds: threadInfo[1])
          result.system_time = time_value_t(seconds: threadInfo[2], microseconds: threadInfo[3])
          result.cpu_usage = threadInfo[4]
          result.policy = threadInfo[5]
          result.run_state = threadInfo[6]
          result.flags = threadInfo[7]
          result.suspend_count = threadInfo[8]
          result.sleep_time = threadInfo[9]

          return result
      }
      
    func reportMemory() -> Int {
          
          var taskInfo = mach_task_basic_info()
          var count = mach_msg_type_number_t(MemoryLayout<mach_task_basic_info>.size)/4
          let kerr: kern_return_t = withUnsafeMutablePointer(to: &taskInfo) {
              $0.withMemoryRebound(to: integer_t.self, capacity: 1) {
                  task_info(mach_task_self_, task_flavor_t(MACH_TASK_BASIC_INFO), $0, &count)
              }
          }
          if kerr == KERN_SUCCESS {
              let usedMegabytes = taskInfo.resident_size/(1024*1024)
              //print("used megabytes: \(Int(usedMegabytes))")
              return Int(usedMegabytes)
              
          } else {
              print("Error with task_info(): " +
                  (String(cString: mach_error_string(kerr), encoding: String.Encoding.ascii) ?? "unknown error"))
              return 0
          }
          
      }
    
    
    
    func convert(cmage:CIImage) -> UIImage
       {
           
           let context:CIContext? = CIContext.init(options: nil)
           guard context != nil else {
               return UIImage()
           }
           let cgImage:CGImage = context!.createCGImage(cmage, from: cmage.extent)!
           let image:UIImage = UIImage.init(cgImage: cgImage)
           return image
       }
    
    
    func openAlert(title:String, message:String) -> UIAlertController{
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
        return alert
        
    }

}
