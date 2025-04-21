//
//  ImageCellProtocol.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

protocol ImageCellProtocol: NSObjectProtocol {
    func initialize(path: PathModel?, order: Int?)
    func action(isPressed: Bool)
    func check_isSelectedCell(isSelected: Bool)
}

