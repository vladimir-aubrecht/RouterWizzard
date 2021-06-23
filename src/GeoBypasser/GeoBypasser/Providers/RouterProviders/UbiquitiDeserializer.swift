//
//  UbiquitiDeserializer.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation
import Logging

class UbiquitiDeserializer
{
    private let logger : Logger
    
    public init(logger: Logger) {
        self.logger = logger
    }
    
    func deserialize<T: Decodable>(content: String) throws -> T {
        
        let jsonDataRaw = self.convertToJson(content: content)
        let jsonData = jsonDataRaw.data(using: .utf8)!
        let jsonString = String(decoding: jsonData, as: UTF8.self)
        self.logger.info("\(jsonString)")
        
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: jsonData)
    }
    
    private func convertToJson(content: String) -> String {
        let (jsonDataRaw, _) = convertToJsonInternal(content: content)
        return "{\(jsonDataRaw.replacingOccurrences(of: "\"\"", with: "\""))}"
    }
    
    private func convertToJsonInternal(content: String) -> (String, Int) {
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        
        var outputJson = ""
        var currentIndex = 0
        while currentIndex <  lines.count {
            let line = lines[currentIndex]
            let words = line.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
            
            if words[words.endIndex - 1] == "{" {
                let internalContent = lines[(currentIndex+1)...lines.count - 1].joined(separator: "\n")
                let (internalOutput, newIndex) = self.convertToJsonInternal(content: internalContent)

                currentIndex += newIndex
                outputJson += "\"\(words[0])\": "
                
                if words.count == 2 {
                    outputJson += "{\(internalOutput)}"
                    
                    if currentIndex < lines.count - 1 && lines[currentIndex + 1].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                        outputJson += ","
                    }
                }
                else if words.count == 3 && words[words.endIndex - 1] == "{" {
                    outputJson += "[{\"\(words[1])\": {\(internalOutput)}}"
                                        
                    if currentIndex < lines.count - 1 && lines[currentIndex + 1].trimmingCharacters(in: .whitespacesAndNewlines).starts(with: words[0]) {
                        outputJson += ","
                    }

                    while currentIndex < lines.count - 1 && lines[currentIndex+1].trimmingCharacters(in: .whitespacesAndNewlines).starts(with: words[0]) {
                        let newWords = lines[currentIndex+1].split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
                        let internalContent = lines[(currentIndex+2)...lines.count - 1].joined(separator: "\n")
                        let (internalOutput, newIndex) = self.convertToJsonInternal(content: internalContent)
                        currentIndex += newIndex + 1

                        outputJson += "{\"\(newWords[1])\": {\(internalOutput)}}"
                        
                        if currentIndex < lines.count - 1 && lines[currentIndex + 1].trimmingCharacters(in: .whitespacesAndNewlines).starts(with: words[0]) {
                            outputJson += ","
                        }
                    }
                    
                    outputJson += "]"
                    
                    if currentIndex < lines.count - 1 && lines[currentIndex + 1].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                        outputJson += ","
                    }
                }
            }
            else if words[0] == "}" {
                currentIndex += 1
                return (outputJson, currentIndex)
            }
            else {
                
                if words.count > 1 {
                    let value = words[1...words.count - 1].joined(separator: " ")
                    outputJson += "\"\(words[0])\": \"\(value)\""
                }
                else {
                    outputJson += "\"\(words[0])\": true"
                }
                
                if currentIndex < lines.count - 1 && lines[currentIndex + 1].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                    outputJson += ","
                }
            }

            currentIndex += 1
        }
        
        return (outputJson, currentIndex)
    }
}
