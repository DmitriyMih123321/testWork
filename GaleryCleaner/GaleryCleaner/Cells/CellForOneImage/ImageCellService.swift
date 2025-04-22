//
//  ImageCellService.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

class ImageCellService {
    private var pathModel: PathModel?
    private var pathOrder: Int?
    private var delegateContainerCell: ContainerCellPresenter?
    private var selectFlag: Bool = false
   
    func setPathModel(pathModel: PathModel?) {
        self.pathModel = pathModel
        self.selectFlag = pathModel?.isSelectCell ?? false
    }
    func setPathOrder(pathOrder: Int?) {
        self.pathOrder = pathOrder
    }
    func setDelegate(containerCell: ContainerCellPresenter?) {
        self.delegateContainerCell = containerCell
    }
    
    func getPathModel() -> PathModel? {
        return self.pathModel
    }
    func getSelectFlag() -> Bool {
        return self.selectFlag
    }
    func getPathOrder() -> Int? {
        return self.pathOrder
    }
    func getDelegate() -> ContainerCellPresenter? {
        return self.delegateContainerCell
    }
    
    func updateSelectedPathModels(flag: Bool) {
        if let pathModel = self.pathModel {
            let newPathModel = PathModel(index: pathModel.index, imgPath: pathModel.imgPath, isSelectCell: flag, photoAsset: pathModel.photoAsset)
            
            if let delegateContainerCell = delegateContainerCell {
                if let _ = delegateContainerCell.getModel() {
                    autoreleasepool{
                        var model = delegateContainerCell.getModel()!
                        model.imgPathArray.removeAll(where: {$0 == newPathModel && $0?.index == newPathModel.index})
                        model.imgPathArray.append(newPathModel)
                        model.imgPathArray = model.imgPathArray.sorted(by: {$0!.index < $1!.index})
                        print("updateSelectedPaths ", model)
                        delegateContainerCell.setModel(model)
                        delegateContainerCell.updateCV_ifNoPressedSelectedAct(imgModel: model)
                    }
                }
            }
        }
    }
    func checkSelectedCell() -> Bool {
        if let pathModel = self.pathModel {
            return pathModel.isSelectCell
        } else {
            return false
        }
    }
    
    func actionPress() -> Bool {
        selectFlag = !selectFlag
        
        updateSelectedPathModels(flag: selectFlag)
        
        return selectFlag
    }
    
}
