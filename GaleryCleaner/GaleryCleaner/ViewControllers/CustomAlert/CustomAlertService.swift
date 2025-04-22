//
//  CustomAlertService.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 18.04.2025.
//

import Foundation

//typealias Result = InfoView
class CustomAlertService {
 
    private var titleText: String = ""
    private var messageText: String = ""
    private var imagePath: String = ""
    func setInfo(_ title: String, _ message: String, imagePath: String){
        self.titleText = title
        self.messageText = message
        self.imagePath = imagePath
    }
    func getTitleMessage() -> InfoView {
        return InfoView(titleText: self.titleText, messageText: self.messageText, imagePath: self.imagePath)
    }
}
struct InfoView {
    let titleText:  String
    let messageText: String
    let imagePath: String
    init(titleText: String, messageText: String, imagePath: String) {
        self.titleText = titleText
        self.messageText = messageText
        self.imagePath = imagePath
    }
}
