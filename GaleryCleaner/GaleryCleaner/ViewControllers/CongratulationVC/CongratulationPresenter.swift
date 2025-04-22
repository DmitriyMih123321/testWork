//
//  CongratulationPresenter.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

class CongratulationPresenter {
    fileprivate let congratulationService: CongratulationService
    weak fileprivate var congratulationView: CongratulationProtocol?
    
    init(congratulationService: CongratulationService){
        self.congratulationService = congratulationService
    }
    
    func attachView(_ attach: Bool, view: CongratulationProtocol?) {
        if attach {
            congratulationView = nil
        } else {
            if let view = view { congratulationView = view }
        }
    }
    
    func getCongratulationView(){
        congratulationView?.setupViews()
        congratulationView?.setupInfoLabel(text: congratulationService.getInfo())
        congratulationView?.setupDopInfoLabel(text: congratulationService.getDopInfo())
    }
    
}
