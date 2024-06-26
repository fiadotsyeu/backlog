//
//  Json.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 12.06.2024.
//

import SwiftUI
import SwiftData
import UniformTypeIdentifiers


class Json {
    struct JsonDocument: FileDocument {
        static var readableContentTypes: [UTType] {
            [.json]
        }
                
        var text = ""
                
        init(text: String = "") {
            self.text = text
        }
                
        init(configuration: ReadConfiguration) throws {
            if let data = configuration.file.regularFileContents {
                text = String(decoding: data, as: UTF8.self)
            } else {
                text = ""
            }
        }
                
        func fileWrapper(configuration: WriteConfiguration) throws -> FileWrapper {
            FileWrapper(regularFileWithContents: Data(text.utf8))
        }
        
        
        static func encodeToJson(_ items: [Item], _ tags: [Tag]) -> String {
            let combinedData = CombinedData(items: items, tags: tags)
            let encoder = JSONEncoder()
            encoder.outputFormatting = .prettyPrinted
            do {
                let jsonData = try encoder.encode(combinedData)
                if let jsonString = String(data: jsonData, encoding: .utf8) {
                    return jsonString
                } else {
                    print("Failed to convert JSON data to UTF-8 string")
                    return ""
                }
            } catch {
                print("Error encoding JSON: \(error)")
                return ""
            }
        }
        
        
        static func importFromJson(jsonString: String) -> (items: [Item], tags: [Tag])? {
            guard let jsonData = jsonString.data(using: .utf8) else {
                print("Failed to convert JSON string to data")
                return nil
            }
            
            do {
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = .secondsSince1970
                let combinedData = try decoder.decode(CombinedData.self, from: jsonData)
                return (combinedData.items, combinedData.tags)
            } catch {
                print("Error decoding JSON: \(error)")
                return nil
            }
        }
    }
}

struct CombinedData: Codable {
    var items: [Item]
    var tags: [Tag]
    
    init(items: [Item], tags: [Tag]) {
        self.items = items
        self.tags = tags
    }
}
