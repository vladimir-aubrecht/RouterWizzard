//
//  FirewallModel.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 23.06.2021.
//

public struct FirewallModel : Decodable {
    public var allPing: String
    public var broadcastPing: String
    public var group: GroupModel
    public var ipv6Name: [String: IpV6NameModel]
    
    enum CodingKeys: String, CodingKey {
            case allPing = "all-ping"
            case broadcastPing = "broadcast-ping"
            case group = "group"
            case ipv6Name = "ipv6-name"
        }
}
