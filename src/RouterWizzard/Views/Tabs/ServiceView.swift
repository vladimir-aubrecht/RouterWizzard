//
//  ServiceView.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 04.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import SwiftUI

struct ServiceView: View {
    
    @ObservedObject var servicesClient: ServicesClient
    
    init(servicesClient: ServicesClient) {
        self.servicesClient = servicesClient
        self.servicesClient.fetchServices()
    }
    
    var body: some View {
        VStack {
            let services = self.servicesClient.serviceCollection
            
            if services == nil {
                Text("Loading...")
            }
            else {
                List {
                    ForEach(services!, id: \.serviceName) { service in
                        Text(service.serviceName)
                   }
                }
            }
        }
    }
}
