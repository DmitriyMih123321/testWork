//
//  ContainerCellPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

class ContainerCellPresenter {
    fileprivate let containerCellService: ContainerCellService
    weak fileprivate var containerCell: ContainerCellProtocol?
    
    init(containerCellService: ContainerCellService){
        self.containerCellService = containerCellService
    }

    func attachView(_ attach: Bool, view: ContainerCellProtocol?) {
        if attach {
            containerCell = nil
        } else {
            if let view = view { containerCell = view }
        }
    }
    func getContainerCellView(){
        if let model = self.containerCellService.getImagesModel(){
            containerCell?.initialize(imagesPathArray: model)
        }
    }
    func setModel(_ model: Model) {
        self.containerCellService.setImagesModel(imageModel: model)
    }
    func setPathModelArr(_ pathModels: [PathModel?]){
        self.containerCellService.setImagesPathsModelArr(pathModel: pathModels)
    }
    
    func getModel() -> Model?{
        return self.containerCellService.getImagesModel()
    }
    func getPathModelArr() -> [PathModel?] {
        return self.containerCellService.getImagesPathsModelArr()
    }
    func getIsSelected() -> Bool {
        return self.containerCellService.getIsSelectedLine()
    }
    func getDelegatePVC() -> MainViewPresenter? {
        return self.containerCellService.getDelegateParrentVC()
    }
    func getOrder() -> Int? {
        return self.containerCellService.getOrder()
    }
    
    func updateCV_ifNoPressedSelectedAct(imgModel: Model) {
        self.containerCellService.updateCV_ifNoPressedSelectedAct(imgModel: imgModel)
    }
    
    func actionPress() {
        
        containerCell?.action(isPressed: self.containerCellService.action())
    }
}
