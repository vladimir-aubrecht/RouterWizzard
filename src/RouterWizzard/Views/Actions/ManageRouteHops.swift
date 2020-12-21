//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ManageRouteHops: View {
    @ObservedObject var actionsViewModel: ActionsViewModel
    @State private var isShowing = false
    @State var showSheetView = false
    
    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        List {
            ForEach(self.getHopeTables(), id: \.name) { hopTable in
                HStack {
                    Text(hopTable.name).font(.system(size: 26)).fontWeight(.bold).foregroundColor(.blue)
                    Text(hopTable.outgoingInterface)
                }
           }
            .onDelete(perform: delete)
        }
        .navigationBarTitle(Text("Hop tables"))
        .navigationBarItems(
            trailing:Button(action: {
                self.showSheetView.toggle()
            }) {
                  Text("Add")
            }
        )
        .sheet(isPresented: $showSheetView) {
            AddHopTable(actionsViewModel: self.actionsViewModel, showSheetView: self.$showSheetView)
        }
    }
    
    private func getHopeTables() -> [HopTableModel]
    {
        var models = self.actionsViewModel.fetchRouteHops()
        models.sort { $0.name < $1.name }
        
        return models
    }
    
    private func delete(at offsets: IndexSet) {
        let interfaces = self.getHopeTables()
        offsets.forEach { index in
            //let interface = interfaces[index]
            //self.actionsViewModel.deleteVpnInterface(interface: interface)
        }
    }
}
