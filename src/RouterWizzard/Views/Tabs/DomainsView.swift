//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct DomainsView: View {
    @ObservedObject var domainListViewModel: DomainsViewModel
    @State private var isShowing = false
    
    init(domainListViewModel: DomainsViewModel) {
        self.domainListViewModel = domainListViewModel
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    ForEach(self.getDomainModels(), id: \.domain) { domainModel in
                        DomainRowView(domainModel: domainModel)
                   }
                    .onDelete(perform: delete)
                }
                .navigationBarTitle(Text("Domains"))
                .navigationBarItems(
                    trailing:
                    NavigationLink(destination: AddDomainView(onSave: self.domainListViewModel.addDomain)) {
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
