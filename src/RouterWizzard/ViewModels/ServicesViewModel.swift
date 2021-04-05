//
//  ServicesViewModel.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 05.04.2021.
//  Copyright © 2021 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public class ServicesViewModel : ObservableObject {
    @Published private(set) var services: [String: ServiceModel] = [String: ServiceModel]()
    
    private let servicesClient : ServicesClient
    
    init(servicesClient: ServicesClient) {
        self.servicesClient = servicesClient
    }
    
    public func fetchServices() {
        self.servicesClient.fetchServices(onResponse: self.onServiceFetchResponse)
    }
    
    private func onServiceFetchResponse(service : ServiceModel) {
        DispatchQueue.main.async {
            self.services.updateValue(service, forKey: service.serviceName)
        }
    }
}
