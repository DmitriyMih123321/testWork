//
//  ViewController.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 10.04.2025.
//

import UIKit
import AVFoundation
import Photos
final class ViewController: UIViewController {
  

    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var containerViewCV: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var deleteButton: UIButton!
  
    @IBOutlet weak var activityIndicator: UIActivityIndicatorView!
    @IBOutlet weak var analiseLabel: UILabel!
    
//    var imageMassive: [[(PHAsset,String)]] = []
//    private var assets: PHFetchResult<AnyObject>?
//    private var mediaType: PHAssetMediaType = .image
    
//    var modelsArray: [Model] = []
//    var modelsForRemoveArray: [Model] = []
//    var imageMassive2: [(PHAsset,String)] = []
//    var changeCount: ChangeCounting = ChangeCounting()
//    var countAllModelsValues = ChangeCounting()
//    var appDelegate = UIApplication.shared.delegate as? AppDelegate
   let mainViewPresenter = MainViewPresenter(mainViewService: MainViewService())
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print("MainView")
        mainViewPresenter.attachView(false, view: self)
        mainViewPresenter.configurating(isOff: true)
        
        mainViewPresenter.getFromGallery()
        mainViewPresenter.getCallback {
            self.mainViewPresenter.configuratingAfterTranform()
        }
        
    }
    
    @IBAction func deleteAction(_ sender: Any) {
        self.mainViewPresenter.deleteAct()
    }

}
extension ViewController: UICollectionViewDelegate, UICollectionViewDataSource {
   
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        print("First View", self.mainViewPresenter.getModels().count)
        let modelsArray = self.mainViewPresenter.getModels().sorted(by: {$0.order < $1.order})
        return modelsArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell: ContainerCell = collectionView.dequeueReusableCell(withReuseIdentifier: "firstCell", for: indexPath) as! ContainerCell
        let containerCellService = ContainerCellService()
        containerCellService.setImagesModel(imageModel: self.mainViewPresenter.getModels()[indexPath.item])
        containerCellService.setOrder(order: self.mainViewPresenter.getModels()[indexPath.item].order)
        containerCellService.setIndexPath(indexPath: indexPath)
        containerCellService.setDelegateParrentVC(delegate: self.mainViewPresenter)
        let containerCellPresenter = ContainerCellPresenter(containerCellService: containerCellService)
        cell.setupView(containerCellPresenter: containerCellPresenter)
     
        return cell
        
    }
}
extension ViewController: MainViewProtocol {
    func setupSubtitleText(_ text: String) {
        self.subtitleLabel.text = text
    }
    
    func setupTitleForDellBtn(_ text: String) {
        self.deleteButton.setTitle(text, for: .normal)
    }
    
    func openReviewView(reviewVC: ReviewSinglePhotoVC) {
        self.present(reviewVC, animated: true)
    }
    
    func reloadCollection(indexPath: IndexPath) {
        self.collectionView.reloadItems(at: [indexPath])
    }
    
    func showDeleteButton(countForShow: ChangeCounting) {
        let changeCount = self.mainViewPresenter.getCountToDelete()
        if changeCount.countSelect != 0 {
            deleteButton.isHidden = false
        } else {
            deleteButton.isHidden = true
        }
    }
    
    func setupConfigure(isOff: Bool) {
        titleLabel.isHidden = isOff ? true : false
        subtitleLabel.isHidden = isOff ? true : false
        deleteButton.isHidden = true
        collectionView.isHidden = isOff ? true : false
        activityIndicator.isHidden = isOff ? false : true
        if isOff {
            activityIndicator.startAnimating()
        } else {
            activityIndicator.stopAnimating()
        }
        analiseLabel.isHidden = isOff ? false : true
    }
    
