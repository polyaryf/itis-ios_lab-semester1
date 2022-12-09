//
//  SceneDelegate.swift
//  NotesProject
//
//  Created by Полина Рыфтина on 27.11.2022.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        guard let scene = (scene as? UIWindowScene) else { return }
        
        let window = UIWindow(windowScene: scene)
        let mainVC = MainViewController()
        
        let navVC = UINavigationController(rootViewController: mainVC)
        navVC.navigationBar.prefersLargeTitles = true
        navVC.navigationBar.shadowImage = UIImage(named: "")
        navVC.navigationBar.setBackgroundImage(UIImage(), for: UIBarMetrics.default)
        navVC.navigationBar.shadowImage = UIImage()
        
        window.rootViewController = navVC
        self.window = window
        window.makeKeyAndVisible()
    }
}

