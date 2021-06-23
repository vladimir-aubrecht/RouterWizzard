//
//  FirewallModel.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 23.06.2021.
//

public struct FirewallModel : Decodable {
    public var allPing: String
    //public var broadcastPing: Bool
    //public var group: GroupModel
    //public var ipv6Name: [IpV6NameModel]
    
    enum CodingKeys: String, CodingKey {
            case allPing = "all-ping"
        }
}
