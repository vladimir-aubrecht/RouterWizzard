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
            ServiceView(serviceModelView: ServiceModelView())
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Services")
                }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
