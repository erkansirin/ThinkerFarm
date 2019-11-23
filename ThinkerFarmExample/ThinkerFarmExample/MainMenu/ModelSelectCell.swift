//
//  ModelSelectCell.swift
//  ThinkerFarmExample
//
//  Created by Erkan SIRIN on 16.11.2019.
//  Copyright © 2019 Erkan SIRIN. All rights reserved.
//

import UIKit

class ModelSelectCell: UICollectionViewCell {
    @IBOutlet weak var modelLogo: UIImageView!
    @IBOutlet weak var downloadStatus: UIImageView!
    @IBOutlet weak var modelLabel: UILabel!
    @IBOutlet weak var progressBar: UIProgressView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
    }

}
