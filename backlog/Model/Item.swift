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
    var id: String
    var title: String
    var subTitle: String
    var body: String
    var date: Date
    var category: String
    var isFavorit: Bool
    
    init(title: String, subTitle: String, body: String, date: Date, category: String) {
        self.id = UUID().uuidString
        self.title = title
        self.subTitle = subTitle
        self.body = body
        self.date = Date.now
        self.category = category
        self.isFavorit = false
    }
}
