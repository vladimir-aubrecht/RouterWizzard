//
//  DomainsViewModel.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation
import FavIcon
import UIKit

extension DomainListView {
    class DomainsListViewModel : ObservableObject {
        @Published private(set) var domainModels: [String: DomainModel] = [String: DomainModel]()
        
        private let domainFlowClient: UbiquitiDomainFlowClient
        
        init(domainFlowClient: UbiquitiDomainFlowClient) {
            self.domainFlowClient = domainFlowClient
            self.refreshDomains()
        }
        
        func refreshDomains() {
            let domains = (try? self.domainFlowClient.fetchDomains()) ?? [String]()
            self.domainModels = [String: DomainModel]()
            let defaultImage = UIImage(named: "UnknownDomain")!
            
            domains.forEach { domain in
                let domainModel = DomainModel(domain: domain, image: defaultImage)
                
                _ = try! FavIcon.downloadPreferred("https://\(domain)") { result in
                    if case let .success(image) = result {
                        self.domainModels[domain] = DomainModel(domain: domain, image: image)
                    }
                }
                
                self.domainModels.updateValue(domainModel, forKey: domainModel.domain)
            }
            
        }
        
        func addDomain(domain: String) {
            try! self.domainFlowClient.addDomain(domain: domain)
        }
        
        func removeDomain(domain: String) {
            try! self.domainFlowClient.deleteDomain(domain: domain)
        }
    }
}