    func setupConfigureAfterTransform() {
        let countAll: ChangeCounting = ChangeCounting()
        countAll.takeCount(modelArray: self.mainViewPresenter.getModels())
        self.mainViewPresenter.setAllCount(countAll)
        self.subtitleLabel.text = "\(self.mainViewPresenter.getCountAll().countSelect) • \(self.mainViewPresenter.getCountToDelete().countSelect) selected"
        self.deleteButton.setTitle("Delete \(0) Similars", for: .normal)
        self.deleteButton.roundCorners(.allCorners, radius: 24)
        self.deleteButton.isHidden = true
        self.containerViewCV.roundCorners([.topLeft, .topRight], radius: 20)
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.collectionView.register(UINib(nibName: "ContainerForImageCell", bundle: nil), forCellWithReuseIdentifier: "firstCell")
        self.mainViewPresenter.configurating(isOff: false)
    }
    
    func deleteAction() {
        let customAlert = CustomAlertForDell()
        let alertService = CustomAlertService()
        let pressetPath = self.mainViewPresenter.getPathFirstDellImage()
        alertService.setInfo("Allow to \"Cleanup\" to delete \(self.mainViewPresenter.getCountToDelete().countSelect) photos?", "These photos will be deleted from iCloud Photos on all you devices.", imagePath: pressetPath)
        customAlert.alertPresenter = CustomAlertPresenter(alertService: alertService)
        
        customAlert.deleteAction = { [self] in
            let congratulationVC = CongratulationVC()
            let congrService = CongratulationService()
            congrService.setInfo(textInfo: "You have deleted \(self.mainViewPresenter.getCountToDelete().countSelect) Photos ( \(String(format:"%.2f",self.mainViewPresenter.getCountToDelete().fileSize)) MB)")
            congrService.setDopInfo(dopInfo: "You saved few mins")
            congratulationVC.congratulationPresenter = CongratulationPresenter(congratulationService: congrService)
           
            congratulationVC.cancelAction = { [self] in
                subtitleLabel.text = "\(self.mainViewPresenter.getCountAll().countSelect) • \(self.mainViewPresenter.getCountToDelete().countSelect) selected"
                deleteButton.setTitle("Delete 0 Similars", for: .normal)
                deleteButton.isHidden = true
                DispatchQueue.main.async {
                    self.collectionView.reloadData()
                }
            }
            var photoAssets: [PHAsset] = []
            self.mainViewPresenter.getModels().forEach { temp in
                autoreleasepool{
                    let item = temp
                    item.imgPathArray.forEach{ pathModel in
                        if let pm = pathModel {
                            if pm.isSelectCell {
                                if let photo = pm.photoAsset {
                                    photoAssets.append(photo)
                                }
                            }
                        }
                    }
                }
            }

            print("DELL ", self.mainViewPresenter.getModels())
           
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.deleteAssets(photoAssets as NSFastEnumeration)
            }, completionHandler: { success, error in
                if success && error == nil {
                    DispatchQueue.main.async {
                        var newModels = self.mainViewPresenter.getModels()
                        newModels = newModels.map{ temp -> Model in
                            autoreleasepool{
                                var item = temp
                                item.isSelectLine = false
                                item.imgPathArray.removeAll(where: {$0!.isSelectCell})
                                item.imgPathArray.sort(by: {$0!.index < $1!.index})
                                return item
                            }
                        }
                    
                        newModels.removeAll(where: {$0.imgPathArray.count == 0})
                        self.mainViewPresenter.setModels(newModels)
                        let countAll: ChangeCounting = ChangeCounting()
                        countAll.takeCount(modelArray: newModels)
                        self.mainViewPresenter.setAllCount(countAll)
                        let countDell: ChangeCounting = ChangeCounting()
                        self.mainViewPresenter.setCountToDelete(countDell)
                        
                        congratulationVC.modalPresentationStyle = .overFullScreen
                        congratulationVC.modalTransitionStyle = .crossDissolve
                        self.present(congratulationVC, animated: true, completion: nil)
                    }
                }
                
                if let _ = error {
                    DispatchQueue.main.async() {
                        self.collectionView.reloadData()
                    }
                }
            })
        }
        
        customAlert.modalPresentationStyle = .overFullScreen
        customAlert.modalTransitionStyle = .crossDissolve
        present(customAlert, animated: true, completion: nil)
        
    }
    
}

