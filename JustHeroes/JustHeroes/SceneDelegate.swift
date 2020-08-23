//
//  SceneDelegate.swift
//  JustHeroes
//
//  Created by Daniel Mendez on 8/18/20.
//  Copyright © 2020 Daniel Mendez. All rights reserved.
//

import UIKit
import SwiftUI

enum StartView: String {
    case test
    case characterList
    case sortFilter
    case none = ""
}

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let startViewOption = ProcessInfo.processInfo.environment["START_VIEW"] ?? ""
        
        let firstView: UIViewController
        switch StartView(rawValue: startViewOption) {
        case .test:
            firstView = Assembler.shared.resolveCardListViewController_Test()
        case .sortFilter:
            firstView = Assembler.shared.resolveSortFilterModule()
        case .characterList:
            firstView = try! Assembler.shared.resolveCharacterList()
        default:
            let navController = UINavigationController(
                rootViewController: try! Assembler.shared.resolveCharacterList()
            )
            navController.navigationBar.tintColor = .secondary
            firstView = navController
        }

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

