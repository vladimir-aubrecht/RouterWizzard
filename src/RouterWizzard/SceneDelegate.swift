//
//  SceneDelegate.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    var ubiquitiDomainFlowClient: UbiquitiDomainFlowClient?
    var sshClient: SshClient?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
    }
    
    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
        
        let userDefaults = UserDefaults.standard
        let hostname = userDefaults.string(forKey: "hostname_preference")
        let username = userDefaults.string(forKey: "username_preference")
        let password = userDefaults.string(forKey: "password_preference")
        
        if (hostname != nil && username != nil && password != nil) {
            self.InitView(scene, hostname: hostname!, username: username!, password: password!)
        }
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
        
        self.sshClient?.disconnect()
    }

    private func InitView(_ scene: UIScene, hostname: String, username: String, password: String)
    {
        self.sshClient = SshClient(hostname: hostname, username: username)
        
        do {
            try self.sshClient!.connect()
            try self.sshClient!.authenticate(password: password)
            
            let ubiquitiClient = UbiquitiClient(sshClient: sshClient!)
            let ubiquitiDomainFlowClient = UbiquitiDomainFlowClient(ubiquitiClient: ubiquitiClient)
            
            let domainListViewModel = DomainListView.DomainsListViewModel(domainFlowClient: ubiquitiDomainFlowClient)
            let domainListView = DomainListView(domainListViewModel: domainListViewModel)
            
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: domainListView)
                self.window = window
                window.makeKeyAndVisible()
            }
            
        } catch {
            if let windowScene = scene as? UIWindowScene {
                let window = UIWindow(windowScene: windowScene)
                window.rootViewController = UIHostingController(rootView: FirstStartupView())
                self.window = window
                window.makeKeyAndVisible()
            }
        }
        
        

    }
}