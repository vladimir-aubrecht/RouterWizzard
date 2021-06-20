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
        
        let (jsonDataRaw, lastIndex) = self.convertToJson(content: content)
        let jsonData = jsonDataRaw.data(using: .utf8)!
        let jsonString = String(decoding: jsonData, as: UTF8.self)
        self.logger.info("\(jsonString)")
        
        let decoder = JSONDecoder()
        return try! decoder.decode(T.self, from: jsonData)
    }
    
    private func convertToJson(content: String) -> (String, Int) {
        let contentWithoutEscapeSequences = content.replacingOccurrences(of: "\"", with: "")  // get rid of off escape sequences for quotes, as anyway we'll add quotes manually later
        
        let lines = content.split(separator: "\n", omittingEmptySubsequences: true)
        
        var outputJson = ""
        var startIndex = 0
        for line in lines {
            let words = line.split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
            
            if words[words.endIndex - 1] == "{" {
                
                let internalContent = lines[(startIndex+1)...lines.count - 1].joined(separator: "\n")
                let (internalOutput, newIndex) = self.convertToJson(content: internalContent)
                startIndex = newIndex + 2
                
                outputJson += "\"\(words[0])\": "
                
                if words.count == 2 {
                    outputJson += "{\(internalOutput)}"
                    
                    if startIndex < lines.count - 1 && lines[startIndex + 2].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                        outputJson += ","
                    }
                }
                else if words.count == 3 && words[words.endIndex - 1] == "{" {
                    outputJson += "[{\"\(words[1])\": {\(internalOutput)}}"
                    
                    /*let word0 = String(words[0])
                    let word1 = String(words[1])
                    let line0 = String(lines[0])
                    let line1 = String(lines[1])
                    let line2 = String(lines[2])
                    let line3 = String(lines[3])
                    let line4 = String(lines[4])
                    let line5 = String(lines[5])*/
                    
                    
                    if startIndex < lines.count - 1 && lines[startIndex].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                        outputJson += ","
                    }

                    while startIndex < lines.count - 1 && lines[startIndex].trimmingCharacters(in: .whitespacesAndNewlines).starts(with: words[0]) {
                        let newWords = lines[startIndex].split(separator: " ", maxSplits: 3, omittingEmptySubsequences: true)
                        let internalContent = lines[(startIndex+1)...lines.count - 1].joined(separator: "\n")
                        let (internalOutput, newIndex) = self.convertToJson(content: internalContent)
                        startIndex += newIndex + 2

                        outputJson += "{\"\(newWords[1])\": {\(internalOutput)}}"
                        
                        if startIndex < lines.count - 1 && lines[startIndex].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                            outputJson += ","
                        }
                    }
                    
                    outputJson += "]"
                }
            }
            else if words[0] == "}" {
                return (outputJson, startIndex)
            }
            else {
                
                if words.count > 1 {
                    let value = words[1...words.count - 1].joined(separator: " ")
                    outputJson += "\"\(words[0])\": \"\(value)\""
                }
                else {
                    outputJson += "\"\(words[0])\": true"
                }
                
                if startIndex < lines.count - 1 && lines[startIndex + 2].trimmingCharacters(in: .whitespacesAndNewlines) != "}" {
                    outputJson += ","
                }
            }

            startIndex += 1
        }
        
        return (outputJson, startIndex)
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
