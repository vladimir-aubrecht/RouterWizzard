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
                let routerProvider = UbiquitiProvider(hostname: settingsModel.hostname!, username: settingsModel.username!, password: settingsModel.password!)
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
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
