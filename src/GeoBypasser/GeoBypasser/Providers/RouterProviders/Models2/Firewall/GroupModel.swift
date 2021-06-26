//
//  GroupModel.swift
//  GeoBypasser
//
//  Created by Vladimir Aubrecht on 23.06.2021.
//

public struct GroupModel : Decodable {
    public var addressGroup : [String: AddressGroupModel]
    
    enum CodingKeys: String, CodingKey {
            case addressGroup = "address-group"
        }
}
