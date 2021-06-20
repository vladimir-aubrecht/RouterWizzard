//
//  RouterProviderProtocol.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 20.06.2021.
//

import Foundation

protocol RouterProvider {
    func fetchFirewallStatus(serviceName:String) -> RouterStatusModel
    
    func fetchDefaultGateway() -> String
    
    func fetchStaticRoutesTables() -> [Int]
    
    func fetchLocalInterfaces() -> [InterfaceModel]
    
    func fetchVpnInterfaces() -> [String: VpnInterfaceModel]
    
    func fetchTableIndexByInterface(interfaceName: String) -> Int
    
    func fetchStaticRoutes(tableIndex:Int) -> [StaticRouteModel]
    
    func fetchStaticInterfaceRoutes(tableIndex:Int) -> [StaticInterfaceRouteModel]
    
    func fetchVpnConnection(vpnInterface:String) -> VpnConnection
    
    func fetchDhcpConfiguration() -> DhcpConfiguration
    
    func setVpnRuleOnPort(port:String, vpnRule:String)
    
    func addVpnInterface(vpnProfileFilename: String)

    func addDnsIpSetForwarding(domains: [String], serviceName: String)
    
    func addDnsServerForwarding(domains: [String], dnsServerIp: String)
    
    func addFirewallRule(description: String, tableIndex: Int, ruleIndex: Int)
    
    func addFirewallAddressGroupRule(addressGroup: String, description: String, tableIndex: Int, ruleIndex: Int)
    
    func addNAT(vpnInterfaceName: String)
    
    func addStaticRoutingRecord(destinationIp: String, gatewayIp: String)
    
    func addStaticDefaultGateway(tableIndex: Int, ip: String)
    
    func addStaticDefaultGatewayByInterface(tableIndex: Int, vpnInterfaceName: String)
    
    func deleteAllStaticRoutingRecords()
    
    func deleteFirewallRule(ruleIndex: Int)
    
    func deleteDnsIpSetForwarding(serviceName: String)
    
    func deleteDnsServerForwarding(domains: [String], dnsServerIp: String)
}
