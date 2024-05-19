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
    @Attribute(.unique) var titleKey: String
    var items: [Item]?
    var color: ColorModel
    
    init(systemImage: String, titleKey: String, color: ColorModel) {
        self.id = UUID().uuidString
        self.isSelected = false
        self.systemImage = systemImage
        self.titleKey = titleKey
        self.items = nil
        self.color = color
    }
}
