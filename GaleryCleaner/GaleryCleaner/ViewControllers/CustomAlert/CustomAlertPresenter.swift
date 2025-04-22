//
//  CustomAlertPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 18.04.2025.
//

import Foundation

class CustomAlertPresenter {

    // MARK: - Private
    fileprivate let alertService: CustomAlertService
    weak fileprivate var alertView: CustomAlertViewProtocol?

    init(alertService: CustomAlertService){
        self.alertService = alertService
    }

    func attachView(_ attach: Bool, view: CustomAlertViewProtocol?) {
        if attach {
            alertView = nil
        } else {
            if let view = view { alertView = view }
        }
    }
    func getAlertView(){
        self.alertView?.setupViews()
        self.alertView?.setTitleLabel(text: self.alertService.getTitleMessage().titleText)
        self.alertView?.setMessageLabel(text: self.alertService.getTitleMessage().messageText)
        self.alertView?.setImage(imagePath: self.alertService.getTitleMessage().imagePath)
        
    }

}
