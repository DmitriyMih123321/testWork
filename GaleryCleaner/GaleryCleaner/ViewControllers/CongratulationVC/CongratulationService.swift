//
//  CongratulationProtocolService.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation

class CongratulationService {
    
    private var textInfo: String?
    private var textDopInfo: String?
    
    func setInfo(textInfo: String) {
        self.textInfo = textInfo
    }
    func getInfo()-> String {
        return self.textInfo ?? ""
    }
    
    func setDopInfo(dopInfo: String) {
        self.textDopInfo = dopInfo
    }
    func getDopInfo() -> String {
        return self.textDopInfo ?? ""
    }
    
}
