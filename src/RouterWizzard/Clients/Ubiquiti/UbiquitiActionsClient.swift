//
//  DomainFlowClient.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public class UbiquitiActionsClient {
    private let fileSystemClient: FileSystemClient
    private let ubiquitiClient: UbiquitiClient
    private let ubiquitiDeserializer: UbiquitiDeserializer
    
    private let filenamePrefix: String = "router_wizzard_"
    private let vpnConfigPath: String = "/config/auth/";
    
    init(ubiquitiClient: UbiquitiClient, fileSystemClient: FileSystemClient, ubiquitiDeserializer: UbiquitiDeserializer) {
        self.fileSystemClient = fileSystemClient
        self.ubiquitiClient = ubiquitiClient
        self.ubiquitiDeserializer = ubiquitiDeserializer
    }
    
    public func fetchVpnInterfaces() -> [OpenVpnInterfaceModel] {
        let result = try! self.ubiquitiClient.show(key: "interfaces openvpn")
        let deserializedInterfaces: [String: OpenVpnInterfaceModel] = try! self.ubiquitiDeserializer.deserialize(content: result)
        
        var interfaces = [OpenVpnInterfaceModel]()
        deserializedInterfaces.forEach { interface in
            var modifiedValue = interface.value
            modifiedValue.name = interface.key
            modifiedValue.disable = modifiedValue.disable == nil ? false : modifiedValue.disable
            interfaces.append(modifiedValue)
        }
        
        for i in 0...interfaces.count - 1 {
            interfaces[i].configfile = interfaces[i].configfile.replacingOccurrences(of: vpnConfigPath, with: "")
        }
        
        return interfaces
    }
    
    public func deleteVpnInterface(interface: OpenVpnInterfaceModel) {
        let name = interface.name!
        try! self.ubiquitiClient.beginSession()
        try! self.ubiquitiClient.delete(key: "interfaces openvpn \(name)")
        try! self.ubiquitiClient.commit()
        try! self.ubiquitiClient.save()
        try! self.ubiquitiClient.endSession()
    }
    
    public func addVpnInterface(vpnProfileFilename: String) {
        var interfaces = self.fetchVpnInterfaces()
        interfaces.sort {$0.name!.localizedStandardCompare($1.name!) == .orderedAscending}

        let lastUsedVtunIndex = Int(interfaces[interfaces.count - 1].name!.replacingOccurrences(of: "vtun", with: ""))
        let newInterfaceIndex = lastUsedVtunIndex! + 1
        
        let profileFullPath = vpnConfigPath + vpnProfileFilename
        let description = vpnProfileFilename.replacingOccurrences(of: ".ovpn", with: "")
        let interfaceName = "vtun" + String(newInterfaceIndex)

        try! self.ubiquitiClient.beginSession()
        try! self.ubiquitiClient.set(key: "interfaces openvpn \(interfaceName) config-file \(profileFullPath)")
        try! self.ubiquitiClient.set(key: "interfaces openvpn \(interfaceName) description \(description)")
        try! self.ubiquitiClient.commit()
        try! self.ubiquitiClient.save()
        try! self.ubiquitiClient.endSession()
    }
    
    public func listOvpnFiles() throws -> [String]{
        let files = try! self.fileSystemClient.listDirectory(path: self.vpnConfigPath + "*.ovpn")

        return files.map { String($0.split(separator: "/").last!) }
    }
    
    public func uploadOvpnFile(content : String, username : String, password : String) throws {
        let hostname = try! parseHostname(content: content)
        let ovpnProfileFilename = filenamePrefix + hostname
        let profileFullPath = vpnConfigPath + ovpnProfileFilename
        let authFullPath = vpnConfigPath + ovpnProfileFilename + ".auth"

        let authContent = username + "\n" + password
        var profileContent = try! replaceHeader(content: content, header: "auth-user-pass", value: authFullPath)
        profileContent = try! replaceHeader(content: profileContent, header: "route-nopull", value: "")
        
        print(profileContent)
        
        try self.fileSystemClient.uploadFile(path: profileFullPath, content: profileContent)
        try self.fileSystemClient.uploadFile(path: authFullPath, content: authContent)
    }
    
    private func replaceHeader(content: String, header: String, value: String) throws -> String {
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        let linesWithoutAuthUserPass = lines.filter { !$0.lowercased().starts(with: header) }.map{String($0)}
        
        var newLines: [String] = [String]()
        for n in 0...linesWithoutAuthUserPass.count - 1 {
            newLines.append(linesWithoutAuthUserPass[n])
            
            if (linesWithoutAuthUserPass[n].lowercased().starts(with: "remote")) {
                newLines.append(header + " " + value)
            }
        }
        
        return newLines.joined(separator: "\n")
    }
    
    private func parseHostname(content: String) throws -> String {
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        let remotes = lines.filter { $0.lowercased().starts(with: "remote") }.map{String($0)}
        
        if (remotes.isEmpty) {
            throw OvpnError.cannotParseRemote("No remote line in ovpn file.")
        }
        
        let parsedRemote = remotes[0].split(separator: " ", omittingEmptySubsequences: true)
        
        if (parsedRemote.count < 2) {
            throw OvpnError.cannotParseHostname("Cannot parse remote hostname in ovpn file.")
        }
        
        return String(parsedRemote[1])
    }
}
