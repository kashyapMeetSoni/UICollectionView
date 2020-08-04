//
//  HomeVC.swift
//  Drag n Drop UICollectionView
//
//  Created by Meet Soni on 28/07/20.
//  Copyright © 2020 Meet Soni. All rights reserved.
//

import UIKit
import AnimatableReload

class HomeVC: UIViewController, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var button: UIButton!
    
    var isEnded: Bool = true
    var currentCell: UICollectionViewCell? = nil
    
    
    var array = ["1","2","3","4","5","6","7","8","9","10"]
    var newArray = ["1","6","2","3","4","5","7","8","9","10"]
    
    fileprivate var longPressGesture : UILongPressGestureRecognizer!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        collectionView.register(UINib.init(nibName: "DragNDropCVCell", bundle: nil), forCellWithReuseIdentifier: "DragNDropCVCell")
        
        longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(self.handleLongGesture(gesture:)))
        collectionView.addGestureRecognizer(longPressGesture)
    }
    
    @objc func handleLongGesture(gesture : UILongPressGestureRecognizer) {
        switch (gesture.state) {
            
        case .began:
            guard let selectedIndexPath = collectionView.indexPathForItem(at: gesture.location(in: collectionView)) else {
                break
            }
            isEnded = false
            //store selected cell in currentCell variable
            currentCell = collectionView.cellForItem(at: selectedIndexPath)
            collectionView.beginInteractiveMovementForItem(at: selectedIndexPath)
        
        case .changed:
            collectionView.updateInteractiveMovementTargetPosition(gesture.location(in: gesture.view))
            
        case .ended:
            isEnded = true
            collectionView.performBatchUpdates({
                self.collectionView.endInteractiveMovement()
            }) { (result) in
                self.currentCell = nil
            }
        default:
            isEnded = true
            collectionView.cancelInteractiveMovement()
        }
    }
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return array.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if currentCell != nil && isEnded {
            return currentCell!
        } else {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "DragNDropCVCell", for: indexPath as IndexPath) as! DragNDropCVCell
            cell.label.text = array[indexPath.row]
            cell.layer.cornerRadius = 5.0
            return cell
        }
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: view.frame.width / 1.110, height: 60.0 )
    }
    
    func collectionView(_ collectionView: UICollectionView, canMoveItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    func collectionView(_ collectionView: UICollectionView, moveItemAt sourceIndexPath: IndexPath, to destinationIndexPath: IndexPath) {
        
        if self.longPressGesture.state == .ended {
            return
        }
        
        let item = self.array.remove(at: sourceIndexPath.item)
        self.array.insert(item, at: destinationIndexPath.item)
        
        print(array)
    }
    
    
    
    @IBAction func actionButton(_ sender: UIButton) {
        UIView.animate(withDuration: 0.5,
                       delay: 0.0,
                       options: UIView.AnimationOptions.transitionCrossDissolve,
                       animations: { () -> Void in
                        self.array.insert("6", at: 1)
                        self.array.remove(at: 6)
                        self.collectionView.reloadData()
        }, completion: { (finished) -> Void in
        })
//        collectionView.reloadData()
//        for loop in collectionView?.visibleCells ?? [] {
//            loop.alpha = 0.5
//        }
    }
    
}

extension UICollectionViewFlowLayout {
    open override func invalidationContext(forInteractivelyMovingItems targetIndexPaths: [IndexPath], withTargetPosition targetPosition: CGPoint, previousIndexPaths: [IndexPath], previousPosition: CGPoint) -> UICollectionViewLayoutInvalidationContext {

        let context = super.invalidationContext(forInteractivelyMovingItems: targetIndexPaths, withTargetPosition: targetPosition, previousIndexPaths: previousIndexPaths, previousPosition: previousPosition)

        //Check that the movement has actually happeneds
        if previousIndexPaths.first!.item != targetIndexPaths.first!.item {
            collectionView?.dataSource?.collectionView?(collectionView!, moveItemAt: previousIndexPaths.first!, to: targetIndexPaths.last!)
        }

        return context
    }
    
    open override func invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths indexPaths: [IndexPath], previousIndexPaths: [IndexPath], movementCancelled: Bool) -> UICollectionViewLayoutInvalidationContext {
        return super.invalidationContextForEndingInteractiveMovementOfItems(toFinalIndexPaths: indexPaths, previousIndexPaths: previousIndexPaths, movementCancelled: movementCancelled)
    }
    
    open override func layoutAttributesForInteractivelyMovingItem(at indexPath: IndexPath, withTargetPosition position: CGPoint) -> UICollectionViewLayoutAttributes {
        let attributes = super.layoutAttributesForInteractivelyMovingItem(at: indexPath, withTargetPosition: position)
        for loop in collectionView?.visibleCells ?? [] {
            loop.alpha = 0.5
        }
        attributes.alpha = 1
        attributes.transform = .init(scaleX: 0.75, y: 0.75)
        return attributes
    }
    
}
