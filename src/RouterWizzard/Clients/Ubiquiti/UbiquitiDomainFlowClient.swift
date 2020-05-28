//
//  DomainFlowClient.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 07/05/2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation

public class UbiquitiDomainFlowClient {
    private let ubiquitiClient: UbiquitiClient
    
    init(ubiquitiClient: UbiquitiClient) {
        self.ubiquitiClient = ubiquitiClient
    }
    
    public func fetchDomains() throws -> [String]{
        let options = try self.fetchOptions()
        let assignableOptions = self.deserializeAssignableOptions(options: options)
        
        let ipSetOptionsValue = assignableOptions["options ipset"]!
        
        var segments = ipSetOptionsValue.split(separator: "/", omittingEmptySubsequences: true)
        segments.removeLast()
        
        return segments.map { String($0) }
    }
    
    public func addDomain(domain: String) throws {
        let options = try self.fetchOptions()
        let assignableOptions = self.deserializeAssignableOptions(options: options)
        
        var newAssignableOptions = self.addToAssignableOptions(assignableOptions: assignableOptions, name: "ipset", value: domain)
        newAssignableOptions = self.addToAssignableOptions(assignableOptions: newAssignableOptions, name: "server", value: domain)
        
        let newOptions = self.serializeAssignableOptions(assignableOptions: newAssignableOptions)
        
        try self.storeAssignableOptions(assignableOptions: newOptions)
    }
    
    public func deleteDomain(domain: String) throws {
        let options = try self.fetchOptions()
        let assignableOptions = self.deserializeAssignableOptions(options: options)
        
        var newAssignableOptions = self.removeFromAssignableOptions(assignableOptions: assignableOptions, name: "ipset", value: domain)
        newAssignableOptions = self.removeFromAssignableOptions(assignableOptions: newAssignableOptions, name: "server", value: domain)
        
        let newOptions = self.serializeAssignableOptions(assignableOptions: newAssignableOptions)
        
        try self.storeAssignableOptions(assignableOptions: newOptions)
    }

    private func addValueIntoOptionsValueString(optionsValueString: String, newValue: String) -> String
    {
        var segments = optionsValueString.split(separator: "/", omittingEmptySubsequences: true).map{String($0)}
        let groupName = segments.popLast()
        
        segments += [newValue, groupName!]
        return segments.joined(separator: "/")
    }
    
    private func removeValueFromOptionsValueString(optionsValueString: String, newValue: String) -> String
    {
        var segments = optionsValueString.split(separator: "/", omittingEmptySubsequences: true).map{String($0)}
        segments = segments.filter { $0 != newValue }
        
        return segments.joined(separator: "/")
    }
    
    private func removeFromAssignableOptions(assignableOptions: [String: String], name: String, value: String) -> [String: String]{
        let optionsName = "options \(name)"
        let optionsValue = assignableOptions[optionsName]!
        
        let newOptionsValue = self.removeValueFromOptionsValueString(optionsValueString: optionsValue, newValue: value)
        
        var output = assignableOptions
        output[optionsName] = newOptionsValue
        return output
    }
    
    private func addToAssignableOptions(assignableOptions: [String: String], name: String, value: String) -> [String: String]{
        let optionsName = "options \(name)"
        let optionsValue = assignableOptions[optionsName]!
        
        let newOptionsValue = self.addValueIntoOptionsValueString(optionsValueString: optionsValue, newValue: value)
        
        var output = assignableOptions
        output[optionsName] = newOptionsValue
        return output
    }
    
    
    private func serializeAssignableOptions(assignableOptions: [String: String]) -> [String] {
        
        var lines = [String]()
        assignableOptions.forEach { option in
            var line = option.key
            
            if (option.value != "") {
                line += "=\(option.value)"
            }
            
            lines.append(line)
        }
        
        return lines
    }
    
    private func deserializeAssignableOptions(options: [String]) -> [String: String] {
        var dict = [String: String]()
        
        options.forEach{ option in
            let splittedOption = option.split(separator: "=", omittingEmptySubsequences: true)
            let key = splittedOption[0]
            
            if (splittedOption.count > 1)
            {
                let value = splittedOption[1]
                dict.updateValue(String(value), forKey: String(key))
            }
            else
            {
                dict.updateValue("", forKey: String(key))
            }
        }
        
        return dict
    }
    
    private func fetchOptions() throws -> [String] {
        let optionsString = try self.ubiquitiClient.show(key: "service dns forwarding options")
        let optionRows = optionsString.split(separator: "\n", omittingEmptySubsequences: true)
        return optionRows.filter { $0.starts(with: "options") }.map{String($0)}
    }
    
    private func storeAssignableOptions(assignableOptions:[String]) throws {
        try self.ubiquitiClient.beginSession()
        try self.ubiquitiClient.delete(key: "service dns forwarding options")
        
        try assignableOptions.forEach { option in
            try self.ubiquitiClient.set(key: "service dns forwarding \(option)")
        }
        
        try self.ubiquitiClient.endSession()
        try self.ubiquitiClient.commit()
        try self.ubiquitiClient.save()
    }
}
