//
//  Tab.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 03.05.2024.
//

import SwiftUI

enum Tab: String, CaseIterable {
    case all = "All"
    case categories = "Categories"
    case settings = "Settings"
    
    var systemImage: String {
        switch self {
        case .all:
            return "list.bullet"
        case .categories:
            return "square.grid.3x3.topleft.filled"
        case .settings:
            return "gear"
        }
    }
}
