//
//  AccessesPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 18.04.2025.
//

import Foundation

class AccessesPresenter {
    // MARK: - Private
    fileprivate let accessesService: AccessesService
    weak fileprivate var accessesView: AccessesProtocol?
    
   
    init(accessesService: AccessesService){
        self.accessesService = accessesService
    }

    func attachView(_ attach: Bool, view: AccessesProtocol?) {
        if attach {
            accessesView = nil
        } else {
            if let view = view { accessesView = view }
        }
    }
    func getAlertView(){
        if let accesseIsGranted = self.accessesService.appDelegate?.accessesIsGranted {
            if !accesseIsGranted {
                self.accessesService.getGalleryAccess(){ bool in
                    self.accessesView?.didLoad(access: bool)
                }
            } else {
                self.accessesView?.didLoad(access: true)
            }
        }
    }
}
