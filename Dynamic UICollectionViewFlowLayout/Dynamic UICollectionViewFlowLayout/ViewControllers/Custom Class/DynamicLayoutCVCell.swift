//
//  DynamicLayoutCVCell.swift
//  Dynamic UICollectionViewFlowLayout
//
//  Created by Meet Soni on 06/08/20.
//  Copyright © 2020 Meet Soni. All rights reserved.
//

import UIKit

class DynamicLayoutCVCell: UICollectionViewCell {

    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var dynamicImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }

}
