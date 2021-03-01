//
//  AppDelegate.swift
//  SocialApp - MVVMC
//
//  Created by Oleksandr Bretsko on 2/26/21.
//

import UIKit

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    private lazy var appCoordinator: CoordinatorP = {
        self.window = UIWindow(frame: UIScreen.main.bounds)
        let navVC = UINavigationController()
        window!.rootViewController = navVC
        window!.makeKeyAndVisible()
        let router = Router(rootController: navVC)
        return AppCoordinator(router)
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        appCoordinator.start()
        return true
    }
}

