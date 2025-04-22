//
//  ImageCell.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 10.04.2025.
//


import UIKit
final class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
    @IBOutlet weak var selectButton: UIButton!
    
    var imageCellPresenter: ImageCellPresenter?

    func setupView(imageCellPresenter: ImageCellPresenter){
        self.imageCellPresenter = imageCellPresenter
        self.imageCellPresenter?.attachView(false, view: self)
        self.imageCellPresenter?.getImageCellView()
    }

    @IBAction func selectAct(_ sender: Any) {
        imageCellPresenter?.actionPress()
    }
}
extension ImageCell: ImageCellProtocol {
    func initialize(path: PathModel?, order: Int?) {
        if let pathImg = path?.imgPath {
            
            var img = UIImage(contentsOfFile: pathImg)
            img = img?.createMiniture(image: img, width: 184, height: 215)
            self.imageView.image = img
            
        }
    }
    
    func action(isPressed: Bool) {
        if isPressed {
            selectButton.setImage(UIImage(named: "select"), for: .normal)
        } else {
            selectButton.setImage(UIImage(named: "unselect"), for: .normal)
        }
    }
    
    func check_isSelectedCell(isSelected: Bool) {
        if isSelected {
            selectButton.setImage(UIImage(named: "select"), for: .normal)
        } else {
            selectButton.setImage(UIImage(named: "unselect"), for: .normal)
        }
    }
    
}
