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
    @State var showSheetView = false
    
    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        List {
            ForEach(self.getVpnInterfaces(), id: \.name) { vpnInterface in
                HStack {
                    Rectangle().fill(vpnInterface.disable! ? Color.red : Color.green).frame(width: 10)
                    VStack(alignment: .leading) {
                    Text(vpnInterface.name!)
                    Text(vpnInterface.configfile).font(.system(size: 10))
                    }
                }
           }
            .onDelete(perform: delete)
        }
        .navigationBarTitle(Text("VPN interfaces"))
        .navigationBarItems(
            trailing:Button(action: {
                self.showSheetView.toggle()
            }) {
                  Text("Add")
            }
        )
        .sheet(isPresented: $showSheetView) {
            AddVpnInterfaceView(actionsViewModel: self.actionsViewModel, showSheetView: self.$showSheetView)
        }
    }
    
    private func getVpnInterfaces() -> [OpenVpnInterfaceModel]
    {
        var models = self.actionsViewModel.fetchVpnInterfaces()
        models.sort { $0.name! < $1.name! }
        
        return models
    }
    
    private func delete(at offsets: IndexSet) {
        let interfaces = self.getVpnInterfaces()
        offsets.forEach { index in
            let interface = interfaces[index]
            self.actionsViewModel.deleteVpnInterface(interface: interface)
        }
    }
}
