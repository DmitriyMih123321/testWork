//
//  ImageCellPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

class ImageCellPresenter {
    fileprivate let imageCellService: ImageCellService
    weak fileprivate var imageCell: ImageCellProtocol?
    
    init(imageCellService: ImageCellService){
        self.imageCellService = imageCellService
    }

    func attachView(_ attach: Bool, view: ImageCellProtocol?) {
        if attach {
            imageCell = nil
        } else {
            if let view = view { imageCell = view }
        }
    }
    func getImageCellView(){
        imageCell?.initialize(path: self.imageCellService.getPathModel(), order: self.imageCellService.getPathOrder())
        imageCell?.check_isSelectedCell(isSelected: self.imageCellService.checkSelectedCell())
    }
    
    func actionPress() {
        imageCell?.action(isPressed: self.imageCellService.actionPress())
    }
}
