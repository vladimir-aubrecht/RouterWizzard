//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct UploadOvpnProfileView: View {
    @State private var isShowingOvpnPicker = false
    @ObservedObject var actionsViewModel: ActionsViewModel
    @State private var username = ""
    @State private var password = ""

    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $username).padding().autocapitalization(.none)
            SecureField("Password", text: $password).padding()
            
            if (username.count > 0 && password.count > 0)
            {
                Button("Pick ovpn file") {
                    isShowingOvpnPicker = true
                }.sheet(isPresented: $isShowingOvpnPicker) {
                    OvpnDocumentPickerView(onPick: self.sendData)
                }
            }
        }
    }
    
    private func sendData(content : String)
    {
        self.actionsViewModel.uploadOvpnProfile(profile: content, username: self.username, password: self.password)
    }
}
