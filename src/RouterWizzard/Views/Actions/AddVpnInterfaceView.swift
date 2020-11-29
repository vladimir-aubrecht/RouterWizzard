//
//  AddVpnInterface.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct AddVpnInterfaceView: View {
    @State private var selectedFrameworkIndex = 0
    @Binding private var showSheetView: Bool
    @ObservedObject private var actionsViewModel: ActionsViewModel
    private let vpnProfileFilenames : [String]
    
    init(actionsViewModel: ActionsViewModel, showSheetView: Binding<Bool>) {
        self.actionsViewModel = actionsViewModel
        self._showSheetView = showSheetView
        self.vpnProfileFilenames = actionsViewModel.fetchOvpnProfiles()
    }
    
    var body: some View {
        NavigationView {
            Form {
                Section {
                    Picker(selection: $selectedFrameworkIndex, label: Text("Config file")) {
                        ForEach(0 ..< self.vpnProfileFilenames.count) {
                            Text(self.vpnProfileFilenames[$0]).font(.system(size: 10))
                        }
                    }
                }
            }
            .navigationBarTitle(Text("Add VPN interface"), displayMode: .inline)
            .navigationBarItems(leading: Button(action: { self.showSheetView = false }) { Text("Cancel").bold() },
                                trailing: Button(action: {
                                    let valueToAdd = self.vpnProfileFilenames[self.selectedFrameworkIndex]
                                    self.actionsViewModel.addVpnInterface(vpnProfileFilename: valueToAdd)
                                    self.showSheetView = false
                                }) {
                                    Text("Done").bold()
                                })
        }
    }
}
