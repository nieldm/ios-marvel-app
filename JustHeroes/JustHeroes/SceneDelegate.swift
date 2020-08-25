//
//  SceneDelegate.swift
//  JustHeroes
//
//  Created by Daniel Mendez on 8/18/20.
//  Copyright © 2020 Daniel Mendez. All rights reserved.
//

import UIKit
import SwiftUI

enum EnviromentOption: String {
    case startView = "START_VIEW"
    case marvelAPIkey = "MARVEL_API_KEY"
    case marvelAPIprivateKey = "MARVEL_PRIVATE_KEY"
    case mockServer = "MOCK_SERVER"
}

extension ProcessInfo {
    
    func getEnviromentOption(_ option: EnviromentOption) -> String? {
        return environment[option.rawValue]
    }
    
    func getStartView() -> StartView {
        let startView = getEnviromentOption(.startView) ?? ""
        return StartView(rawValue: startView) ?? StartView.none
    }
    
    func mockServer() -> Bool {
        getEnviromentOption(.mockServer) == "YES"
    }
}

enum StartView: String {
    case test
    case characterList
    case sortFilter
    case comics
    case none = ""
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        UINavigationBar.appearance().tintColor = .secondary
        
        let firstView: UIViewController = Assembler.shared.resolveStartViewController()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = firstView
            self.window = window
            window.makeKeyAndVisible()
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {}

    func sceneDidBecomeActive(_ scene: UIScene) {}

    func sceneWillResignActive(_ scene: UIScene) {}

    func sceneWillEnterForeground(_ scene: UIScene) {}

    func sceneDidEnterBackground(_ scene: UIScene) {}


}

