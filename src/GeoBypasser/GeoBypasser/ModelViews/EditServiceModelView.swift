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
        setDnsRedirectsStaticRoutes()
        setDefaultGatewayForEachInterface()
        enableFirewallOnLocalPort()
    }
    
    private func redirectServiceThroughLocation(serviceName: String, location: String) {
        let vpnInterface = routerProvider.fetchVpnInterfaces().filter { $0.description == location }[0]
        let tableIndex = routerProvider.fetchTableIndexByInterface(interfaceName: vpnInterface.name)
        routerProvider.addFirewallRule(addressGroup: serviceName, description: serviceName, tableIndex: tableIndex)
    }
    
    private func enableFirewallOnLocalPort() {
        let dhcpConfiguration = routerProvider.fetchDhcpConfiguration()
        let localInterface = routerProvider.fetchLocalInterfaces().filter { $0.ip == dhcpConfiguration.defaultRouter }[0]
        
        routerProvider.setVpnRuleOnPort(port: localInterface.name, vpnRule: "GeoBypasser")
    }
    
    private func setDnsRedirectsStaticRoutes() {
        routerProvider.fetchVpnInterfaces().forEach { vpnInterface in
            let connectionInfo = routerProvider.fetchVpnConnection(vpnInterface: vpnInterface.name)
            routerProvider.addStaticRoutingRecord(destinationIp: connectionInfo.dnsServerIp, gatewayIp: connectionInfo.gatewayIp)
        }
    }
    
    private func setDefaultGatewayForEachInterface() {
        let defaultGateway = routerProvider.fetchDefaultGateway()
        let vpnInterfaces = routerProvider.fetchVpnInterfaces()
        
        routerProvider.deleteAllStaticRoutingRecords()
        routerProvider.addStaticDefaultGateway(tableIndex: 0, ip: defaultGateway)
        for i in 0...vpnInterfaces.count - 1 {
            routerProvider.addStaticDefaultGatewayByInterface(tableIndex: i + 1, vpnInterfaceName: vpnInterfaces[i].name)
        }
    }
}
