//
//  UbiquitiDeserializer.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

class UbiquitiDeserializer
{
    /*private class InternalDecoder : Decoder {
        var codingPath: [CodingKey]
        
        var userInfo: [CodingUserInfoKey : Any]
        let content: String
        
        public init(content: String) {
            self.content = content
        }
        
        func container<Key>(keyedBy type: Key.Type) throws -> KeyedDecodingContainer<Key> where Key : CodingKey {
            <#code#>
        }
        
        func unkeyedContainer() throws -> UnkeyedDecodingContainer {
            <#code#>
        }
        
        func singleValueContainer() throws -> SingleValueDecodingContainer {
            <#code#>
        }
        
        
    }*/
    
    func deserialize(content: String) throws -> [OpenVpnInterfaceModel] {
        
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        
        var interfaces: [OpenVpnInterfaceModel] = [OpenVpnInterfaceModel]()
        
        var currentProcessedNode: String? = nil
        var currentInterfaceName: String? = nil
        var currentConfigFile: String? = nil
        var currentDescription: String? = nil
        var isDisabled: Bool = false
        
        lines.forEach{ line in
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            
            if trimmedLine.starts(with: "openvpn") {
                currentProcessedNode = "openvpn"
                currentInterfaceName = String(trimmedLine.split(separator: " ")[1])
            }
            else if currentProcessedNode == "openvpn" && trimmedLine.starts(with: "config-file") {
                currentConfigFile = String(trimmedLine.split(separator: " ")[1])
            }
            else if currentProcessedNode == "openvpn" && trimmedLine.starts(with: "description") {
                currentDescription = String(trimmedLine.split(separator: " ")[1])
            }
            else if currentProcessedNode == "openvpn" && trimmedLine.starts(with: "disable") {
                isDisabled = true
            }
            else if currentProcessedNode == "openvpn" && trimmedLine.starts(with: "}") {
                let interface: OpenVpnInterfaceModel = OpenVpnInterfaceModel(description: currentDescription!, configFile: currentConfigFile!, isDisabled: isDisabled, name: currentInterfaceName!)
                interfaces.append(interface)
                
                currentProcessedNode = nil
                currentInterfaceName = nil
                currentConfigFile = nil
                currentDescription = nil
            }
        }
        
        return interfaces
    }
}
