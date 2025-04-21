//
//  MainViewProtocolService.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 17.04.2025.
//

import Foundation
import UIKit
import Photos

class MainViewService {
    
    var compareOver: (()->Void)?
    
    private var imageMassive: [[(PHAsset,String)]] = []
    private var assets: PHFetchResult<AnyObject>?
    private var mediaType: PHAssetMediaType = .image
    
    private var modelsArray: [Model] = []
    private var modelsForRemoveArray: [Model] = []
    private var imageMassive2: [(PHAsset,String)] = []
    private var changeCount: ChangeCounting = ChangeCounting()
    private var countAllModelsValues = ChangeCounting()
    private var subtitleText: String = ""
    private var dellBtnTitle: String = ""
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    
    
    func setModelsArray(models: [Model]){
        self.modelsArray = models
    }
    func setChangeCount(_ count: ChangeCounting){
        self.changeCount = count
    }
    func setCountAllModelsValues(_ count: ChangeCounting){
        self.countAllModelsValues = count
    }
    func setSubtitleText(text: String){
        self.subtitleText = text
    }
    func setDellBtnTitle(text: String){
        self.dellBtnTitle = text
    }
    func getSubtitleText() -> String {
        return self.subtitleText
    }
    func getModelsArray() -> [Model] {
        return modelsArray
    }
    
    func getDellBtnTitle() -> String {
        return self.dellBtnTitle
    }
    
    func getChangeCount() -> ChangeCounting {
        return changeCount
    }
    
    func getCountAllModelsValues() -> ChangeCounting {
        return countAllModelsValues
    }
    
    func getFromGalleryS(){
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        let group = DispatchGroup()
        imageMassive2.removeAll()
        self.assets = nil
        let option = PHFetchOptions()
        option.sortDescriptors = [NSSortDescriptor(key: "creationDate", ascending: false)]
        
        self.assets = PHAsset.fetchAssets(with: self.mediaType, options: option) as? PHFetchResult<AnyObject>
        
        if let assets = assets {
            for i in 0..<assets.count {
                let photo = assets[i] as! PHAsset
                group.enter()
                photo.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { editingInput, info in
                    if let input = editingInput, let imgURL = input.fullSizeImageURL {
                        self.imageMassive2.append((photo,imgURL.path))
                        group.leave()
                    } else {
                        group.leave()
                    }
                }
            }
            group.notify(queue: DispatchQueue.main) {
                print("Gallary added ", self.imageMassive2.count)
                self.assets = nil
                self.compareAlgoritm()
            }
            /*
            var assetsCounting_forConcurent = [Bool].init(repeating: false, count: assets.count)
            var photos = [(PHAsset,String)].init(repeating: (PHAsset(), ""), count: assets.count)
            DispatchQueue.concurrentPerform(iterations: assets.count){ i in
                let photo = assets[i] as! PHAsset
                
                group.enter()
                photo.requestContentEditingInput(with: PHContentEditingInputRequestOptions()) { editingInput, info in
                    if let input = editingInput, let imgURL = input.fullSizeImageURL {
                        photos[i] = (photo,imgURL.path)
//                        self.imageMassive2.append((photo,imgURL.path))
                        assetsCounting_forConcurent[i] = true
                        group.leave()
                    } else {
                        assetsCounting_forConcurent[i] = true
                        group.leave()
                    }
                }
            }
            group.notify(queue: DispatchQueue.main) {
                print("Gallary added ", self.imageMassive2.count)
                queue.sync {
                    let isFinal = assetsCounting_forConcurent.filter{$0 == false}
                    if isFinal.count == 0 {
                        self.assets = nil
                        self.imageMassive2 = photos
                        self.compareAlgoritm()
                    }
                }
            }
            */
        }
    }
    
