//
//  AccessGalery.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 12.04.2025.
//

import UIKit
import Photos
class AccessesService {
    
    
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    func getGalleryAccess(callback: ((Bool)->Void)?) {
        
        switch PHPhotoLibrary.authorizationStatus(for: .readWrite) {
        case .authorized, .limited:
            UserDefaults.standard.setValue(true, forKey: "accessesIsGranted")
            callback?(true)
            print("def2341")
        default:
            PHPhotoLibrary.requestAuthorization(for: .readWrite) { status in
                print(status)
                switch status {
                case .authorized, .limited:
                    UserDefaults.standard.setValue(true, forKey: "accessesIsGranted")
                    print("def23415")
                    
                    callback?(true)
                    
                default:
                    print("per1")
                    callback?(false)
                }
            }
            print("def")
        }
    }

}
