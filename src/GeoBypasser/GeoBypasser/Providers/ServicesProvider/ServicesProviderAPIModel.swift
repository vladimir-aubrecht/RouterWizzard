//
//  Service.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 30.05.2021.
//

import Foundation

public struct ServicesProviderAPIModel : Decodable {
    public var name: String
    public var iconUrl: String
    public var domains: [String]
    
    private enum CodingKeys : String, CodingKey {
      case name = "ServiceName"
      case iconUrl = "IconUrl"
      case domains = "Domains"
   }
}
