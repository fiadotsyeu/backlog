//
//  Color.swift
//  backlog
//
//  Created by Andrei Fiadotsyeu on 19.05.2024.
//

import Foundation
import SwiftData
import SwiftUI

@Model
final class ColorModel: Identifiable, Codable {
    var id = UUID()
    var red: CGFloat
    var green: CGFloat
    var blue: CGFloat
    var alpha: CGFloat

    init(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat) {
        self.red = red
        self.green = green
        self.blue = blue
        self.alpha = alpha
    }

    convenience init(color: UIColor) {
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0
        color.getRed(&red, green: &green, blue: &blue, alpha: &alpha)
        self.init(red: red, green: green, blue: blue, alpha: alpha)
    }

    var uiColor: UIColor {
        UIColor(red: red, green: green, blue: blue, alpha: alpha)
    }
    
    var swiftUIColor: Color {
        Color(uiColor)
    }

    static func from(color: Color) -> ColorModel {
        let uiColor = UIColor(color)
        return ColorModel(color: uiColor)
    }

    // Codable implementation
    enum CodingKeys: String, CodingKey {
        case id, red, green, blue, alpha
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.container(keyedBy: CodingKeys.self)
        try container.encode(id, forKey: .id)
        try container.encode(red, forKey: .red)
        try container.encode(green, forKey: .green)
        try container.encode(blue, forKey: .blue)
        try container.encode(alpha, forKey: .alpha)
    }

    required init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        id = try container.decode(UUID.self, forKey: .id)
        red = try container.decode(CGFloat.self, forKey: .red)
        green = try container.decode(CGFloat.self, forKey: .green)
        blue = try container.decode(CGFloat.self, forKey: .blue)
        alpha = try container.decode(CGFloat.self, forKey: .alpha)
    }
}
