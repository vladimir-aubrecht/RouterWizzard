//
//  ContentView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI
import SwiftUIRefresh

struct DomainListView: View {
    @ObservedObject var domainListViewModel: DomainsListViewModel
    @ObservedObject var actionsViewModel: UploadOvpnProfileView.ActionsViewModel
    @State private var isShowing = false
    
    init(domainListViewModel: DomainsListViewModel, actionsViewModel: UploadOvpnProfileView.ActionsViewModel) {
        self.domainListViewModel = domainListViewModel
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        TabView {
            VStack {
                NavigationView {
                    List {
                        ForEach(self.getDomainModels(), id: \.domain) { domainModel in
                            DomainView(domainModel: domainModel)
                       }
                        .onDelete(perform: delete)
                    }
                    .navigationBarTitle(Text("Domains"))
                    .navigationBarItems(
                        trailing:
                        NavigationLink(destination: DomainAddView(onSave: self.domainListViewModel.addDomain)) {
                            Text("Add")
                        }
                    )
                    .pullToRefresh(isShowing: $isShowing) {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                            self.isShowing = false
                            self.domainListViewModel.refreshDomains()
                        }
                    }
                }
            }
            .tabItem {
                Image(systemName: "house.fill")
                Text("Domains")
            }
                
            VStack {
                NavigationView {
                    List {
                        NavigationLink(destination: UploadOvpnProfileView(actionsViewModel: self.actionsViewModel)) {
                            Text("Upload ovpn profile")
                        }
                    }
                    .navigationBarTitle(Text("Actions"))
                }
            }
            .tabItem {
                Image(systemName: "bookmark.circle.fill")
                Text("Actions")
            }
        }
    }
    
    private func getDomainModels() -> [DomainModel]
    {
        var models = domainListViewModel.domainModels.values.map { $0 }
        models.sort { $0.domain < $1.domain }
        
        return models
    }
    
    private func delete(at offsets: IndexSet) {
        let models = self.getDomainModels()
        offsets.forEach { index in
            let domainModel = models[index]
            self.domainListViewModel.removeDomain(domain: domainModel.domain)
        }
    }
}
