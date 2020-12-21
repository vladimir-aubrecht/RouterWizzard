//
//  OpenVpnInterfaceModel.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public struct HopTableModel : Decodable {
    public var outgoingInterface: String
    public var name: String
}
