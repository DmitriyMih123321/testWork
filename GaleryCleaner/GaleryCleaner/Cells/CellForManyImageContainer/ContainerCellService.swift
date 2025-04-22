//
//  ContainerCellService.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

class ContainerCellService {

    private var imagesPathsModelArr: [PathModel?] = []
    private var delegateParrentVC: MainViewPresenter?
    private var imagesModel:  Model?
    private var order: Int?
    private var isSelectLine: Bool = false
    private var indexPath: IndexPath?
    
    func setImagesPathsModelArr(pathModel: [PathModel?]){
        self.imagesPathsModelArr = pathModel
    }
    func getImagesPathsModelArr() -> [PathModel?] {
        return self.imagesPathsModelArr
    }
    
    func setDelegateParrentVC(delegate: MainViewPresenter){
        self.delegateParrentVC = delegate
    }
    func getDelegateParrentVC() -> MainViewPresenter? {
        return self.delegateParrentVC
    }
 
    func setImagesModel(imageModel: Model?){
        self.imagesModel = imageModel
        if let model = self.imagesModel {
            self.isSelectLine = model.isSelectLine
        }
    }
    func getImagesModel() -> Model? {
        return self.imagesModel
    }
    func getIsSelectedLine() -> Bool {
        return self.isSelectLine
    }
    func setOrder(order: Int?){
        self.order = order
    }
    func getOrder() -> Int? {
        return self.order
    }
    
    func setIndexPath(indexPath: IndexPath?){
        self.indexPath = indexPath
    }
    func getIndexPath() -> IndexPath? {
        return self.indexPath
    }
    
    func updateCV_ifNoPressedSelectedAct(imgModel: Model) {
        var imgPaths = imgModel
        if isSelectLine && imgModel.imgPathArray.filter({$0!.isSelectCell}).count == 0 {
            isSelectLine = !isSelectLine
            imgPaths.isSelectLine = isSelectLine
            updateModel(imgModel: imgPaths)
            if let indexPath = indexPath,
               let delegate = delegateParrentVC {
                delegate.reloadCollection(indexPath: indexPath)
//                delegate.collectionView.reloadItems(at: [indexPath])
            }
        } else if !isSelectLine && imgModel.imgPathArray.filter({$0!.isSelectCell}).count == imgModel.imgPathArray.count {
            isSelectLine = !isSelectLine
            imgPaths.isSelectLine = isSelectLine
            updateModel(imgModel: imgPaths)
            if let indexPath = indexPath,
               let delegate = delegateParrentVC {
                delegate.reloadCollection(indexPath: indexPath)
//                delegate.collectionView.reloadItems(at: [indexPath])
            }
        } else {
            updateModel(imgModel: imgPaths)
        }
    }
   private func updateModel(imgModel: Model){
        if let order = order,
           let delegate = delegateParrentVC {
            autoreleasepool{
                
                var newModels = delegate.getModels()
                newModels.removeAll(where: {$0.order == order})
                newModels.append(imgModel)
                newModels = newModels.sorted(by: {$0.order < $1.order})
                delegate.setModels(newModels)
                let countForDell: ChangeCounting = ChangeCounting()
                countForDell.takeCountForDell(modelArray: newModels)
                delegate.setCountToDelete(countForDell)
                delegate.setSubtitleText("\(delegate.getCountAll().countSelect) • \(delegate.getCountToDelete().countSelect) selected")
                delegate.setDellBtnTitle("Delete \(delegate.getCountToDelete().countSelect) Similars")
                delegate.getSubtitleText()
                delegate.getDellBtnTitle()
                delegate.showDeleteButton()
                
                print("protocolCountisselect ", delegate.getCountToDelete().countSelect)
                
            }
        }
    }
    
    func action() -> Bool {
        isSelectLine = !isSelectLine
        if let order = order,
           let imagesModel = self.imagesModel,
           let indexPath = indexPath,
           let delegate = delegateParrentVC {
            let newM = Model(order: order, isSelectLine: isSelectLine, imgPathArray: Model.setSelectFlag(imgPathArray: imagesModel.imgPathArray, isSelectLine: isSelectLine))
            DispatchQueue.main.async {
                self.updateModel(imgModel: newM)
                delegate.reloadCollection(indexPath: indexPath)
            }
            
        }
        return isSelectLine
    }
    
}
