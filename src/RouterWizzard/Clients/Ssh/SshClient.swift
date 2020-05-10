//
//  Ssh.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

class SshClient {
    private let session: NMSSHSession
    private let hostname: String
    private let username: String
    
    public var isConnected: Bool {
        get { return self.session.isConnected }
    }
    
    public var isAuthorized: Bool {
        get { return self.session.isAuthorized }
    }
    
    init(hostname: String, username: String) {
        self.hostname = hostname
        self.username = username
        self.session = NMSSHSession(host: hostname, andUsername: username)
    }
    
    public func connect() throws {
        self.session.connect()
        
        if (!self.isConnected) {
            throw SshError.cannotConnect("Cannot connect to: \(self.hostname)")
        }
    }
    
    public func disconnect() {
        self.session.disconnect()
    }
    
    public func authenticate(password: String) throws {
        self.session.authenticate(byPassword: password)
        
        if (!self.isAuthorized) {
            throw SshError.cannotAuthenticate("Cannot authenticate as: \(self.username)")
        }
    }
    
    public func execute(command: String) throws -> String {
        var error : NSError?;
        let result = self.session.channel.execute(command, error: &error)
        
        if (error != nil)
        {
            throw SshError.cannotExecute(error!.description)
        }
        
        return result
    }
        
}
