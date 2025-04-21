//
//  AccessViewController.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 15.04.2025.
//

import Foundation
import UIKit

final class AccessViewController: UIViewController {
    
    let accessPresenter: AccessesPresenter = AccessesPresenter(accessesService: AccessesService())
    var appDelegate = UIApplication.shared.delegate as? AppDelegate
    override func viewDidLoad() {
        print("didload")
        
        accessPresenter.attachView(false, view: self)
        accessPresenter.getAlertView()
    }
    private func showMessageAccess() {
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { (_) in
            if let access = self.appDelegate?.accessesIsGranted {
                if !access{
                    self.showMessageAccess()
                }
            } else {
                self.showMessageAccess()
            }
            
        }
        let settingsAction = UIAlertAction(title: "Show Settings", style: .default) { (_) in
            self.showSettings()
        }
        
        self.showDialogWithButtons(title: "Not Access!", message: "Give permission to use the gallery", actions: [cancelAction, settingsAction], alertStyle: .alert)
        
    }
    private func showSettings(){
        if let url = URL.init(string: UIApplication.openSettingsURLString) {
            UIApplication.shared.open(url, options: [:], completionHandler: nil)
        }
    }
}
extension AccessViewController: AccessesProtocol {
    
    func didLoad(access: Bool) {
        if access {
            print("callback 1")
            if let observer_appFocus = self.appDelegate?.observer_appFocus {
                NotificationCenter.default.removeObserver(observer_appFocus)
                self.appDelegate?.observer_appFocus = nil
            }
            if appDelegate?.observer_appFocus == nil {
                DispatchQueue.main.async {
                    let target = self.storyboard!.instantiateViewController(withIdentifier: "MainVC")
                    target.modalPresentationStyle = .fullScreen
                    self.present(target, animated: true)
                }
            }
            
        } else {
            DispatchQueue.main.async {
                self.showMessageAccess()
            }
        }
    }
    
    
}
