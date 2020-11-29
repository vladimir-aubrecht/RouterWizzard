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
    func deserialize<T: Decodable>(content: String) throws -> [String: T] {
        
        let jsonData = self.convertToJson(content: content).data(using: .utf8)!
        
        let decoder = JSONDecoder()
        return try! decoder.decode([String: T].self, from: jsonData)
    }
    
    private func convertToJson(content: String) -> String {
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        
        var outputJson: String = "{"
        var openedNodes = 0
        for j in 0...lines.count - 1 {
            let trimmedLine = lines[j].trimmingCharacters(in: .whitespacesAndNewlines)
            let isNextLineCloseNodeLine = j+1 >= lines.count ? true : lines[j+1].trimmingCharacters(in: .whitespacesAndNewlines) == "}"
            
            if (trimmedLine == "}") {
                for _ in 0...openedNodes {
                    outputJson += "}"
                }
                openedNodes = 0
                
                if j < lines.count - 1 {
                    outputJson += ","
                }
                
                continue
            }
            
            var words = trimmedLine.split(separator: " ", omittingEmptySubsequences: true)
            let isNode = words[words.count - 1] == "{"
            
            if (isNode) {
                words = words.dropFirst().dropLast()
                openedNodes = words.count - 1
            }
            
            var i = 0
            while (i < words.count) {
                if (isNode) {
                    outputJson += "\"" + words[i] + "\": {"
                    i += 1
                }
                else
                {
                    if i + 1 < words.count {
                        let key = words[i].replacingOccurrences(of: "-", with: "")
                        let value = words[i + 1]
                        outputJson += "\"" + key + "\": \"" + value + "\""
                        
                        if !isNextLineCloseNodeLine {
                            outputJson += ","
                        }
                        
                        i += 2
                    }
                    else {
                        outputJson += "\"" + words[i] + "\": true"
                        i += 1
                    }
                }
            }
        }
        
        outputJson += "}"
        return outputJson
    }
}
