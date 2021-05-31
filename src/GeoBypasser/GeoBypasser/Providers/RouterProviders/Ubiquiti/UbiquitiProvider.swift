//
//  UbiquitiProvider.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

class UbiquitiProvider {
    public func fetchFirewallStatus(serviceName:String) -> RouterStatusModel {
        
        // Location is in description of firewall rule and status is based on status of firewall rule.
        return RouterStatusModel(status: "InActive", location: "UK")
    }
    
    public func fetchDefaultGateway() -> String {
        return "0.0.0.0";
    }
    
    public func fetchStaticRoutesTables() -> [Int] {
        return [Int]()
    }
    
    public func fetchLocalInterfaces() -> [InterfaceModel] {
        return [InterfaceModel]()
    }
    
    public func fetchVpnInterfaces() -> [VpnInterfaceModel] {
        return [VpnInterfaceModel]()
    }
    
    public func fetchTableIndexByInterface(interfaceName: String) -> Int {
        
    }
    
    public func fetchStaticRoutes(tableIndex:Int) -> [StaticRouteModel] {
        return [StaticRouteModel]()
    }
    
    public func fetchStaticInterfaceRoutes(tableIndex:Int) -> [StaticInterfaceRouteModel] {
        return [StaticInterfaceRouteModel]()
    }
    
    public func fetchVpnConnection(vpnInterface:String) -> VpnConnection {
        return VpnConnection(dnsServerIp: "0.0.0.0", gatewayIp: "0.0.0.0")
    }
    
    public func fetchDhcpConfiguration() -> DhcpConfiguration {
        return DhcpConfiguration(defaultRouter: "0.0.0.0")
    }
    
    public func setVpnRuleOnPort(port:String, vpnRule:String) {
    }
    
    public func addVpnInterface(vpnProfileFilename: String) {

    }
    
    public func addFirewallRule(addressGroup: String, description: String, tableIndex: Int) {
    }
    
    public func addNAT(vpnInterfaceName: String) {
    }
    
    public func addStaticRoutingRecord(destinationIp: String, gatewayIp: String) {
    }
    
    public func addStaticDefaultGateway(tableIndex: Int, ip: String) {
        
    }
    
    public func addStaticDefaultGatewayByInterface(tableIndex: Int, vpnInterfaceName: String) {
        
    }
    
    public func deleteAllStaticRoutingRecords() {
        
    }
}
