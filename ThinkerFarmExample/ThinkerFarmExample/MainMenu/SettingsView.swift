//
//  SettingsView.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 16.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit
import ThinkerFarm.Swift
class SettingsView: UIViewController {
    
    @IBOutlet weak var showBoxesSwitch: UISwitch!
    @IBOutlet weak var showLabelBackgroundSwitch: UISwitch!
    @IBOutlet weak var showLabelSwitch: UISwitch!
    @IBOutlet weak var tresholdLabel: UILabel!
    @IBOutlet weak var settingsLabel: UILabel!
    @IBOutlet weak var sliderThreshold: UISlider!
    @IBOutlet weak var videoFrameRateLabel: UILabel!
    
    @IBOutlet weak var videoFramerateSlider: UISlider!
    override func viewDidLoad() {
        super.viewDidLoad()

         self.sliderThreshold.value = ModelSettings.threshold
               tresholdLabel.text = "Threshold Value : \(ModelSettings.threshold)"
               showBoxesSwitch.setOn(ModelSettings.HideBox, animated: true)
               showLabelBackgroundSwitch.setOn(ModelSettings.hideBoxBackground, animated: true)
               showLabelSwitch.setOn(ModelSettings.hideClassLabels, animated: true)
        
        self.videoFramerateSlider.value = Float(ModelSettings.videoAnalysisFrameRate)
        
        
        if Int(ModelSettings.videoAnalysisFrameRate) > 5 {
            videoFrameRateLabel.text = "Video analysis frame rate: \(ModelSettings.videoAnalysisFrameRate). Warning high memory impact"
        }else {
            videoFrameRateLabel.text = "Video analysis frame rate: \(ModelSettings.videoAnalysisFrameRate)"
        }
        
        
    }


  @IBAction func backAction(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
      
    }
    
    
    @IBAction func switchValueChange(_ sender: UISwitch) {
        
        if sender.tag == 1 {
            if sender.isOn {
                ModelSettings.hideClassLabels = true
            }else{
                ModelSettings.hideClassLabels = false
            }
            
        }
        
        if sender.tag == 2 {
            
            if sender.isOn {
                ModelSettings.hideBoxBackground =  true
            }else{
                ModelSettings.hideBoxBackground =  false
            }
            
            
        }
        
        if sender.tag == 3 {
            
            if sender.isOn {
                ModelSettings.HideBox =  true
            }else{
                ModelSettings.HideBox =  false
            }
            
            
        }
        
    }
    
    @IBAction func videoFrameValueChange(_ sender: UISlider) {
        
        ModelSettings.videoAnalysisFrameRate = Int(sender.value)
        if Int(sender.value) > 5 {
            videoFrameRateLabel.text = "Video analysis frame rate: \(Int(sender.value)). Warning high memory impact"
        }else {
            videoFrameRateLabel.text = "Video analysis frame rate: \(Int(sender.value))"
        }
        
        
        
    }
    
    @IBAction func thresholdValue(_ sender: UISlider) {
           
           ModelSettings.threshold = Float(sender.value)
           tresholdLabel.text = "Threshold Value : \(Float(sender.value))"
       }

}
