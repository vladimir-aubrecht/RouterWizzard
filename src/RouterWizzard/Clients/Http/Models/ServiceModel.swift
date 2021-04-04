//
//  OpenVpnInterfaceModel.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public struct ServiceModel : Decodable {
    public var serviceName: String
    public var iconUrl: String
    public var domains: [String]
    
    private enum CodingKeys : String, CodingKey {
      case serviceName = "ServiceName"
      case iconUrl = "IconUrl"
      case domains = "Domains"
   }
}
