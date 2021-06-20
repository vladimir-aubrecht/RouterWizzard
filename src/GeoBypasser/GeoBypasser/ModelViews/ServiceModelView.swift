//
//  ServiceModelView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import Foundation

class ServiceModelView : ObservableObject {
    private var servicesProvider = ServicesProvider()
    private var routerProvider : UbiquitiProvider
    @Published private var services:[ServiceModel] = [ServiceModel]()
    
    init(hostname: String, username: String, password: String) {
        routerProvider = UbiquitiProvider(hostname: hostname, username: username, password: password)
        
        servicesProvider.fetchServices(onResponse: addService)
    }
    
    public func getServices() -> [ServiceModel] {
        return self.services
    }
    
    private func addService(serviceProviderModel: ServiceProviderModel) {
        
        let routerModel = self.routerProvider.fetchFirewallStatus(serviceName: serviceProviderModel.name)
        
        DispatchQueue.main.async {
            self.services.append(ServiceModel(name: serviceProviderModel.name, image: serviceProviderModel.image, domains: serviceProviderModel.domains, location: routerModel.location, status: routerModel.status))
        }
    }
}
