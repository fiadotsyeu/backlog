//
//  Tag.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 09.05.2024.
//

import SwiftData
import SwiftUI

@Model
final class Tag {
    var isSelected: Bool
    let id: String
    var systemImage: String
    var titleKey: String
    var items: [Item]?
    
    init(systemImage: String, titleKey: String, items: [Item]?) {
        self.id = UUID().uuidString
        self.isSelected = false
        self.systemImage = systemImage
        self.titleKey = titleKey
        self.items = items
    }
}