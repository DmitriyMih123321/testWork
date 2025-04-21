//
//  CustomAlertViewProtocol.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 18.04.2025.
//

import Foundation
import UIKit

protocol CustomAlertViewProtocol: NSObjectProtocol {
    func setupViews()
    func setTitleLabel(text: String)
    func setMessageLabel(text: String)
    func setImage(imagePath: String)
}
