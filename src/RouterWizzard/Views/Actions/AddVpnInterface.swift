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
    @ObservedObject var actionsViewModel: ActionsViewModel
    
    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        Form {
            Section {
                Picker(selection: $selectedFrameworkIndex, label: Text("Config file")) {
                    let profiles = self.actionsViewModel.fetchOvpnProfiles()
                    ForEach(0 ..< profiles.count) {
                        Text(profiles[$0]).font(.system(size: 10))
                    }
                }
            }
        }
        .navigationBarItems(
            trailing:
                NavigationLink(destination: Text("Not implemented yet!")) {
                Text("Add")
            }
        )
    }
}
