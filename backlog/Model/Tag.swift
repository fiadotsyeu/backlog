//
//  Tag.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 09.05.2024.
//

import SwiftData
import SwiftUI

@Model
final class Tag: Identifiable, Codable {
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

    enum CodingKeys: String, CodingKey {
        case isSelected, id, systemImage, titleKey, items, color
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(isSelected, forKey: .isSelected)
        try container.encode(id, forKey: .id)
        try container.encode(systemImage, forKey: .systemImage)
        try container.encode(titleKey, forKey: .titleKey)
        try container.encode(items, forKey: .items)
        try container.encode(color, forKey: .color)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        isSelected = try container.decode(Bool.self, forKey: .isSelected)
        id = try container.decode(String.self, forKey: .id)
        systemImage = try container.decode(String.self, forKey: .systemImage)
        titleKey = try container.decode(String.self, forKey: .titleKey)
        items = try container.decode([Item]?.self, forKey: .items)
        color = try container.decode(ColorModel.self, forKey: .color)
    }
}
