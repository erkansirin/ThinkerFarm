//
//  DetectionResultsCell.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 14.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit

class DetectionResultsCell: UICollectionViewCell {
    @IBOutlet weak var detectionImage: UIImageView!
    
    @IBOutlet weak var classNameLabel: UILabel!
    @IBOutlet weak var thresholdLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

}
