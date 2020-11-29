//
//  UbiquitiClient.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

class FileSystemClient {
    private let sshClient: SshClient
    
    init(sshClient: SshClient) {
        self.sshClient = sshClient
    }
    
    public func uploadFile(path: String, content: String) throws {
        _ = try self.sshClient.execute(command: "touch \(path)");
        _ = try self.sshClient.execute(command: "echo \"\(content)\" > \(path)");
    }
    
    public func listDirectory(path: String) throws -> [String] {
        let result = try self.sshClient.execute(command: "ls \(path)")
        let lines = result.split(separator: "\n", omittingEmptySubsequences: true).map(String.init)
        
        return lines
    }
}
