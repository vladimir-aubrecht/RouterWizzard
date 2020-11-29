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
        var result = try! self.ubiquitiClient.show(key: "interfaces openvpn")
        return try! self.ubiquitiDeserializer.deserialize(content: result)
    }
    
    public func addVpnInterface() {
        
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
