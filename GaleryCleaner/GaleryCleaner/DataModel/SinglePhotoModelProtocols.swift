//
//  SinglePhotoModelProtocol.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation

protocol ModelProtocol {
    var order: Int { get set }
    var imgPathArray: [PathModel?] { get set }
    var isSelectLine: Bool { get set }
}
protocol ModelProtocolService {
    func changeValuesModel(order: Int?, isSelectedLine: Bool?, pathModel: [PathModel?]) -> Model
}
