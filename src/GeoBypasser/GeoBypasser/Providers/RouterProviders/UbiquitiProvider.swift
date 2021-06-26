//
//  UbiquitiProvider.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import Logging

class UbiquitiProvider : RouterProvider {
    private let ubiquitiClient : UbiquitiClientProtocol
    private let logger : Logger
    private let ubiquitiDeserializer : UbiquitiDeserializer
    
    public init(ubiquitiClient: UbiquitiClientProtocol, logger: Logger) {
        self.ubiquitiClient = ubiquitiClient
        self.logger = logger
        self.ubiquitiDeserializer = UbiquitiDeserializer(logger: logger)
    }
    
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
        self.logger.info("fetchLocalInterfaces called.")
        let result = try! ubiquitiClient.show(key: "interfaces ethernet")
        self.logger.info("\(result)")
        
        let output = [String: InterfaceModel]() // = try! ubiquitiDeserializer.deserialize(content: result)
        
        return output
    }
    
    public func fetchVpnInterfaces() -> [String: InterfacesOpenVpnModel] {
        self.logger.info("FetchVpnInterfaces called.")
        self.fetchConfiguration()
        let result = try! ubiquitiClient.show(key: "interfaces openvpn")
        self.logger.info("\(result)")
        
        let output = [String: InterfacesOpenVpnModel]() // = try! ubiquitiDeserializer.deserialize(content: result)
        
        return output
    }
    
    public func fetchConfiguration() -> RootModel {
        self.logger.info("fetchConfiguration called.")
        let result = try! ubiquitiClient.show(key: "")
        self.logger.info("\(result)")
        
        let output: RootModel = try! ubiquitiDeserializer.deserialize(content: result)
        
        return output
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
