//
//  AppDelegate.swift
//  GaleryCleaner
//
//  Created by Dmitriy Mikhaylov on 10.04.2025.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    var observer_appFocus: NSObjectProtocol!
//    var obvserver_Resign: NSObjectProtocol!
    
    var callbackAppDelegate: (()->Void)?
    private var firstActiveFocusObserver: Int = 0
    // Проверка доступов у приложения
    var accessesIsGranted: Bool! {
        get {
            let bool = UserDefaults.standard.value(forKey: "accessesIsGranted")
            return (bool != nil) ? UserDefaults.standard.bool(forKey: "accessesIsGranted") : false
        }
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        UserDefaults.standard.register(defaults: ["accessesIsGranted":false])
        createAccessObserver()
        return true
    }
    
    private func createAccessObserver(){
        let center = NotificationCenter.default
        observer_appFocus = center.addObserver(forName: UIApplication.didBecomeActiveNotification , object: nil, queue: OperationQueue.main) { [weak self] _ in
            guard let self = self else { return }
            self.appFocusSelector()

        }
    }
 
    private func appFocusSelector() {
        print("active2")
        if self.firstActiveFocusObserver == 0 {
            self.firstActiveFocusObserver += 1
        } else {
            guard let topVC = UIApplication.topViewController() else { return }
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [self] in
                if !accessesIsGranted {
                    print("not access")
                    if let vc = topVC as? AccessViewController {
                        vc.didLoad(access: accessesIsGranted)
                    }
                } else {
                    print("access")
                    if let vc = topVC as? AccessViewController {
                        if let observer = self.observer_appFocus {
                            NotificationCenter.default.removeObserver(observer)
                            self.firstActiveFocusObserver = 0
                        }
                    }
                }
            }
        }
    }
    
    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }


}

