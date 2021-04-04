//
//  ContentView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct MainTabView: View {
    @ObservedObject var domainListViewModel: DomainsViewModel
    @ObservedObject var actionsViewModel: ActionsViewModel
    var servicesClient: ServicesClient
    @State private var isShowing = false
    
    init(domainListViewModel: DomainsViewModel, actionsViewModel: ActionsViewModel, servicesClient: ServicesClient) {
        self.domainListViewModel = domainListViewModel
        self.actionsViewModel = actionsViewModel
        self.servicesClient = servicesClient
    }
    
    var body: some View {
        TabView {
            ServiceView(servicesClient: self.servicesClient)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Services")
                }
            DomainsView(domainListViewModel: self.domainListViewModel)
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Domains")
                }
                
            ActionsView(actionsViewModel: self.actionsViewModel)
                .tabItem {
                    Image(systemName: "bookmark.circle.fill")
                    Text("Actions")
                }
        }
    }
}
