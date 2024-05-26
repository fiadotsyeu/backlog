//
//  Item.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 03.05.2024.
//

import Foundation
import SwiftData

@Model
final class Item {
    let id: String
    @Attribute(.unique) var title: String
    var subTitle: String
    var body: String
    var date: Date
    var tag: Tag
    var isFavorit: Bool
    var isPinned: Bool
    var url: String
    
    init(title: String, subTitle: String, body: String, tag: Tag, url: String) {
        self.id = UUID().uuidString
        self.title = title
        self.subTitle = subTitle
        self.body = body
        self.date = Date.now
        self.tag = tag
        self.isFavorit = false
        self.isPinned = false
        self.url = url
    }
}
