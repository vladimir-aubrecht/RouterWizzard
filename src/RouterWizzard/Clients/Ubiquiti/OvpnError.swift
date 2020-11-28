//
//  UbiquitiError.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 28.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

enum OvpnError : Error {
    case cannotParseHostname(String)
    case cannotParseRemote(String)
}
