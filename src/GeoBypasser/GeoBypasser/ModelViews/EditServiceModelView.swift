//
//  EditServiceModelView.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import Foundation

class EditServiceModelView {
    private var routerProvider = UbiquitiProvider()
    
    public func Activate(serviceModel: ServiceModel) {
        setDnsRedirectsStaticRoutes()
        setDefaultGatewayForEachInterface()
        enableFirewallOnLocalPort()
        redirectServiceThroughLocation(serviceModel: serviceModel)
        redirectRestOfTraffic()
        addDomainForwarding(serviceModel: serviceModel)
    }
    
    private func addDomainForwarding(serviceModel: ServiceModel) {
        let vpnInterface = routerProvider.fetchVpnInterfaces().filter { $0.description == serviceModel.location }[0]
        let connectionInfo = routerProvider.fetchVpnConnection(vpnInterface: vpnInterface.name)
        
        routerProvider.deleteDnsIpSetForwarding(serviceName: serviceModel.name)
        routerProvider.deleteDnsServerForwarding(domains: serviceModel.domains, dnsServerIp: connectionInfo.dnsServerIp)
        routerProvider.addDnsIpSetForwarding(domains: serviceModel.domains, serviceName: serviceModel.name)
        routerProvider.addDnsServerForwarding(domains: serviceModel.domains, dnsServerIp: connectionInfo.dnsServerIp)
    }
    
    private func redirectRestOfTraffic() {
        let vpnInterfacesCount = routerProvider.fetchVpnInterfaces().count
        let ruleIndex = vpnInterfacesCount * 10
        routerProvider.deleteFirewallRule(ruleIndex: ruleIndex)
        routerProvider.addFirewallRule(description: "Rest of traffic", tableIndex: 0, ruleIndex: ruleIndex)
    }
    
    private func redirectServiceThroughLocation(serviceModel: ServiceModel) {
        let vpnInterface = routerProvider.fetchVpnInterfaces().filter { $0.description == serviceModel.location }[0]
        let tableIndex = routerProvider.fetchTableIndexByInterface(interfaceName: vpnInterface.name)
        let ruleIndex = tableIndex * 10
        routerProvider.deleteFirewallRule(ruleIndex: ruleIndex)
        routerProvider.addFirewallAddressGroupRule(addressGroup: serviceModel.name, description: serviceModel.name, tableIndex: tableIndex, ruleIndex: ruleIndex)
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