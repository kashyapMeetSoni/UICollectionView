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
    
    var imageOffset: CGPoint!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        containerView.layer.cornerRadius = 6
        containerView.layer.masksToBounds = true
    }
    
    var image:UIImage! {
        get {
            return self.image
        }
        
        set {
            self.dynamicImage.image = newValue
            
            if imageOffset != nil {
                setImageOffset(imageOffset: imageOffset)
            }
            else {
                setImageOffset(imageOffset: CGPoint(x: 0, y: 0))
            }
        }
    }
    
    func setImageOffset(imageOffset:CGPoint) {
        self.imageOffset = imageOffset
        let frame:CGRect = dynamicImage.bounds
        let offsetFrame:CGRect = frame.offsetBy(dx: self.imageOffset.x, dy: self.imageOffset.y)
        dynamicImage.frame = offsetFrame
    }

}
