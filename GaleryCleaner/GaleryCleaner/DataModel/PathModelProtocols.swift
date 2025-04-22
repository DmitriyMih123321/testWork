//
//  PathModelProtocols.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import Photos

protocol PathModelProtocol {
    var index: Int { get set }
    var imgPath: String { get set }
    var isSelectCell: Bool { get set }
    var photoAsset: PHAsset? { get set }
}

protocol PathModelProtocolService {
    func changeValuesPathModel(index: Int?, isSelectCell: Bool?, imgPath: String) -> PathModel
}
