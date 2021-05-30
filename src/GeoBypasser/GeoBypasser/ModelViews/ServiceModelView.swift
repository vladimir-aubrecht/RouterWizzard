//
//  ServiceModelView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import Foundation

class ServiceModelView : ObservableObject {
    private var servicesProvider = ServicesProvider()
    @Published private var services:[ServiceModel] = [ServiceModel]()
    
    init() {
        servicesProvider.fetchServices(onResponse: addService)
    }
    
    public func getServices() -> [ServiceModel] {
        return self.services
    }
    
    private func addService(serviceProviderModel: ServiceProviderModel) {
        DispatchQueue.main.async {
            print("Appending service model.")
            self.services.append(ServiceModel(name: serviceProviderModel.name, image: serviceProviderModel.image, domains: serviceProviderModel.domains, location: "UK", status: "InActive"))
        }
    }
}
