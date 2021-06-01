//
//  SceneDelegate.swift
//  MapsDirectionsGooglePlacesLBTA
//
//  Created by MIF50 on 31/05/2021.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?


    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
//        let contentView = ContentView()
        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
//            window.rootViewController = UIHostingController(rootView: contentView)
            window.rootViewController = MainVC()
            self.window = window
            window.makeKeyAndVisible()
        }
    }
}

