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
}
