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
    var domainListViewModel: DomainsViewModel
    var actionsViewModel: ActionsViewModel
    var servicesViewModel: ServicesViewModel
    
    @State private var isShowing = false
    
    init(domainListViewModel: DomainsViewModel, actionsViewModel: ActionsViewModel, servicesViewModel: ServicesViewModel) {
        self.domainListViewModel = domainListViewModel
        self.actionsViewModel = actionsViewModel
        self.servicesViewModel = servicesViewModel
    }
    
    var body: some View {
        TabView {
            ServiceView(servicesViewModel: self.servicesViewModel)
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
