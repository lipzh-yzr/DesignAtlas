//
//  DesignSystemModel.swift
//  Libraries
//
//  Created by wepie on 2026/4/6.
//

import Foundation
import SwiftUI
import CharcoalSwiftUI
import StructuraSwiftUI

public enum DesignSystem: Codable, Hashable, Sendable {
    case charcoal
    case structura
    
    var title: String {
        switch self {
        case .charcoal:
            "Charcoal"
        case .structura:
            "Structura"
        }
    }
    
    var author: String {
        switch self {
        case .charcoal:
            "pixiv"
        case .structura:
            "lipzh-yzr"
        }
    }
    
    var brandColor: SwiftUI.Color {
        switch self {
        case .charcoal:
            return Color(
                asset: CharcoalAsset.ColorPaletteGenerated.brand.colorAsset
            )
        case .structura:
            return Color(colorPalette: .brandDefault)
        }
    }
}
