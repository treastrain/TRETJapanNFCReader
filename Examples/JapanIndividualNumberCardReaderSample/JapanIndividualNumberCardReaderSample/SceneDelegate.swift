//
//  SceneDelegate.swift
//  JapanIndividualNumberCardReaderSample
//
//  Created by treastrain on 2021/10/17.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    
    var window: UIWindow?
    
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UINavigationController(rootViewController: ViewController(style: .plain))
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}
