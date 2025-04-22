//
//  ReviewSinglePhotoProtocol.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import UIKit

protocol ReviewSinglePhotoProtocol: NSObjectProtocol {
    func setupView()
    func setupImage(_ withPath: String)
}
