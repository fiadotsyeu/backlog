//
//  Item.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 03.05.2024.
//

import Foundation
import SwiftData

@Model
final class Item: Identifiable, Codable {
    let id: String
    @Attribute(.unique) var title: String
    var subTitle: String
    var body: String
    var createDate: Date
    var updateDate: Date
    var tag: Tag
    var isFavorite: Bool
    var isPinned: Bool
    var isArchive: Bool
    var url: String
    
    init(title: String, subTitle: String, body: String, tag: Tag, url: String) {
        self.id = UUID().uuidString
        self.title = title
        self.subTitle = subTitle
        self.body = body
        self.updateDate = Date.now
        self.createDate = Date.now
        self.tag = tag
        self.isFavorite = false
        self.isPinned = false
        self.isArchive = false
        self.url = url
    }

    enum CodingKeys: String, CodingKey {
        case id, title, subTitle, body, createDate, updateDate, tag, isFavorite, isPinned, isArchive, url
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(title, forKey: .title)
        try container.encode(subTitle, forKey: .subTitle)
        try container.encode(body, forKey: .body)
        try container.encode(createDate, forKey: .createDate)
        try container.encode(updateDate, forKey: .updateDate)
        try container.encode(tag, forKey: .tag)
        try container.encode(isFavorite, forKey: .isFavorite)
        try container.encode(isPinned, forKey: .isPinned)
        try container.encode(isArchive, forKey: .isArchive)
        try container.encode(url, forKey: .url)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(String.self, forKey: .id)
        title = try container.decode(String.self, forKey: .title)
        subTitle = try container.decode(String.self, forKey: .subTitle)
        body = try container.decode(String.self, forKey: .body)
        createDate = try container.decode(Date.self, forKey: .createDate)
        updateDate = try container.decode(Date.self, forKey: .updateDate)
        tag = try container.decode(Tag.self, forKey: .tag)
        isFavorite = try container.decode(Bool.self, forKey: .isFavorite)
        isPinned = try container.decode(Bool.self, forKey: .isPinned)
        isArchive = try container.decode(Bool.self, forKey: .isArchive)
        url = try container.decode(String.self, forKey: .url)
    }
}
