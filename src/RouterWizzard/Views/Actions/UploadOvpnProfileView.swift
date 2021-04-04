//
//  StartupScreen.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 10/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct UploadOvpnView: View {
    @State private var isShowingOvpnPicker = false
    @ObservedObject var actionsViewModel: ActionsViewModel
    @State private var username = ""
    @State private var password = ""
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>;

    init(actionsViewModel: ActionsViewModel) {
        self.actionsViewModel = actionsViewModel
    }
    
    var body: some View {
        VStack {
            TextField("Username", text: $username)
                .padding().autocapitalization(.none).textFieldStyle(RoundedBorderTextFieldStyle())
            SecureField("Password", text: $password)
                .padding().textFieldStyle(RoundedBorderTextFieldStyle())
            
            if (username.count > 0 && password.count > 0)
            {
                Button("Pick ovpn file") {
                    isShowingOvpnPicker = true
                }.sheet(isPresented: $isShowingOvpnPicker) {
                    OvpnDocumentPickerView(onPick: self.sendData)
                }.textFieldStyle(RoundedBorderTextFieldStyle())
            }
        }
    }
    
    private func sendData(content : String)
    {
        self.actionsViewModel.uploadOvpnProfile(profile: content, username: self.username, password: self.password)
        self.presentationMode.wrappedValue.dismiss()
    }
}
