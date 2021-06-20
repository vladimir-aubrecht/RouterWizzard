//
//  ServiceView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ServiceView: View {
    @ObservedObject private var serviceModelView:ServiceModelView
    
    init(serviceModelView: ServiceModelView) {
        self.serviceModelView = serviceModelView
    }
    
    var body: some View {
        VStack {
            let services = self.serviceModelView.getServices()

            let userDefaults = UserDefaults.standard
            let hostname = userDefaults.string(forKey: "hostname_preference")
            let username = userDefaults.string(forKey: "username_preference")
            let password = userDefaults.string(forKey: "password_preference")
            
            if (hostname != nil && username != nil && password != nil) {
                if services.isEmpty {
                    Text("Loading...")
                }
                else {
                    NavigationView {
                        List {
                            ForEach(services, id: \.name) { service in
                                NavigationLink(destination: EditServiceView(serviceModel: service, editServiceModelView: EditServiceModelView(hostname: hostname!, username: username!, password: password!))) {
                                    HStack(alignment: .top) {
                                        Image(uiImage: service.image).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(maxWidth: 150, maxHeight: 150)
                                        VStack(alignment: .leading) {
                                            Text("Location: " + service.location).padding(3)
                                            Text("Status: " + service.status).padding(3)
                                        }
                                    }
                                }
                           }
                        }
                    }
                }
            }
            else {
                GoToSettingsView()
            }
        }
    }
}

struct ServiceView_Previews: PreviewProvider {
    static var previews: some View {
        ServiceView(serviceModelView: ServiceModelView(hostname: "", username: "", password: ""))
    }
}
