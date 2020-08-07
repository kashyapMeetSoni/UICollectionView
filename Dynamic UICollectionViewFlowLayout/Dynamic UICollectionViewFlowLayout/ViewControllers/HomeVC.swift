//
//  HomeVC.swift
//  Dynamic UICollectionViewFlowLayout
//
//  Created by Meet Soni on 06/08/20.
//  Copyright © 2020 Meet Soni. All rights reserved.
//

import UIKit

struct Photos {
    var image: UIImage
}

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, DynamicLayoutDelegate, UIScrollViewDelegate {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    var photo : [Photos] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.register(UINib.init(nibName: "DynamicLayoutCVCell", bundle: nil), forCellWithReuseIdentifier: "DynamicLayoutCVCell")
        
        if let layout = collectionView?.collectionViewLayout as? DynamicLayout {
            layout.delegate = self
        }
        
        collectionView?.contentInset = UIEdgeInsets(top: 23, left: 16, bottom: 10, right: 16)
        
        setupData()
    }
    
    fileprivate func setupData() {
        for index in 1...11 {
            let image = UIImage.init(named: "\(index)")
            let photos = Photos(image: image ?? UIImage())
            photo.append(photos)
        }
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        for view in collectionView.visibleCells {
            if let view:DynamicLayoutCVCell = view as? DynamicLayoutCVCell {
               let yOffset:CGFloat = ((collectionView.contentOffset.y - view.frame.origin.y) / 200) * 15
                view.setImageOffset(imageOffset: CGPoint(x: 0, y: yOffset))
                
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return photo.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DynamicLayoutCVCell", for: indexPath) as! DynamicLayoutCVCell
        cell.dynamicImage.image = photo[indexPath.row].image
        let yOffset:CGFloat = ((collectionView.contentOffset.y - cell.frame.origin.y) / 200) * 25
        cell.imageOffset = CGPoint(x: 0, y: yOffset)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let itemSize = (collectionView.frame.width - (collectionView.contentInset.left + collectionView.contentInset.right + 10)) / 2
        return CGSize(width: itemSize, height: itemSize)
    }
    
    func collectionView(_ collectionView: UICollectionView, heightForPhotoAtIndexPath indexPath: IndexPath) -> CGFloat {
        return photo[indexPath.row].image.size.height / 3
    }
}
