//
//  NoRouterProvider.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 20.06.2021.
//

import Foundation

class EmptyRouterProvider : RouterProvider {
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
    
    public func fetchLocalInterfaces() -> [String: InterfaceModel] {
        return [String: InterfaceModel]()
    }
    
    public func fetchVpnInterfaces() -> [String: InterfacesOpenVpnModel] {
        return [String: InterfacesOpenVpnModel]()
    }
    
    public func fetchTableIndexByInterface(interfaceName: String) -> Int {
        return 0
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

    public func addDnsIpSetForwarding(domains: [String], serviceName: String) {
    }
    
    public func addDnsServerForwarding(domains: [String], dnsServerIp: String) {
    }
    
    public func addFirewallRule(description: String, tableIndex: Int, ruleIndex: Int) {
    }
    
    public func addFirewallAddressGroupRule(addressGroup: String, description: String, tableIndex: Int, ruleIndex: Int) {
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
    
    public func deleteFirewallRule(ruleIndex: Int) {
    }
    
    public func deleteDnsIpSetForwarding(serviceName: String) {
    }
    
    public func deleteDnsServerForwarding(domains: [String], dnsServerIp: String) {
    }
}
