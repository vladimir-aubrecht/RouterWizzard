//
//  SshError.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

enum SshError : Error {
    case cannotConnect(String)
    case cannotAuthenticate(String)
    case cannotExecute(String)
}
