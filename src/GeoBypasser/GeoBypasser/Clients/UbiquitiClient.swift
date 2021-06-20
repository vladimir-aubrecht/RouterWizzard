//
//  UbiquitiClient.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

class UbiquitiClient {
    private let sshClient: SshClient
    
    init(sshClient: SshClient) {
        self.sshClient = sshClient
    }
    
    public func show(key: String) throws -> String {
        return try self.execute(key: "show \(key)")
    }
    
    public func delete(key: String) throws {
        _ = try self.execute(key: "delete \(key)")
    }
    
    public func set(key: String) throws {
        _ = try self.execute(key: "set \(key)")
    }
    
    public func beginSession() throws {
        _ = try self.execute(key: "begin")
    }
    
    public func endSession() throws {
        _ = try self.execute(key: "end")
    }
    
    public func commit() throws {
        _ = try self.execute(key: "commit")
    }
    
    public func save() throws {
        _ = try self.execute(key: "save")
    }
    
    private func execute(key: String) throws -> String{
        let command = "/opt/vyatta/sbin/vyatta-cfg-cmd-wrapper \(key)";
        return try self.sshClient.execute(command: command);
    }
}
