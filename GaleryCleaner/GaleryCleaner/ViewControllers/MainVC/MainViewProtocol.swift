//
//  mainViewProtocol.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import UIKit
protocol MainViewProtocol: NSObjectProtocol {
   
    func setupConfigure(isOff: Bool)
    func setupConfigureAfterTransform()
    func reloadCollection(indexPath: IndexPath)
    func deleteAction()
    func showDeleteButton(countForShow: ChangeCounting)
    
    func setupSubtitleText(_ text: String)
    func setupTitleForDellBtn(_ text: String)
    func openReviewView(reviewVC: ReviewSinglePhotoVC)
}
