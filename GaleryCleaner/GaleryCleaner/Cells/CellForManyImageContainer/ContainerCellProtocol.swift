//
//  ContainerProtocol.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 19.04.2025.
//

import Foundation

protocol ContainerCellProtocol: NSObjectProtocol {
    func initialize(imagesPathArray: Model)
    func action(isPressed: Bool)
}
