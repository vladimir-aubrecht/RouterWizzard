//
//  ContentView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    @ObservedObject var settingsModel = SettingsModel()
    
    var body: some View {
        TabView {
            if (settingsModel.isSet) {
                let routerProvider = self.createRouterProvider()
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
    
    private func createRouterProvider() -> RouterProvider {
        let sshClient = SshClient(hostname: settingsModel.hostname!, username: settingsModel.username!)
        try! sshClient.connect()
        try! sshClient.authenticate(password: settingsModel.password!)
        let ubiquitiClient = UbiquitiClient(sshClient: sshClient)
        
        return UbiquitiProvider(ubiquitiClient: ubiquitiClient)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
