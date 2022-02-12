//
//  AppDelegate.swift
//  BlogApps
//
//  Created by lalu hilman  alfarisyi on 11/02/22.
//

import UIKit
import netfox

@main
class AppDelegate: UIResponder, UIApplicationDelegate {


    var window: UIWindow?
    
    func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        
        createWindow()
        window?.rootViewController = ListPostViewController()
        NFX.sharedInstance().start()
        return true
    }


    private func createWindow() {
        
        let windowFrame = UIScreen.main.bounds
        self.window = UIWindow(frame: windowFrame)
        self.window?.makeKeyAndVisible()
    }
    
}

