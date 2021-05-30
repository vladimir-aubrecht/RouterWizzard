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
    
    public func fetchVpnInterfaces() -> [VpnInterfaceModel] {
        return [VpnInterfaceModel]()
    }
    
    public func fetchStaticRoutes() -> [StaticRouteModel] {
        return [StaticRouteModel]()
    }
    
    public func addVpnInterface(vpnProfileFilename: String) {

    }
    
    public func addNAT(vpnInterfaceName: String) {
    }
    
    public func addStaticRoutingRecord(tableIndex: Int, vpnInterfaceName: String) {
        
    }
    
    public func addStaticVpnRoutingRecord(tableIndex: Int, vpnInterfaceName: String) {
        
    }
    
    public func deleteAllStaticRoutingRecords() {
        
    }
}
