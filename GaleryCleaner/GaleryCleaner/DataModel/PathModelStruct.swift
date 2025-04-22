//
//  PathModelStruct.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import Photos

struct PathModel: Equatable {
    static func == (lhs: PathModel, rhs: PathModel) -> Bool {
        return lhs.index == rhs.index && lhs.imgPath == rhs.imgPath
    }
    
    var index: Int = 0
    var imgPath: String = ""
    var isSelectCell: Bool
    var size =  0.0
    var photoAsset: PHAsset?
    init(index: Int, imgPath: String, isSelectCell: Bool, photoAsset: PHAsset?) {
        self.index = index
        self.imgPath = imgPath
        self.isSelectCell = isSelectCell
        self.photoAsset = photoAsset
        size = Double(URL(fileURLWithPath: imgPath).fileSize) / 1024.0 / 1024.0
        print(size, " MB")
    }
    
}
