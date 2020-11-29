//
//  OpenVpnInterfaceModel.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public struct OpenVpnInterfaceModel : Decodable {
    public var description: String
    public var configfile: String
    public var disable: Bool? = false
    public var name: String?
}
