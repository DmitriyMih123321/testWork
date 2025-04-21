//
//  ReviewSPProtocolService.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import UIKit

class ReviewSinglePhotoService {
    
    private var path: String?
    
    func setPath(path: String){
        self.path = path
    }
    func getPath() -> String {
        return self.path ?? ""
    }
  
}
