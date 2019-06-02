//
//  AppDelegate.swift
//  Trading
//
//  Created by Vlad Che on 1/23/19.
//  Copyright © 2019 Digicode. All rights reserved.
//

import UIKit
import PromiseKit
import SwiftDate

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        defer { setupWindow() }
        conf.Q = (map: .map, return: .main)
        SwiftDate.defaultRegion = .EST
        UIApplication.shared.applicationSupportsShakeToEdit = true
        return true
    }
    
    //MARK: - Private
    private var coordinator: AppCoordinator!
    
    private func setupWindow() {
        window = UIWindow(frame: UIScreen.main.bounds)
        coordinator = AppCoordinator(with: window!)
        coordinator.setup()
    }
    
    func application(_ app: UIApplication, open url: URL, options: [UIApplication.OpenURLOptionsKey : Any] = [:]) -> Bool {
        do {
            let data = try Data(contentsOf: url)
            try Portfolio.import(data)
        } catch {
            coordinator.topViewController.alert(error.localizedDescription)
        }
        return true
    }
}

//MARK: - App Lifecycle

extension AppDelegate {
    func applicationWillResignActive(_ application: UIApplication) {
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
    }
    
    func applicationWillEnterForeground(_ application: UIApplication) {
    }
    
    func applicationDidBecomeActive(_ application: UIApplication) {
    }
    
    func applicationWillTerminate(_ application: UIApplication) {
    }
}

