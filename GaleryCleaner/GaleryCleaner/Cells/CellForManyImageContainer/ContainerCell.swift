//
//  ContainerCell.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 11.04.2025.
//

import Foundation
import UIKit
final class ContainerCell: UICollectionViewCell {
   
    @IBOutlet weak var titleLabel: UILabel!
    
    @IBOutlet weak var selectAllButton: UIButton!
    
    @IBOutlet weak var cv: UICollectionView!
    
    var imagesPathsModelArr: [PathModel?] = []
    var delegateParrentVC: MainViewPresenter?
    var imagesPathArray:  Model?
    var order: Int?
    var isSelectLine: Bool = false

    var containerCellPresenter: ContainerCellPresenter?
    
    func setupView(containerCellPresenter: ContainerCellPresenter){
        cv.dataSource = self
        cv.delegate = self
        cv.register(UINib(nibName: "ImageCell", bundle: nil), forCellWithReuseIdentifier: "secondCell")
        
        self.containerCellPresenter = containerCellPresenter
        self.containerCellPresenter?.attachView(false, view: self)
        self.containerCellPresenter?.getContainerCellView()
//        cv.reloadData()
    }
    
    @IBAction func selectAllAct(_ sender: Any) {
        self.containerCellPresenter?.actionPress()
    }
}

extension ContainerCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("Secont View", imagesPathsModelArr.count)
        return imagesPathsModelArr.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ImageCell = collectionView.dequeueReusableCell(withReuseIdentifier: "secondCell", for: indexPath) as! ImageCell
        if let imgPathModel = imagesPathsModelArr[indexPath.item] {
            let imageCellService = ImageCellService()
            imageCellService.setPathModel(pathModel: imgPathModel)
            imageCellService.setPathOrder(pathOrder: self.order)
            imageCellService.setDelegate(containerCell: self.containerCellPresenter)
            let imageCellPresenter = ImageCellPresenter(imageCellService: imageCellService)
            cell.setupView(imageCellPresenter: imageCellPresenter)
        }
        
        return cell
        
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        let reviewSP = ReviewSinglePhotoVC()
        let reviewService = ReviewSinglePhotoService()
        if let imgPath = imagesPathsModelArr[indexPath.item] {
            reviewService.setPath(path: imgPath.imgPath)
            reviewSP.reviewPresenter = ReviewSinglePhotoPresenter(reviewService: reviewService)
            reviewSP.modalPresentationStyle = .overFullScreen
            reviewSP.modalTransitionStyle = .crossDissolve
            if let vcPresenter = delegateParrentVC {
                vcPresenter.openReviewView(reviewVC: reviewSP)
            }
        }
    }
}

extension ContainerCell: ContainerCellProtocol {
    func initialize(imagesPathArray: Model) {
        titleLabel.text = "\(imagesPathArray.imgPathArray.count) Similar"
        self.isSelectLine = imagesPathArray.isSelectLine
        if !isSelectLine {
            selectAllButton.setTitle("Select all", for: .normal)
        } else {
            selectAllButton.setTitle("Deselect all", for: .normal)
        }
        self.imagesPathArray = self.containerCellPresenter?.getModel()
        self.delegateParrentVC = self.containerCellPresenter?.getDelegatePVC()
        self.order = self.containerCellPresenter?.getOrder()
        
        if let imagesPathsModelArr = self.containerCellPresenter?.getModel()?.imgPathArray,
           let select = self.containerCellPresenter?.getIsSelected() {
            self.imagesPathsModelArr = imagesPathsModelArr
            self.isSelectLine = select
        }
        
        cv.reloadData()
    }
    
    func action(isPressed: Bool) {
        cv.reloadData()
    }
    
    
}
