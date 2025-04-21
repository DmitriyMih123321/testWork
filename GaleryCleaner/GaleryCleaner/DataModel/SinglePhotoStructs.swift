//
//  Model.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 12.04.2025.
//

import Foundation

struct Model {
    var order: Int = 0
    var isSelectLine: Bool
    var imgPathArray: [PathModel?] = []
    init(order: Int, isSelectLine: Bool, imgPathArray: [PathModel?]) {
        self.order = order
        self.imgPathArray = imgPathArray
        self.isSelectLine = isSelectLine
    }
    static func setSelectFlag(imgPathArray: [PathModel?], isSelectLine: Bool) -> [PathModel?]{
        var imgPath = imgPathArray
        imgPath = imgPath.map { pathModel -> PathModel? in
            var mutateStruct = pathModel
            mutateStruct?.isSelectCell = isSelectLine
            return mutateStruct }
        return imgPath
        
    }
}



