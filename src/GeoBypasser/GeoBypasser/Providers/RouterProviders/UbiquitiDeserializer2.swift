//
//  UbiquitiDeserializer.swift
//  RouterWizzard
//
//  Created by Vladimir Aubrecht on 29.11.2020.
//  Copyright © 2020 Vladimir Aubrecht. All rights reserved.
//

import Foundation
import Logging

class UbiquitiDeserializer2
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
        let contentWithoutEscapeSequences = content.replacingOccurrences(of: "\"", with: "")
        
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
    
    /*
    private func convertToJson(content: String) -> String {
        let contentWithoutEscapeSequences = content.replacingOccurrences(of: "\"", with: "")  // get rid of off escape sequences for quotes, as anyway we'll add quotes manually later
        
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)

        var outputJson = ""
        
        var shouldAddBracket : Bool = false
        var lineIndex = 0
        for line in lines {
            let words = line.split(separator: " ", maxSplits: 2, omittingEmptySubsequences: true)
            
            outputJson += "\"\(words[0])\": "
            
            if words.count == 3 {  // It's array
                outputJson += "[]"
                self.getLinesToEndingCharacter(endingCharacter: "}", startIndex: lineIndex + 1, allLines: lines)
            }
            else if words[1] == "{" {  // It's start of object
                outputJson += "{"
            }
            else if words[1] == "}" {  // It's end of object
                outputJson += "},"
            }
            else {  // It's value
                outputJson += "\"\(words[1])\","
            }
            
            lineIndex += 1
        }
        
        return outputJson
    }
    
    private func getLinesToEndingCharacter(endingCharacter: String, startIndex : Int, allLines: [String.SubSequence]) -> [String] {
        var output = [String]()
        var lineIndex = 0
        var startStoring = false
        
        for line in allLines {
            let trimmedLine = line.trimmingCharacters(in: .whitespacesAndNewlines)
            if lineIndex == startIndex {
                startStoring = true
            }
            
            if (trimmedLine == endingCharacter) {
                break
            }
            
            if startStoring {
                output.append(String(line))
            }
            
            lineIndex += 1
        }
        
        return output
    }*/
}
