//
//  ContentView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import SwiftUI
import Logging

struct ContentView: View {
    @ObservedObject var settingsModel = SettingsModel()
    let logger = Logger(label: "com.vladimir-aubrecht.GeoBypasser.main")
    
    var body: some View {
        TabView {
            if (settingsModel.isSet) {
                let routerProvider = (try? self.createRouterProvider()) ?? EmptyRouterProvider()
                
                ServiceView(serviceModelView: ServiceModelView(routerProvider: routerProvider), editServiceModelView: EditServiceModelView(routerProvider: routerProvider))
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("Services")
                    }
            }
            else {
                GoToSettingsView()
            }
        }
    }
    
    private func createRouterProvider() throws -> RouterProvider {
        logger.info("Logging to: \(settingsModel.hostname!) by username: \(settingsModel.username!) with password: \(settingsModel.password!)")
        
        let sshClient = SshClient(hostname: settingsModel.hostname!, username: settingsModel.username!)
        
        try? sshClient.connect()
        try? sshClient.authenticate(password: settingsModel.password!)
        
        let ubiquitiClient : UbiquitiClientProtocol
        if sshClient.isConnected {
            ubiquitiClient = UbiquitiClient(sshClient: sshClient)
        }
        else {
            ubiquitiClient = UbiquitiClientMock()
        }
        
        return UbiquitiProvider(ubiquitiClient: ubiquitiClient, logger: logger)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
