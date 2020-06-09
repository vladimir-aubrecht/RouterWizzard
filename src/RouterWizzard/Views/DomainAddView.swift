//
//  ContentView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct DomainAddView: View {
    let onSave: (String) -> Void
    @State private var domain: String = ""
    @Environment(\.presentationMode) private var presentationMode: Binding<PresentationMode>;
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("Domain").bold()
            TextField("Enter domain", text: $domain)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .autocapitalization(.none)
            .keyboardType(.URL)
            Spacer()  
        }.padding()
        .navigationBarTitle(Text("Add domain"), displayMode: .inline)
        .navigationBarItems(
            trailing:
                Button("Save"){
                    self.onSave(self.domain)
                    self.presentationMode.wrappedValue.dismiss()
                }
        )
    }
}
