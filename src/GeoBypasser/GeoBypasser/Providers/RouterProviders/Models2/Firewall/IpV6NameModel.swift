//
//  IpV6NameModel.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 23.06.2021.
//

public struct IpV6NameModel : Decodable {
    public var defaultAction : String
    public var description : String
    public var enableDefaultLog : Bool
    public var rule : [String: RuleModel]
    
    enum CodingKeys: String, CodingKey {
            case defaultAction = "default-action"
            case description = "description"
            case enableDefaultLog = "enable-default-log"
            case rule = "rule"
        }
}
