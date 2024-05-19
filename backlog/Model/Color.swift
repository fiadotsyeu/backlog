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
final class ColorModel: Identifiable {
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
}
