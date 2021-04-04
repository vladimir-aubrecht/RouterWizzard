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

class DomainsViewModel : ObservableObject {
    @Published private(set) var domainModels: [String: DomainModel] = [String: DomainModel]()
    
    private let domainFlowClient: UbiquitiDomainFlowClient
    private let favIconProvider : FavIconProvider
    
    init(domainFlowClient: UbiquitiDomainFlowClient, favIconProvider : FavIconProvider) {
        self.domainFlowClient = domainFlowClient
        self.favIconProvider = favIconProvider
        self.refreshDomains()
    }
    
    func refreshDomains() {
        let domains = (try? self.domainFlowClient.fetchDomains()) ?? [String]()
        self.domainModels = [String: DomainModel]()

        domains.forEach { domain in
            favIconProvider.refreshFavIcon(domain: domain, onRefresh: self.updateDomainModel)
            self.updateDomainModel(domain: domain)
        }
        
    }
    
    func updateDomainModel(domain: String) {
        let domainModel = DomainModel(domain: domain, image: favIconProvider.getFavIcon(domain: domain))
        self.domainModels.updateValue(domainModel, forKey: domainModel.domain)
    }
    
    func addDomain(domain: String) {
        try! self.domainFlowClient.addDomain(domain: domain)
        refreshDomains()
    }
    
    func removeDomain(domain: String) {
        try! self.domainFlowClient.deleteDomain(domain: domain)
        refreshDomains()
    }
}
