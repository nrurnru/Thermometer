//
//  View+Extensions.swift
//  Thermometer
//
//  Created by 최광현 on 2022/06/25.
//

import SwiftUI

extension View {
    func baseFont(size: FontSize) -> some View {
        return self.font(Font.system(size: size.size))
    }
}

enum FontSize {
    case small
    case middle
    case large
    
    var size: CGFloat {
        switch self {
        case .small:
            return 15
        case .middle:
            return 20
        case .large:
            return 30
        }
    }
}
