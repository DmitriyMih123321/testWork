//
//  MainViewPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 20.04.2025.
//

import Foundation

class MainViewPresenter {
    fileprivate let mainViewService: MainViewService
    weak fileprivate var mainView: MainViewProtocol?
    
    init(mainViewService: MainViewService){
        self.mainViewService = mainViewService
    }
    func attachView(_ attach: Bool, view: MainViewProtocol?) {
        if attach {
            mainView = nil
        } else {
            if let view = view { mainView = view }
        }
    }
    func configurating(isOff: Bool){
        mainView?.setupConfigure(isOff: isOff)
    }
    func configuratingAfterTranform(){
        mainView?.setupConfigureAfterTransform()
    }
    func getFromGallery() {
        mainViewService.getFromGalleryS()
    }
    func reloadCollection(indexPath: IndexPath) {
        mainView?.reloadCollection(indexPath: indexPath)
    }
    func deleteAct() {
        mainView?.deleteAction()
    }
    func showDeleteButton(){
        mainView?.showDeleteButton(countForShow: self.mainViewService.getChangeCount())
    }
    
    func setCountToDelete(_ count: ChangeCounting){
        self.mainViewService.setChangeCount(count)
    }
    func setModels(_ models: [Model]) {
        self.mainViewService.setModelsArray(models: models)
    }
    func setAllCount(_ count: ChangeCounting) {
        self.mainViewService.setCountAllModelsValues(count)
    }
    func setSubtitleText(_ text: String){
        self.mainViewService.setSubtitleText(text: text)
    }
    func setDellBtnTitle(_ text: String){
        self.mainViewService.setDellBtnTitle(text: text)
    }
    
    func getCallback(callback: @escaping (()->Void)) {
        self.mainViewService.compareOver = {
            callback()
        }
    }
    func getModels() -> [Model] {
        self.mainViewService.getModelsArray()
    }
    func getCountToDelete() ->  ChangeCounting {
        return self.mainViewService.getChangeCount()
    }
    func getCountAll() ->  ChangeCounting {
        return self.mainViewService.getCountAllModelsValues()
    }
    func getSubtitleText() {
        self.mainView?.setupSubtitleText(self.mainViewService.getSubtitleText())
    }
    func getDellBtnTitle() {
        self.mainView?.setupTitleForDellBtn(self.mainViewService.getDellBtnTitle())
    }
    
    func getPathFirstDellImage() -> String {
        return self.mainViewService.getFirstImgPathForDell()
    }
    
    func openReviewView(reviewVC: ReviewSinglePhotoVC){
        self.mainView?.openReviewView(reviewVC: reviewVC)
    }
}
