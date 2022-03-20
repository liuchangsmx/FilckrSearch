//
//  AppDelegate.swift
//  FlickrSearch
//
//  Created by 刘畅 on 2022/3/18.
//

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    let homeViewController = UINavigationController(rootViewController: HomeViewController.instantiate())

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        setupViewController()
        return true
    }

}


// MARK: - ViewController&Appearance
extension AppDelegate {
    
    private func setupViewController() {
        window = UIWindow(frame: UIScreen.main.bounds)
        window!.backgroundColor = #colorLiteral(red: 1, green: 1, blue: 1, alpha: 1)
        window!.makeKeyAndVisible()
        window!.rootViewController = homeViewController
    }
}

