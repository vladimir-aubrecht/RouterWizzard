//
//  ServiceView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ServiceView: View {
    
    @ObservedObject var servicesViewModel: ServicesViewModel
    
    init(servicesViewModel: ServicesViewModel) {
        self.servicesViewModel = servicesViewModel
        self.servicesViewModel.fetchServices()
    }
    
    var body: some View {
        VStack {
            let services = self.servicesViewModel.services
            
            if services.isEmpty {
                Text("Loading...")
            }
            else {
                NavigationView {
                    List {
                        ForEach(Array(services), id: \.key) { service in
                            NavigationLink(destination: ServiceUpdateView(serviceModel: service.value)) {
                                
                                if service.value.image != nil {
                                    HStack(alignment: .top) {
                                        Image(uiImage: service.value.image!).resizable().aspectRatio(contentMode: .fit).scaledToFit().frame(maxWidth: 150, maxHeight: 150)
                                        VStack(alignment: .leading) {
                                            Text("Location: UK").padding(3)
                                            Text("Status: Inactive").padding(3)
                                        }
                                    }
                                }
                                else {
                                    Text(service.value.serviceName)
                                }
                            }
                       }
                    }
                }
            }
        }
    }
}
