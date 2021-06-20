//
//  ContentView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        TabView {
            let userDefaults = UserDefaults.standard
            let hostname = userDefaults.string(forKey: "hostname_preference")
            let username = userDefaults.string(forKey: "username_preference")
            let password = userDefaults.string(forKey: "password_preference")
            
            if (hostname != nil && username != nil && password != nil) {
                ServiceView(serviceModelView: ServiceModelView(hostname: hostname!, username: username!, password: password!))
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
