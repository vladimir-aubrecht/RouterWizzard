//
//  EditServiceModelView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import Foundation

class EditServiceModelView {
    private var routerProvider = UbiquitiProvider()
    
    public func Activate() {
        let staticRoutes = routerProvider.fetchStaticRoutes()
        let vpnInterfaces = routerProvider.fetchVpnInterfaces()
        
    }
}
