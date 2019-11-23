//
//  ResourceReport.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 20.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import Foundation

public protocol ResourceReportDelegate : class{
    func updateResourceUsage(memory:String, cpu:String)
}

open class ResourceReport: NSObject{
   
    
    var timer : Timer?
    var counter = 0
   
    public weak var delegate: ResourceReportDelegate?
    private let sessionQueue = DispatchQueue(label: "sessionQueue")

  

    @objc func runTimer() {
        
         let memoryUsage = "MEMORY:\(Tools().reportMemory())MB"
        let cpuUsage = "CPU:\(Int(Tools().cpuUsage()))%"
        self.delegate?.updateResourceUsage(memory: memoryUsage, cpu: cpuUsage)
    
        
    }
    
    
    public override init() {
        super.init()
        

        
        
    }
    
    func start(){
        
            self.timer = Timer.scheduledTimer(timeInterval:1, target:self, selector:#selector(self.runTimer), userInfo: nil, repeats: true)
        
    }
    
    func stop(){
        timer?.invalidate()
        timer = nil
    }
    


}