    private func compareAlgoritm(){
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        if imageMassive2.count != 0 {
            var similarImageMass: [(PHAsset,String)] = []
            print("Count do algoritma",imageMassive2.count)
            let countParts = imageMassive2.count
            var parts = [Bool].init(repeating: false, count: countParts)
            
            DispatchQueue.concurrentPerform(iterations: imageMassive2.count) { i in
                autoreleasepool {
                    
                    var similarPart: [(PHAsset,String)] = []
                    let img1 = UIImage(contentsOfFile: imageMassive2[0].1)
                    let img2 = UIImage(contentsOfFile: imageMassive2[i].1)
                    
                    let S = algoritmShodstva(img1: img1, img2: img2)
//                    print("S = ", S)
                    if S < 70 {
                        similarPart.append(imageMassive2[i])
                        if i != 0 {
                            imageMassive2[i].1 = ""
                        }
                    }
                    
                    queue.sync {
                       
                        similarImageMass += similarPart
                        
                        parts[i] = true
                        let check = parts.filter{$0 != true}
                        if check.count == 0 {
                            imageMassive.append(similarImageMass)
                            imageMassive2[0].1 = ""
                            imageMassive2.removeAll(where: {$0.1 == ""})
                            imageMassive.removeAll(where: {$0.count == 0})
                            print("Count after algoritma",imageMassive2.count)
                            compareAlgoritm()
                        }
                        return
                    }
                }
            }
        } else {
            print("callback here")
            transforStringArraysToImageModel()
            //            compareOver?()
        }
    }
    private func algoritmShodstva(img1: UIImage?, img2: UIImage?) -> Double {
        
        let queue = DispatchQueue.global(qos: .userInteractive)
        
        let toCompareImg1 = img1?.convertToGrayScale(image: img1?.createMiniture(image: img1))
        let toCompareImg2 = img2?.convertToGrayScale(image: img2?.createMiniture(image: img2))
        
        let pixelImg1 = toCompareImg1?.pixelValuesFromImage(imageRef: toCompareImg1?.cgImage).pixelValues
        let pixelImg2 = toCompareImg2?.pixelValuesFromImage(imageRef: toCompareImg2?.cgImage).pixelValues
        //        print("count ", pixelImg1!.count, " I ", pixelImg2!.count)
        //ALGORITM
        var summary = [Double].init(repeating: 0, count: 16)
        
        var S = 0.0
        
        DispatchQueue.concurrentPerform(iterations: 16) { i in
            
            let base = i*64
            var sum = 0.0
            for x in base..<base + 64 {
                sum = sum + (pow((Double(pixelImg1![x]) - Double(pixelImg2![x])),2) / 1024.0)
            }
            
            queue.sync {
                summary[i] = sum
                return
            }
        }
        
        S = sqrt(summary.reduce(0, +))
       
        
        
        /*
         for i in 0..<1024 {
         S = S + (pow((Double(pixelImg1![i]) - Double(pixelImg2![i])),2) / 1024.0)
         }
         S = sqrt(S) */
        //        print("Stepen shodstva", " ", S)
        return S
    }
    
    private func transforStringArraysToImageModel() {
        DispatchQueue.main.async { [self] in
            modelsArray.removeAll()
            let queueLine = DispatchQueue.global(qos: .userInteractive)
            let queueRow = DispatchQueue.global(qos: .userInteractive)
            
            //Delete if one image in Line
            imageMassive = imageMassive.filter{$0.count != 1}
            print("Final Data ", imageMassive.count)
            //-----
            var allLineIsGets = [Bool].init(repeating: false, count: imageMassive.count)
            modelsArray = [Model](repeating: Model(order: 0, isSelectLine: false, imgPathArray: []), count: imageMassive.count)
            DispatchQueue.concurrentPerform(iterations: allLineIsGets.count) { i in
                autoreleasepool{
                    var pathModelArray: [PathModel] = []
                    var allRowsIsGets = [Bool].init(repeating: false, count: imageMassive[i].count)
                    
                    DispatchQueue.concurrentPerform(iterations: allRowsIsGets.count) { j in
                        autoreleasepool{
                            let pathModel = PathModel(index: j, imgPath: imageMassive[i][j].1, isSelectCell: false, photoAsset: imageMassive[i][j].0)
                            pathModelArray.append(pathModel)
                        }
                            queueRow.sync{
                                allRowsIsGets[j] = true
                            }
                        
                    }
                    queueLine.sync {
                        let checkRows = allRowsIsGets.filter{$0 != true}
                        if checkRows.count == 0 {
                            let model = Model(order: i, isSelectLine: false, imgPathArray: pathModelArray)
                            
                            modelsArray[i] = model
                            allLineIsGets[i] = true
                            let checkLines = allLineIsGets.filter{$0 != true}
                            if checkLines.count == 0 {
                                DispatchQueue.main.async {
                                    self.countAllModelsValues.takeCount(modelArray: self.modelsArray)
                                    self.setSubtitleText(text: "\(self.countAllModelsValues.countSelect) • \(self.changeCount.countSelect) selected")
                                    self.setDellBtnTitle(text: "Delete \(0) Similars")
                                    
                                    self.compareOver?()
                                    
                                }
                            }
                        }
                        
                    }
                }
            }
        }
    }
    func getFirstImgPathForDell() -> String {
        var path = ""
        modelsArray.forEach{item in
            if let pathModel = item.imgPathArray.filter({$0!.isSelectCell}).first,
               let pathImg = pathModel?.imgPath {
                path = pathImg
            }
        }
        return path
    }
}
