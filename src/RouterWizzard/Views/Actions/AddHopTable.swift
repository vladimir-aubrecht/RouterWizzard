//
//  AddVpnInterface.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct AddHopTable: View {
    @State private var selectedTableIndex = 0
    @State private var selectedVpnInterfaceIndex = 0
    @Binding private var showSheetView: Bool
    @ObservedObject private var actionsViewModel: ActionsViewModel
    private let availableTables : [Int]
    private let availableVpnInterfaces : [String]
    
    init(actionsViewModel: ActionsViewModel, showSheetView: Binding<Bool>) {
        self.actionsViewModel = actionsViewModel
        self._showSheetView = showSheetView
        
        var tableCandidates = [Int](1...10)
        var vpnInterfacesCandidates = [Int](0...10).map { "vtun" + $0.description }
        
        let occupiedTables = actionsViewModel.fetchRouteHops()
        
        occupiedTables.forEach { table in
            let tableName = Int(table.name)
            let interfaceName = table.outgoingInterface

            tableCandidates = tableCandidates.filter { $0 != tableName }
            vpnInterfacesCandidates = vpnInterfacesCandidates.filter { $0 != interfaceName }
        }
        
        
        self.availableTables = tableCandidates
        self.availableVpnInterfaces = vpnInterfacesCandidates
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $selectedTableIndex, label: Text("Available tables")) {
                        ForEach(0 ..< self.availableTables.count) {
                            Text(self.availableTables[$0].description)
                        }
                    }
                    
                    Picker(selection: $selectedVpnInterfaceIndex, label: Text("Available VPN interfaces")) {
                        ForEach(0 ..< self.availableVpnInterfaces.count) {
                            Text(self.availableVpnInterfaces[$0])
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Add VPN interface"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.showSheetView = false }) { Text("Cancel").bold() },
                                trailing: Button(action: {
                                    let tableToAdd = self.availableTables[self.selectedTableIndex]
                                    let vpnInterfaceToAdd = self.availableVpnInterfaces[self.selectedVpnInterfaceIndex]
                                    self.actionsViewModel.addRouteHop(tableName: tableToAdd, outgoingInterfaceName: vpnInterfaceToAdd)
                                    self.showSheetView = false
                                }) {
                                    Text("Done").bold()
                                })
        }
    }
}
