//
//  Protocols.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 11.04.2025.
//

import Foundation

protocol ChangeCountingProtocol{
    var countSelect: Int { get set }
    var fileSize: Double { get set }
}
class ChangeCounting: ChangeCountingProtocol {
    var fileSize: Double = 0.0
    var countSelect: Int = 0
    
    func takeCount(modelArray: [Model]) {
        countSelect = 0
        modelArray.forEach{ item in
            countSelect += item.imgPathArray.count
        }
    }
    
    func takeCountForDell(modelArray: [Model]) {
        countSelect = 0
        fileSize = 0
        modelArray.forEach{ item in
            item.imgPathArray.forEach{ secondItem in
                if let secondItem = secondItem {
                    if secondItem.isSelectCell {
                        countSelect += 1
                        fileSize += secondItem.size
                    }
                }
            }
        }
    }
}

