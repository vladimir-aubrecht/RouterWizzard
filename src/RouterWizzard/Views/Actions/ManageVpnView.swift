//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ManageVpnView: View {
    @ObservedObject var actionsViewModel: ActionsViewModel
    @State private var isShowing = false
    
    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        List {
            ForEach(self.actionsViewModel.fetchVpnInterfaces(), id: \.self) { vpnInterface in
                Text(vpnInterface)
           }
            .onDelete(perform: delete)
        }
        .navigationBarTitle(Text("VPN interfaces"))
        .navigationBarItems(
            trailing:
                NavigationLink(destination: Text("not done yet")) {
                Text("Add")
            }
        )
        .pullToRefresh(isShowing: $isShowing) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.isShowing = false
                //self.domainListViewModel.refreshDomains()
            }
        }
    }
    
    private func getVpnInterfaces() -> [String]
    {
        var models = self.actionsViewModel.fetchVpnInterfaces()
        models.sort { $0 < $1 }
        
        return models
    }
    
    private func delete(at offsets: IndexSet) {
        let interfaces = self.getVpnInterfaces()
        offsets.forEach { index in
            let interface = interfaces[index]
            self.actionsViewModel.deleteVpnInterface()
        }
    }
}
