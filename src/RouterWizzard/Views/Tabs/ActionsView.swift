//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ActionsView: View {
    
    @ObservedObject var actionsViewModel: ActionsViewModel
    
    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        VStack {
            NavigationView {
                List {
                    NavigationLink(destination: UploadOvpnView(actionsViewModel: self.actionsViewModel)) {
                        Text("Upload ovpn profile")
                    }
                    NavigationLink(destination: ManageVpnView(actionsViewModel: self.actionsViewModel)) {
                        Text("Manage VPNs")
                    }
                }
                .navigationBarTitle(Text("Actions"))
            }
        }
    }
}
