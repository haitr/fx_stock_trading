//
//  AppDelegate.swift
//  fx-native-app
//
//  Created by Cy2code-Hai on 2020/03/02.
//  Copyright © 2020 Cy2code-Hai. All rights reserved.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    var window: UIWindow?
    var appCoordinator: AppCoordinator<MainView>!
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        window = UIWindow(frame: UIScreen.main.bounds)
        appCoordinator = AppCoordinator(window: window)
        appCoordinator.invoke()
//        InjectIII config
        #if DEBUG
//        Bundle(path: "/Applications/IsnjectionIII.app/Contents/Resources/iOSInjection.bundle")?.load()
        #endif
        return true
    }
}

